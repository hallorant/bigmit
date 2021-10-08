; gp_keydraw.asm
;   Draws while you press a key (by George Phillips, I added "equ"s)
;
; zmac gp_keydraw.asm
; trs80gp zout/gp_keydraw.bds
screen	equ	$3c00
block	equ	$bf ; This is 1011 1111 in binary (a graphic block)

	org	$5200
start:	di			; no blinking cursor
	ld	c,block
again:	ld	hl,screen
wait:	ld	a,($38ff)	; spin if no keys pressed
	or	a
	jr	z,wait
	ld	(hl),c
	inc	hl
	ld	b,30
delay:	djnz	delay		; start with this removed
	bit	6,h
	jr	z,wait		; keep going until HL == $4000
	ld	a,c
	xor	$3f		; flip between 191 and 128
	ld	c,a
	jr	again		; go back to top of screen

	end	start
