; Toy program that draws some vertical lines on the screen
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/graphics_dots.asm'
blank		equ	$80
screen		equ	$3c00
screen_mid	equ	screen+64*5
hh1		defb	1
hh2		defb	2
hh3		defb	3
hh4		defb	4
hh5		defb	5
hh6		defb	6
hh7		defb	7
hh8		defb	8
hh9		defb	9
hh10		defb	10
hh11		defb	11
hh12		defb	12
hh13		defb	13
hh14		defb	14
hh15		defb	15
hh16		defb	16
hh17		defb	17
hh18		defb	18

; The center character position has one or two half-height.
; side = 'l' for left, or 'r' for right
draw_mid_char	macro	side,?hh1,?hh2
		ld a,(iy)
		; We'll hold the remaining half-height in c.
		ld c,a
		or a
		; Check if the half-height is zero.
		jr nz,?hh1
		ret
?hh1:		ld a,(ix)
		dec c
		jr nz,?hh2
		add_mid_`side`dot
		ld (ix),a
		ret
?hh2:		add_all_`side`dot
		ld (ix),a
		endm

; side = 'l' for left, or 'r' for right
; ix = addr of the char position above the center.
; iy = addr of the char position below the center.
draw_char	macro	side,?hh1,?hh2,?hh3
		dec c
		jr nz,?hh1
		ret
?hh1:		ld a,(iy)
		ld b,a
		ld a,(ix)
		dec c
		jr nz,?hh2
		add_bot_`side`dot
		ld (ix),a
		ld a,b
		add_top_`side`dot
		ld (iy),a
		ret
?hh2:		dec c
		jr nz,?hh3
		add_bot2_`side`dot
		ld (ix),a
		ld a,b
		add_top2_`side`dot
		ld (iy),a
		ret
?hh3:		add_all_`side`dot
		ld (ix),a
		ld a,b
		add_all_`side`dot
		ld (iy),a
		endm

; This saves the center character postion.
char_above_addr	defw	0
char_below_addr	defw	0

next_char_pos	macro
		ld de,64
		ld hl,(char_below_addr)
		add hl,de
		ld (char_below_addr),hl
		ld hl,(char_above_addr)
		sbc hl,de
		ld (char_above_addr),hl
		ld ix,(char_above_addr)
		ld iy,(char_below_addr)
		endm

; Draw a vertical line with the middle postion at (ix) on the
; left-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
ray_lhs:	draw_mid_char l
		ld (char_above_addr),ix
		ld (char_below_addr),ix
		next_char_pos
		draw_char l
		next_char_pos
		draw_char l
		next_char_pos
		draw_char l
		next_char_pos
		draw_char l
		next_char_pos
		draw_char l

; Draw a vertical line with the middle postion at (ix) on the
; right-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
ray_rhs:	draw_mid_char r
		ld (char_above_addr),ix
		ld (char_below_addr),ix
		next_char_pos
		draw_char r
		next_char_pos
		draw_char r
		next_char_pos
		draw_char r
		next_char_pos
		draw_char r
		next_char_pos
		draw_char r
		ret
main:
	; Clear the screen.
	ld d,blank
	ld hl,screen 
	ld bc,64*16
	call barden_fill
	; Draw a vertical line on some columns on the screen
	ld ix,screen_mid+6
	ld iy,hh1
	call ray_lhs
	ld ix,screen_mid+6
	ld iy,hh2
	call ray_rhs

	ld ix,screen_mid+7
	ld iy,hh3
	call ray_lhs
	ld ix,screen_mid+7
	ld iy,hh4
	call ray_rhs

	ld ix,screen_mid+8
	ld iy,hh5
	call ray_lhs
	ld ix,screen_mid+8
	ld iy,hh6
	call ray_rhs

	ld ix,screen_mid+9
	ld iy,hh7
	call ray_lhs
	ld ix,screen_mid+9
	ld iy,hh8
	call ray_rhs

	ld ix,screen_mid+10
	ld iy,hh9
	call ray_lhs
	ld ix,screen_mid+10
	ld iy,hh10
	call ray_rhs

	ld ix,screen_mid+11
	ld iy,hh11
	call ray_lhs
	ld ix,screen_mid+11
	ld iy,hh12
	call ray_rhs

	ld ix,screen_mid+12
	ld iy,hh13
	call ray_lhs
	ld ix,screen_mid+12
	ld iy,hh14
	call ray_rhs

	ld ix,screen_mid+13
	ld iy,hh15
	call ray_lhs
	ld ix,screen_mid+13
	ld iy,hh16
	call ray_rhs

	ld ix,screen_mid+14
	ld iy,hh17
	call ray_lhs
	ld ix,screen_mid+14
	ld iy,hh18
	call ray_rhs

hcf:	jr hcf
	end main
