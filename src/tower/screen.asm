ifndef INCLUDE_SCREEN
INCLUDE_SCREEN equ 1

import '../lib/gp_14byte_move.asm'

; _____
;/  ___|
;\ `--.  ___ _ __ ___  ___ _ __
; `--. \/ __| '__/ _ \/ _ \ '_ \
;/\__/ / (__| | |  __/  __/ | | |
;\____/ \___|_|  \___|\___|_| |_|
;
; Defines the graphics buffer, the screen back buffer, 
; Public interface:
;  draw_gb_to_bb
;  draw_bb_to_screen
;  (and all the definitions)

screen		equ	$3c00
row		equ	64

; Position the raycasting window on the screen.
window		equ	screen+64+2
window_width	equ	27 ; WARNING much hardcoding to this value
window_height	equ	9  ; WARNING much hardcoding to this value

; This back buffer represnts a 27x9 square on the TRS-80 screen.
bb_width	equ	window_width
bb_height	equ	window_height
bb		defs	bb_width*bb_height
bb_size		equ	$-bb

; This graphics buffer represents 27x27 pixels (sort of laying on its side).
; It defines "pixels", one per byte, which are 2x1 TRS-80 graphics blocks.
; This gives us a 1:1 aspect ratio (or very close to it). We use $ff to
; set and $00 to unset a "pixel" (allowing branch-free code drawing).
; Each row of in the gb represents a column in the bb. Defining bytes, left
; to right, that fill in 2x1 screen pixels (three per screen row) from top
; to bottom of the bb.
gb_width	equ	bb_width
gb_height	equ	bb_height*3
gb		defs	gb_width*gb_height
gb_size		equ	$-gb

; hl must point to the correct position in the graphics buffer.
; @private
draw_gb_to_bb_character macro bb_dst
  ld d,$80 ; empty graphics character
  ld a,$83 ; top 2x1 dot
  and (hl)
  or d
  ld d,a   ; update character result
  inc hl
  ld a,$8c ; middle 2x1 dot
  and (hl)
  or d
  ld d,a   ; update character result
  inc hl
  ld a,$b0 ; bottom 2x1 dot
  and (hl)
  or d
  ld (bb_dst),a ; write character into the screen back buffer
  inc hl
  endm

; blts a single vertical column on the screen back buffer.
; hl must point to the start row position in the graphics buffer.
; Hardcoded to 9 rows in the screen back buffer.
; @private
draw_gb_to_bb_column macro bb_dst
  draw_gb_to_bb_character bb_dst+bb_width*0
  draw_gb_to_bb_character bb_dst+bb_width*1
  draw_gb_to_bb_character bb_dst+bb_width*2
  draw_gb_to_bb_character bb_dst+bb_width*3
  draw_gb_to_bb_character bb_dst+bb_width*4
  draw_gb_to_bb_character bb_dst+bb_width*5
  draw_gb_to_bb_character bb_dst+bb_width*6
  draw_gb_to_bb_character bb_dst+bb_width*7
  draw_gb_to_bb_character bb_dst+bb_width*8
  endm

; 21 columns of the screen (hardcoded) we blt each row out of gb.
draw_gb_to_bb macro
  ld hl,gb
  draw_gb_to_bb_column bb+0
  draw_gb_to_bb_column bb+1
  draw_gb_to_bb_column bb+2
  draw_gb_to_bb_column bb+3
  draw_gb_to_bb_column bb+4
  draw_gb_to_bb_column bb+5
  draw_gb_to_bb_column bb+6
  draw_gb_to_bb_column bb+7
  draw_gb_to_bb_column bb+8
  draw_gb_to_bb_column bb+9
  draw_gb_to_bb_column bb+10
  draw_gb_to_bb_column bb+11
  draw_gb_to_bb_column bb+12
  draw_gb_to_bb_column bb+13
  draw_gb_to_bb_column bb+14
  draw_gb_to_bb_column bb+15
  draw_gb_to_bb_column bb+16
  draw_gb_to_bb_column bb+17
  draw_gb_to_bb_column bb+18
  draw_gb_to_bb_column bb+19
  draw_gb_to_bb_column bb+20
  draw_gb_to_bb_column bb+21
  draw_gb_to_bb_column bb+22
  draw_gb_to_bb_column bb+23
  draw_gb_to_bb_column bb+24
  draw_gb_to_bb_column bb+25
  draw_gb_to_bb_column bb+26
  endm

; @private
draw_bb_row_to_screen macro bb_src,screen_dst
  gp_14byte_move bb_src, screen_dst
  ; We re-move the middle byte to use fast 14 byte moves.
  gp_14byte_move bb_src+13, screen_dst+13
  endm

; 27 columns and 9 rows (hardcoded)
draw_bb_to_screen macro
  ld (save_sp),sp
  draw_bb_row_to_screen bb+27*0,window+row*0
  draw_bb_row_to_screen bb+27*1,window+row*1
  draw_bb_row_to_screen bb+27*2,window+row*2
  draw_bb_row_to_screen bb+27*3,window+row*3
  draw_bb_row_to_screen bb+27*4,window+row*4
  draw_bb_row_to_screen bb+27*5,window+row*5
  draw_bb_row_to_screen bb+27*6,window+row*6
  draw_bb_row_to_screen bb+27*7,window+row*7
  draw_bb_row_to_screen bb+27*8,window+row*8
  ld sp,(save_sp)
  endm

endif ; INCLUDE_SCREEN
