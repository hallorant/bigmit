; Toy program to animate a dot down the center of the screen.
;
; Expect a single block at the center of the screen moving down
; to the bottom, jumping back up to the top, then repeats.
	org $4a00
import '../lib/barden_fill.asm'
screen  equ     $3c00
char_ct equ     64*16
block	equ	$bf
blank	equ	$80
main:
        ; Clear the screen.
        ld d,$20
        ld hl,screen
        ld bc,char_ct
        call barden_fill
start:
	ld hl,screen+32	; Screen start pos
	ld de,64	; Increment (one line)
	ld a,16		; Number of lines
	ld bc,0		; Delay count
loop1:	ld (hl),block	; Block graphical char
loop2:	dec b
	jr nz,loop2
	dec c
	jr nz,loop2
	ld (hl),blank	; Blank graphical char
	add hl,de	; To next line
	dec a		; #lines - 1
	jr nz,loop1
	jr start
	end main
