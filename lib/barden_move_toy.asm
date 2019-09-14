; Toy program that clears the screen using Barden's fill code.
	org $4a00
import 'barden_fill.asm'
space	equ	$20
screen	equ	$3c00
char_ct	equ	64*16
main:
	ld d, space
	ld hl, screen 
	ld bc, char_ct
	call barden_fill
hcf:	jr hcf
	end main
