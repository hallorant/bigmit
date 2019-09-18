; Draws vertical lines that act as walls for a 11-line ray caster.
; Two types of walls are supported:
;         solid: |    outline: ·
;                | |             ·
;                |             ·
; Why two types? We want to allow drawing of running into X or Y walls in the
; raycaster in different styles -- this looks much better to the user.
;
; Walls may only take up to 11 vertical character positions on the screen.
; If displaying the top of the screen, then pass a character address on
; the 6th line of video memory (or back buffer representing the display).
;
; Why 'lhs' and 'rhs' varients below? TRS-80 graphics map vertical bars into
; two per video memory position.
;
; All of the code below is implementation details except:
;
; draw_solid_wall_lhs   : draws a vertical line in the left-hand-side
;                         graphics centered on the passed character
;                         position with the given half-height.
; draw_solid_wall_rhs   : draws a vertical line in the right-hand-side
;                         graphics centered on the passed character
;                         position with the given half-height.
; draw_outline_wall_lhs : draws the top and bottom dot of a vertical line
;                         in the left-hand-side graphics centered on the
;                         passed character position with the given half-height.
; draw_outline_wall_rhs : draws the top and bottom dot of a vertical line
;                         in the right-hand-side graphics centered on the
;                         passed character position with the given half-height.
;
; All of the above calls OR the new bits into position so that any bits set
; on the screen are not lost.
import '../lib/graphics_dots.asm'

; Draws the center character position of a solid wall. The center
; character position, unlike all others, has only a one or two
; half-height. 'side' must be either 'l' for left or 'r' for right.
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

; Draws the outline at the center character position of a black wall,
; if necessary. The center character position, unlike all others, has
; only a one or two half-height. 'side' must be either 'l' for left
; or 'r' for right.
; Entry:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; Exit:
;  c = the remaining half-height of the desired line
; @private
outline_center_wall_seg	macro	side,?hh1,?hh2,?hh3
			ld a,(iy)
			; We'll hold the remaining half-height in c.
			ld c,a
			or a
			; Check if the half-height is zero.
			jr nz,?hh1
			ret
?hh1:			dec c
			jr nz,?hh2
			ld a,(ix)
			add_mid_`side`dot
			ld (ix),a
			ret
?hh2:			dec c
			jr nz,?hh3
			ld a,(ix)
			add_topbot_`side`dot
			ld (ix),a
			ret
?hh3:			nop
			endm

; Draws a segment of the solid wall above and below the center character
; position. 'side' must be either 'l' for left or 'r' for right.
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

; Draws the outline of a black wall above and below the center character
; position, if necessary. 'side' must be either 'l' for left
; or 'r' for right.
; Entry:
;  ix = addr of the char position above the center.
;  iy = addr of the char position below the center.
; Exit:
;  c = the remaining half-height of the desired line
; @private
outline_wall_seg	macro	side,?hh2,?hh3,?hh4
			dec c
			jr nz,?hh2
			ld a,(ix)
			add_bot_`side`dot
			ld (ix),a
			ld a,(iy)
			add_top_`side`dot
			ld (iy),a
			ret
?hh2:			dec c
			jr nz,?hh3
			ld a,(ix)
			add_mid_`side`dot
			ld (ix),a
			ld a,(iy)
			add_mid_`side`dot
			ld (iy),a
			ret
?hh3:			dec c
			jr nz,?hh4
			ld a,(ix)
			add_top_`side`dot
			ld (ix),a
			ld a,(iy)
			add_bot_`side`dot
			ld (iy),a
			ret
?hh4:			nop
			endm

; Stepping up and down from the address passed the the ray drawing routine
; by a line ('buff_line_width' bytes) this routine updates the memory
; locations:
char_above_addr	defw	0
char_below_addr	defw	0
; Exit:
;  ix = addr of the char position above the center.
;  iy = addr of the char position below the center.
; @private
next_char_pos:	ld de,buff_line_width
		ld hl,(char_below_addr)
		add hl,de
		ld (char_below_addr),hl
		ld hl,(char_above_addr)
		sbc hl,de
		ld (char_above_addr),hl
		ld ix,(char_above_addr)
		ld iy,(char_below_addr)
		ret

; Implementation note: The below four sets of helpers make it possible
; to reduce macro expansion down to once for each of the four public
; calls. This greatly reduces the memory size of this module.

; Helpers for draw_solid_wall_lhs.
; @private
solid_wall_seg_lhs:	call next_char_pos
			solid_wall_seg l
			ret
check_done_solid_lhs	macro
			xor a
			or c
			jr z,_draw_solid_wall_lhs
			endm

; Helpers for draw_solid_wall_rhs.
; @private
solid_wall_seg_rhs:	call next_char_pos
			solid_wall_seg r
			ret
check_done_solid_rhs	macro
			xor a
			or c
			jr z,_draw_solid_wall_rhs
			endm

; Helpers for draw_outline_wall_lhs.
; @private
outline_wall_seg_lhs:	call next_char_pos
			outline_wall_seg l
			ret
check_done_outline_lhs	macro
			xor a
			or c
			jr z,_draw_outline_wall_lhs
			endm

; Helpers for draw_outline_wall_rhs.
; @private
outline_wall_seg_rhs:	call next_char_pos
			outline_wall_seg r
			ret
check_done_outline_rhs	macro
			xor a
			or c
			jr z,_draw_outline_wall_rhs
			endm

; Draw a vertical line with the middle postion at (ix) on the
; left-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
; Enter:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; @public
draw_solid_wall_lhs:	solid_center_wall_seg l
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call solid_wall_seg_lhs
			check_done_solid_lhs
			call solid_wall_seg_lhs
			check_done_solid_lhs
			call solid_wall_seg_lhs
			check_done_solid_lhs
			call solid_wall_seg_lhs
			check_done_solid_lhs
			call solid_wall_seg_lhs
_draw_solid_wall_lhs:	ret

; Draw a vertical line with the middle postion at (ix) on the
; right-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
; Enter:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; @public
draw_solid_wall_rhs:	solid_center_wall_seg r
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call solid_wall_seg_rhs
			check_done_solid_rhs
			call solid_wall_seg_rhs
			check_done_solid_rhs
			call solid_wall_seg_rhs
			check_done_solid_rhs
			call solid_wall_seg_rhs
			check_done_solid_rhs
			call solid_wall_seg_rhs
_draw_solid_wall_rhs:	ret

; Draw the outline of a vertical line with the middle postion
; at (ix) on the left-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
; Enter:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; @public
draw_outline_wall_lhs:	outline_center_wall_seg l
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call outline_wall_seg_lhs
			check_done_outline_lhs
			call outline_wall_seg_lhs
			check_done_outline_lhs
			call outline_wall_seg_lhs
			check_done_outline_lhs
			call outline_wall_seg_lhs
			check_done_outline_lhs
			call outline_wall_seg_lhs
			check_done_outline_lhs
_draw_outline_wall_lhs:	ret

; Draw the outline of a vertical line with the middle postion
; at (ix) on the right-hand-side graphics position of the character.
; (iy) gives the half-height of the vertical line (0,17).
; Enter:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; @public
draw_outline_wall_rhs:	outline_center_wall_seg r
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call outline_wall_seg_rhs
			check_done_outline_rhs
			call outline_wall_seg_rhs
			check_done_outline_rhs
			call outline_wall_seg_rhs
			check_done_outline_rhs
			call outline_wall_seg_rhs
			check_done_outline_rhs
			call outline_wall_seg_rhs
			check_done_outline_rhs
_draw_outline_wall_rhs:	ret

