; Toy program that clears the screen using Barden's fill code.
;
; Expect a horizontal line for half of the first three lines.
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/barden_move.asm'
space	equ	$20
screen	equ	$3c00
char_ct	equ	64*16
main:
	; Clear the screen.
	ld d,space
	ld hl,screen 
	ld bc,char_ct
	call barden_fill
	; Draw a line half way across the top line of the screen.
	ld d,$8c
	ld hl,screen 
	ld bc,32 
	call barden_fill
	; Non-overlapping move to second line.
	ld hl,screen 
	ld de,screen+64	
	ld bc,32 
	call barden_move
	; Setup overlapping move on the third line.
	; 16 '*'s followed by 32 line segments.
	ld d,'*'
	ld hl,screen+64*2
	ld bc,16 
	call barden_fill
	ld d,$8c
	ld hl,screen+64*2+16
	ld bc,32 
	call barden_fill
	; Do overlapping fill, expect no '*'s after this.
	ld hl,screen+64*2+16
	ld de,screen+64*2
	ld bc,32 
	call barden_move
	; One final fill to make all three lines the same width
	ld hl,screen+64*2+32+16
	ld de,screen+64*2+32
	ld bc,16 
	call barden_move
hcf:	jr hcf
	end main
