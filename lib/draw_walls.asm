; Draws vertical lines that act as walls for a ray caster.
;
; All of this is implementation details (up top) except:
;
; draw_solid_wall_lhs : draws a vertical line in the left-hand-side
;                       graphics centered on the passed character
;                       position with the given half-height.
; draw_solid_wall_rhs : draws a vertical line in the right-hand-side
;                       graphics centered on the passed character
;                       position with the given half-height.
import 'graphics_dots.asm'

; Draws the center character position of a solid wall. The center
; character position, unlike all others, has only a one or two
; half-height. 'side' must be either 'l' for left or 'r' for right
; Entry:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; Exit:
;  c = the remaining half-height of the desired line
; @private
solid_center_wall_seg	macro	side,?hh1,?hh2
			ld a,(iy)
			; We'll hold the remaining half-height in c.
			ld c,a
			or a
			; Check if the half-height is zero.
			jr nz,?hh1
			ret
?hh1:			ld a,(ix)
			dec c
			jr nz,?hh2
			add_mid_`side`dot
			ld (ix),a
			ret
?hh2:			add_all_`side`dot
			ld (ix),a
			endm

; Draws a segment of the solid wall above and below the center character
; position. 'side' must be either 'l' for left, or 'r' for right
; Entry:
;  ix = addr of the char position above the center.
;  iy = addr of the char position below the center.
; Exit:
;  c = the remaining half-height of the desired line
; @private
solid_wall_seg		macro	side,?hh1,?hh2,?hh3
			dec c
			jr nz,?hh1
			ret
?hh1:			ld a,(iy)
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
?hh2:			dec c
			jr nz,?hh3
			add_bot2_`side`dot
			ld (ix),a
			ld a,b
			add_top2_`side`dot
			ld (iy),a
			ret
?hh3:			add_all_`side`dot
			ld (ix),a
			ld a,b
			add_all_`side`dot
			ld (iy),a
			endm

; Stepping up and down from the address passed the the ray drawing routine
; by a line (64 bytes) this routine updates the memory locations:
; Exit:
;  ix = addr of the char position above the center.
;  iy = addr of the char position below the center.
; @private
char_above_addr	defw	0
char_below_addr	defw	0
next_char_pos:	ld de,64
		ld hl,(char_below_addr)
		add hl,de
		ld (char_below_addr),hl
		ld hl,(char_above_addr)
		sbc hl,de
		ld (char_above_addr),hl
		ld ix,(char_above_addr)
		ld iy,(char_below_addr)
		ret

; Draw a vertical line with the middle postion at (ix) on the
; left-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
; @public
draw_solid_wall_lhs:	solid_center_wall_seg l
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call next_char_pos
			solid_wall_seg l
			call next_char_pos
			solid_wall_seg l
			call next_char_pos
			solid_wall_seg l
			call next_char_pos
			solid_wall_seg l
			call next_char_pos
			solid_wall_seg l
			ret

; Draw a vertical line with the middle postion at (ix) on the
; right-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
; @public
draw_solid_wall_rhs:	solid_center_wall_seg r
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call next_char_pos
			solid_wall_seg r
			call next_char_pos
			solid_wall_seg r
			call next_char_pos
			solid_wall_seg r
			call next_char_pos
			solid_wall_seg r
			call next_char_pos
			solid_wall_seg r
			ret

