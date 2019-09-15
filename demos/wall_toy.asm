; Toy program that draws some vertical lines on the screen
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/draw_walls.asm'
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

main:
	; Clear the screen.
	ld d,blank
	ld hl,screen 
	ld bc,64*16
	call barden_fill
	; Draw a vertical line on some columns on the screen
	ld ix,screen_mid+6
	ld iy,hh1
	call draw_solid_wall_lhs
	ld ix,screen_mid+6
	ld iy,hh2
	call draw_solid_wall_rhs

	ld ix,screen_mid+7
	ld iy,hh3
	call draw_solid_wall_lhs
	ld ix,screen_mid+7
	ld iy,hh4
	call draw_solid_wall_rhs

	ld ix,screen_mid+8
	ld iy,hh5
	call draw_solid_wall_lhs
	ld ix,screen_mid+8
	ld iy,hh6
	call draw_solid_wall_rhs

	ld ix,screen_mid+9
	ld iy,hh7
	call draw_solid_wall_lhs
	ld ix,screen_mid+9
	ld iy,hh8
	call draw_solid_wall_rhs

	ld ix,screen_mid+10
	ld iy,hh9
	call draw_solid_wall_lhs
	ld ix,screen_mid+10
	ld iy,hh10
	call draw_solid_wall_rhs

	ld ix,screen_mid+11
	ld iy,hh11
	call draw_solid_wall_lhs
	ld ix,screen_mid+11
	ld iy,hh12
	call draw_solid_wall_rhs

	ld ix,screen_mid+12
	ld iy,hh13
	call draw_solid_wall_lhs
	ld ix,screen_mid+12
	ld iy,hh14
	call draw_solid_wall_rhs

	ld ix,screen_mid+13
	ld iy,hh15
	call draw_solid_wall_lhs
	ld ix,screen_mid+13
	ld iy,hh16
	call draw_solid_wall_rhs

	ld ix,screen_mid+14
	ld iy,hh17
	call draw_solid_wall_lhs
	ld ix,screen_mid+14
	ld iy,hh18
	call draw_solid_wall_rhs

	ld ix,screen_mid+40
	ld iy,hh1
	call draw_outline_wall_lhs
	ld ix,screen_mid+40
	ld iy,hh2
	call draw_outline_wall_rhs

	ld ix,screen_mid+41
	ld iy,hh3
	call draw_outline_wall_lhs
	ld ix,screen_mid+41
	ld iy,hh4
	call draw_outline_wall_rhs

	ld ix,screen_mid+42
	ld iy,hh5
	call draw_outline_wall_lhs
	ld ix,screen_mid+42
	ld iy,hh6
	call draw_outline_wall_rhs

	ld ix,screen_mid+43
	ld iy,hh7
	call draw_outline_wall_lhs
	ld ix,screen_mid+43
	ld iy,hh8
	call draw_outline_wall_rhs

	ld ix,screen_mid+44
	ld iy,hh9
	call draw_outline_wall_lhs
	ld ix,screen_mid+44
	ld iy,hh10
	call draw_outline_wall_rhs

	ld ix,screen_mid+45
	ld iy,hh11
	call draw_outline_wall_lhs
	ld ix,screen_mid+45
	ld iy,hh12
	call draw_outline_wall_rhs

	ld ix,screen_mid+46
	ld iy,hh13
	call draw_outline_wall_lhs
	ld ix,screen_mid+46
	ld iy,hh14
	call draw_outline_wall_rhs

	ld ix,screen_mid+47
	ld iy,hh15
	call draw_outline_wall_lhs
	ld ix,screen_mid+47
	ld iy,hh16
	call draw_outline_wall_rhs

	ld ix,screen_mid+48
	ld iy,hh17
	call draw_outline_wall_lhs
	ld ix,screen_mid+48
	ld iy,hh18
	call draw_outline_wall_rhs

hcf:	jr hcf
	end main
