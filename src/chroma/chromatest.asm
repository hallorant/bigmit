 org	$5c00
import '../lib/barden_fill.asm'
import '../lib/barden_move.asm'

STATUS  EQU     79H     ;READ STATUS PORT
REG     EQU     79H     ;WRITE REG PORT
ADDR    EQU     79H     ;WRITE VRAM DATA ADDR
DATA    EQU     78H     ;READ/WRITE VRAM DATA

PORTON	PUSH	AF	;ENABLE SYSTEM I/O BUS
	LD	A,10H
	OUT	(0ECH),A
	IN	A,(REG)	;TMS9918A STATUS
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
status_txt	defb    '  $0000 set to $00 read back $00'
status_len	equ     $-status_txt
pf_txt		defb    '  Pass count $0000 Fail count $0000'
pf_len		equ     $-pf_txt
log_txt		defb    '$0000->[$00] '
log_len		equ     $-log_txt

chroma_addr	defw	0
chroma_pass	defw	0
chroma_fail	defw	0

log_addr_start	equ	screen+row*5
log_addr	defw	log_addr_start

test_addr	defw	0
test_byte	defb	0
read_byte	defb	0


; reads and writes a memory location on the chroma board updates
; status_txt with the outcome.
; hl chroma address
; a byte to write
chroma_mem:
  ld (test_addr),hl
  ld (test_byte),a

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
  ld hl,(test_addr)
  ld a,(test_byte)
  call RAMOUT
  xor a ; clear a
  ld hl,(test_addr)
  call RAMIN
  ld (read_byte),a
  ld hl,status_txt+30
  call barden_hexcv

  ; Show the memory test status text on the screen.
  ld hl,status_txt
  ld de,screen+64*3
  ld bc,status_len
  call barden_move

  ld a,(read_byte)
  ld c,a
  ld a,(test_byte)
  cp c
  jr z,pass
fail:
  ld hl,(chroma_fail)
  inc hl
  ld (chroma_fail),hl
  call output_fail_log
  ret
pass:
  ld hl,(chroma_pass)
  inc hl
  ld (chroma_pass),hl
  ret

output_fail_log:
  ld a,(read_byte)
  ld hl,log_txt+9
  call barden_hexcv
  ld hl,(test_addr)
  ld a,h
  ld hl,log_txt+1
  call barden_hexcv
  ld hl,(test_addr)
  ld a,l
  ld hl,log_txt+3
  call barden_hexcv

  ; output log about a failure
  ld hl,log_txt
  ld de,(log_addr)
  ld bc,log_len
  call barden_move

  ld hl,(log_addr)
  ld d,0
  ld e,log_len
  add hl,de
  ld (log_addr),hl

  ; Check if we went off the screen
  ld hl,(log_addr)
  ld a,h
  cp $3f
  ret c ; a < $3f
  ld hl,(log_addr)
  ld a,l
  cp $f0
  ret c
  ret z
  ld hl,log_addr_start
  ld (log_addr),hl
  ret

output_pass_fail:
  ld hl,(chroma_pass)
  ld a,h
  ld hl, pf_txt+14
  call barden_hexcv
  ld hl,(chroma_pass)
  ld a,l
  ld hl, pf_txt+16
  call barden_hexcv
  ld hl,(chroma_fail)
  ld a,h
  ld hl, pf_txt+31
  call barden_hexcv
  ld hl,(chroma_fail)
  ld a,l
  ld hl, pf_txt+33
  call barden_hexcv

  ; Show the pass/fail counts on the screen.
  ld hl,pf_txt
  ld de,screen+64*4
  ld bc,pf_len
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

memtest:
  ld c,0
wait:
  nop
  nop
  djnz wait

  ld hl,(chroma_addr)
  ld a,$a5 ; 1010_0101
  call chroma_mem

  ld hl,(chroma_addr)
  inc hl
  ; loop around after 16K
  ld a,h
  and $3f ; 0011_1111
  ld h,a
  ld (chroma_addr),hl

  call output_pass_fail
  jp memtest
  end main
