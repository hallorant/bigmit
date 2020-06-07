ifndef INCLUDE_MAPS
INCLUDE_MAPS equ 1

; _ __ ___   __ _ _ __  ___ 
;| '_ ` _ \ / _` | '_ \/ __|
;| | | | | | (_| | |_) \__ \
;|_| |_| |_|\__,_| .__/|___/
;                | |
;                |_|

; Checks if the bit in byte is the value we should return. Reduces pos by one
; and logical shifts byte right one bit to get ready for the next call.
; Returns if the correct bit is found.
;
; byte is the tabel lookup byte.
; pos  position 1-8 of bit in byte.
check_bit	macro byte,pos,?ret0value,?cont
		dec pos
		jr nz,?cont
		bit 0,byte
		jr z,?ret0value
		ld a,1
		ret
?ret0value:	ld a,0
		ret
?cont:		srl byte
		endm

; Checks if the passed row and column are a wall in the world.
; Enter: l  The row in the world (y value).
;        c  The column in the world (x value).
; Exit:  a  Wall value (0 or $FF).
;
; Note: currently not called but inlined in cast.asm

is_wall:
	ld	a,high($6000)
	add	l
	ld	h,a
	ld	l,c
	ld	a,(hl)
	ret

; Called once to convert the world map bits into page-aligned array
; of bytes.
; This allows the
; map to be easier for humans to work on and is only done at program
; start so it won't hurt performance of the raycaster.

active_map_address	equ	$ea00

; Entry: hl  pointer to map to load
load_map:
  ld d,high(active_map_address)
  ld c,21 ; rows in a map
_ylp:
  ld b,3  ; bytes per column in a map
  ld e,low(active_map_address)
_xlp:
  scf
  rl (hl)
_blp:
  sbc a,a
  ld (de),a
  inc e
  sla (hl)
  jr nz,_blp
  inc hl
  djnz _xlp
  inc d
  dec c
  jr nz,_ylp
  ret

; ---------------
; -- GAME MAPS --
; ---------------

map_empty	defb	1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1  ;  0
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  1  
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  2 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  3 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  4 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  5 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  6 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  7 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  8 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ;  9 
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 10
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 11
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 12
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 13
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 14
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 15
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 16
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 17
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 18
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 19
		defb	1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,1  ; 20
		defb	1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1  ; 21

endif ; INCLUDE_MAPS
