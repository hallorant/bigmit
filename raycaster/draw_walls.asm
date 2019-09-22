;  _____                      __          __   _ _     
; |  __ \                     \ \        / /  | | |    
; | |  | |_ __ __ ___      __  \ \  /\  / /_ _| | |___ 
; | |  | | '__/ _` \ \ /\ / /   \ \/  \/ / _` | | / __|
; | |__| | | | (_| |\ V  V /     \  /\  / (_| | | \__ \
; |_____/|_|  \__,_| \_/\_/       \/  \/ \__,_|_|_|___/
;
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

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
; All of the code below is implementation details except:
;
; draw_solid_wall   : draws a vertical line centered on the passed addr
;                     with the given half-height.
; draw_outline_wall : draws the top and bottom dot of a vertical line
;                     centered on the passed addr with the given half-height.

; Draws the center character position of a solid wall. The center
; character position, unlike all others, has only a one or two
; half-height.
; Entry:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; Exit:
;  c = the remaining half-height of the desired line
; @private
solid_center_wall_seg	macro	?hh1,?hh2
			ld a,(iy)
			; We'll hold the remaining half-height in c.
			ld c,a
			or a
			; Check if the half-height is zero.
			jr nz,?hh1
			ret
?hh1:			dec c
			jr nz,?hh2
			ld a,$8c	; r and l mid dots.
			ld (ix),a
			ret
?hh2:			ld a,$bf	; all dots.
			ld (ix),a
			endm

; Draws the outline at the center character position of a black wall,
; if necessary. The center character position, unlike all others, has
; only a one or two half-height.
; Entry:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; Exit:
;  c = the remaining half-height of the desired line
; @private
outline_center_wall_seg	macro	?hh1,?hh2,?hh3
			ld a,(iy)
			; We'll hold the remaining half-height in c.
			ld c,a
			or a
			; Check if the half-height is zero.
			jr nz,?hh1
			ret
?hh1:			dec c
			jr nz,?hh2
			ld a,$8c	; r and l mid dots.
			ld (ix),a
			ret
?hh2:			dec c
			jr nz,?hh3
			ld a,$b3	; r and l top and bot dots.
			ld (ix),a
			ret
?hh3:			nop
			endm

; Draws a segment of the solid wall above and below the center character
; position.
; Entry:
;  ix = addr of the char position above the center.
;  iy = addr of the char position below the center.
; Exit:
;  c = the remaining half-height of the desired line
; @private
solid_wall_seg		macro	?hh1,?hh2,?hh3
			dec c
			jr nz,?hh1
			ret
?hh1:			dec c
			jr nz,?hh2
			ld a,$b0	; r and l bottom dots.
			ld (ix),a
			ld a,$83	; r and l top dots.
			ld (iy),a
			ret
?hh2:			dec c
			jr nz,?hh3
			ld a,$bc	; r and l bottom 2 dots.
			ld (ix),a
			ld a,$8f	; r and l top 2 dots.
			ld (iy),a
			ret
?hh3:			ld a,$bf	; all dots
			ld (ix),a
			ld (iy),a
			endm

; Draws the outline of a black wall above and below the center character
; position, if necessary.
; Entry:
;  ix = addr of the char position above the center.
;  iy = addr of the char position below the center.
; Exit:
;  c = the remaining half-height of the desired line
; @private
outline_wall_seg	macro	?hh2,?hh3,?hh4
			dec c
			jr nz,?hh2
			ld a,$b0	; r and l bottom dots.
			ld (ix),a
			ld a,$83	; r and l top dots.
			ld (iy),a
			ret
?hh2:			dec c
			jr nz,?hh3
			ld a,$8c	; r and l mid dots.
			ld (ix),a
			ld a,$8c	; r and l mid dots.
			ld (iy),a
			ret
?hh3:			dec c
			jr nz,?hh4
			ld a,$83	; r and l top dots.
			ld (ix),a
			ld a,$b0	; r and l bottom dots.
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

; Helpers for draw_solid_wall.
; @private
solid_wall_seg_h:	call next_char_pos
			solid_wall_seg
			ret
check_done_solid	macro
			xor a
			or c
			jr z,_draw_solid_wall
			endm

; Helpers for draw_outline_wall.
; @private
outline_wall_seg_h:	call next_char_pos
			outline_wall_seg
			ret
check_done_outline	macro
			xor a
			or c
			jr z,_draw_outline_wall
			endm

; Draw a solid vertical line with the middle postion at (ix).
; (iy) gives the half-height of the line (0,17).
; Enter:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; @public
draw_solid_wall:	solid_center_wall_seg
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call solid_wall_seg_h
			check_done_solid
			call solid_wall_seg_h
			check_done_solid
			call solid_wall_seg_h
			check_done_solid
			call solid_wall_seg_h
			check_done_solid
			call solid_wall_seg_h
_draw_solid_wall:	ret

; Draw the outline of a vertical line with the middle postion at (ix).
; (iy) gives the half-height of the line (0,17).
; Enter:
;  ix = addr of the center char position.
;  iy = addr of the half-height of the desired line
; @public
draw_outline_wall:	outline_center_wall_seg
			ld (char_above_addr),ix
			ld (char_below_addr),ix
			; We have five lines above and below the center line.
			call outline_wall_seg_h
			check_done_outline
			call outline_wall_seg_h
			check_done_outline
			call outline_wall_seg_h
			check_done_outline
			call outline_wall_seg_h
			check_done_outline
			call outline_wall_seg_h
			check_done_outline
_draw_outline_wall:	ret

