; Toy program that draws some vertical lines on the screen
	org $4a00
import '../lib/barden_fill.asm'
space	equ	$20
screen	equ	$3c00
char_ct	equ	64*16
vlinel	equ	$95
vliner	equ	$aa

; Draw a vertical line at IX which should be along the
; top line of the screen.
vline:	
	ld a,16
draw:	ld (ix),vlinel
	ld bc,64
	add ix,bc
	dec a
	jr nz,draw
	ret

main:
	; Clear the screen.
	ld d,space
	ld hl,screen 
	ld bc,char_ct
	call barden_fill
	; Draw a vertical line on some columns on the screen
	ld ix,screen
	call vline
	ld ix,screen+5
	call vline
	ld ix,screen+10
	call vline
	ld ix,screen+23
	call vline
	ld ix,screen+33
	call vline
	ld ix,screen+50
	call vline
	ld ix,screen+63
	call vline
hcf:	jr hcf
	end main
