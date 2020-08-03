 org	$5c00
import '../lib/barden_fill.asm'
import '../lib/barden_move.asm'

STATUS  EQU     79H     ;READ STATUS PORT
REG     EQU     79H     ;WRITE REG PORT
ADDR    EQU     79H     ;WRITE VRAM DATA ADDR
DATA    EQU     78H     ;READ/WRITE VRAM DATA

chroma_status	defb	0

WAIT:
  push bc
  ld b,0
_outer:
  ld c,0
_inner:
  nop
  nop
  djnz _inner
  dec b
  jr z,_outer
  pop bc
  ret

LONG_WAIT:
  push bc
  ld b,0
_lw0:
  call WAIT
  djnz _lw0
  pop bc
  ret

PORTON	PUSH	AF	;ENABLE SYSTEM I/O BUS
	LD	A,10H
	OUT	($EC),A
	IN	A,(REG)	;TMS9918A STATUS
	LD	(chroma_status),a
	POP	AF
	RET
;
; ROUTINE TO WRITE AN ADDRESS IN VRAM
; ADDRESS IN HL, DATA IN A
RAMOUT	CALL	PORTON	;ENABLE I/O BUS
	LD	C,REG	;WRITE REG PORT
	SET	6,H	;SEE TABLE 2-1 OF TMS9918A MANUAL
	RES	7,H
	OUT	(C),L	;OUTPUT ADDRESS
	OUT	(C),H
        NOP
	OUT	(DATA),A	;SEND DATA TO VRAM
	RET
;
; ADDRESS IN HL, DATA RETURNED IN A
RAMIN	CALL	PORTON
	LD	C,REG	;WRITE REG PORT
	RES	6,H	;SEE TABLE 2-1 OF TMS9918A MANUAL
	RES	7,H
	OUT	(C),L
	OUT	(C),H
        NOP
	IN	A,(DATA)	;GET DATA
	RET

;
; ROUTINE TO WRITE DATA TO A REGISTER
; DATA IN A, REG # IN B
REGOUT  CALL    PORTON  ;SEE TABLE 2-1 OF TMS9918A MANUAL
        OUT     (REG),A
        LD      A,B
        OR      80H
        OUT     (REG),A
        RET

;
; ROUTINE TO INITILIZE MODE 2 GRAPHICS
;
MODE2   LD      HL,M2TBL        ;DATA
        LD      B,6             ;REGISTER #
LP0     LD      A,(HL)
        CALL    REGOUT  ;OUT DATA TO REGISTERS
        INC     HL
        DEC     B
        JP      P,LP0
        RET
;
M2TBL   DEFB    7       ;SEE SECTIONS 2.2 TO 2.7 OF
        DEFB    56      ;TMS9918A MANUAL
        DEFB    3
        DEFB    255
        DEFB    6
        DEFB    0C2H
        DEFB    2


; ------------------------------------------------------------------
; Subroutine to covert 1 byte into a hex value in ASCII. This has been
; modified from the book so that the output goes into a buffer.
;
; Author: William Barden, Jr.
;         'TRS-80 Assembly-Language Programming', 1979 pg 198.
;
; Entry: a   Byte to be converted.
;        hl  Pointer to the start of a two-byte buffer.
; Exit:  hl  hl+2
barden_hexcv:
  ld c,a     ; Save two hex digits
  srl a      ; Align high digit
  srl a
  srl a
  srl a
  call _cvt  ; Convert to ASCII
  ld (hl),a
  inc hl
  ld a,c     ; Restore original
  and $0f    ; Get low digit
  call _cvt  ; Convert to ASCII
  ld (hl),a
  inc hl
  ret
_cvt:
  add a,$30  ; Conversion factor
  cp $3a
  jr c,_cvt_is_done
  add a,7
_cvt_is_done:
  ret

screen		equ     $3c00
row		equ     64

title_txt	defb    'TRS-80 CHROMATRS CHECKOUT'
title_len	equ     $-title_txt
memory_txt	defb    'CHROMATRS MEMORY:'
memory_len	equ     $-memory_txt
status_txt	defb    '  $0000 set to $00'
status_len	equ     $-status_txt
bad_byte_txt	defb	'  $00 bad bytes'
bad_byte_len	equ     $-bad_byte_txt

chroma_addr	defw	0
chroma_pass	defw	0
chroma_fail	defw	0

log_addr_start	equ	screen+row*5
log_addr	defw	log_addr_start

test_page	defb	0
test_addr	defw	0
test_byte	defb	$a5
read_byte	defb	0

bad_byte_ct	defb	0

; reads and writes a 256-byte memory block on the chroma board updates
; status_txt with the outcome.
; a - msb of chroma address to write block
chroma_mem:
  ld h,a
  ld l,0
  ld (test_addr),hl

  ld a,h
  ld hl,status_txt+3
  call barden_hexcv
  ld hl,(test_addr)
  ld a,l
  ld hl,status_txt+5
  call barden_hexcv
  ld a,(test_byte)
  ld hl,status_txt+16
  call barden_hexcv

  ; Show the memory test status text on the screen.
  ld hl,status_txt
  ld de,screen+64*3
  ld bc,status_len
  call barden_move

  ; Output the first byte.
  ld hl,(test_addr)
  ld a,(test_byte)
  call RAMOUT
  ; Output 254 bytes now that autoincrement addr is setup.
  ld b,$ff
_write_block:
  out (DATA),a
  djnz _write_block ; 254 times

  call LONG_WAIT

  call reset_log

  ; Input the first byte.
  xor a
  ld hl,(test_addr)
  call RAMIN
  call log_byte
  ; Input 254 bytes now that autoincrement addr is setup.
  ld b,$ff
_read_block:
  in a,(DATA)
  call log_byte
  djnz _read_block ; 254 times
  ret

log_byte:
  push af
  push hl
  push bc
  push af
  ld hl,(log_addr)
  push hl
  call barden_hexcv
  pop hl
  inc hl
  inc hl
  ld (log_addr),hl
  pop af
  cp $a5
  jr z,_log_wait
  ld a,(bad_byte_ct)
  inc a
  ld (bad_byte_ct),a
_log_wait:
  call output_bad_byte_count
  call WAIT
  pop bc
  pop hl
  pop af
  ret

reset_log:
  push af
  push hl
  push bc
  ld a,0
  ld (bad_byte_ct),a
  ld hl,log_addr_start
  ld (log_addr),hl
  ld c,2
_outerr:
  ld b,0
_innerr:
  ld (hl),$70
  djnz _innerr
  dec c
  jr z,_outerr
  pop bc
  pop hl
  pop af
ret

output_bad_byte_count:
  ld a,(bad_byte_ct)
  ld hl, bad_byte_txt+3
  call barden_hexcv

  ; Show the bad byte count on the screen.
  ld hl,bad_byte_txt
  ld de,screen+64*15
  ld bc,bad_byte_len
  call barden_move
  ret

main:
  ; Clear the screen
  ld d,$80
  ld hl,screen
  ld bc,row*16
  call barden_fill

  ; Show the title on the screen.
  ld hl,title_txt
  ld de,screen
  ld bc,title_len
  call barden_move

  ; Show the memory test text on the screen.
  ld hl,memory_txt
  ld de,screen+64*2
  ld bc,memory_len
  call barden_move

  call MODE2

memtest:

  ld a,(test_page)
  call chroma_mem

  ld a,(test_page)
  inc a
  ; loop around after 16K
  and $3f ; 0011_1111
  ld (test_page),a
  jr memtest

  end main
