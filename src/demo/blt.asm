; BLT demo program
;
; Terms:
; gb = graphics buffer our sideways representation of pixels.
; bb = screen back buffer of a 27x9 window of the screen.
  org $5200

import '../lib/barden_fill.asm'
import '../lib/gp_14byte_move.asm'
import '../lib/gp_get_trs80_model.asm'
import '../lib/m1_vblank.asm'

stack_space	defs	100
stack		equ	$-1

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

img32  		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$ff,$ff,$ff,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $ff,$ff,$ff,$00,$00,$00,$00,$00,$ff,$ff, $ff,$ff,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$ff,$ff,$ff,$00,$00
   		defb	$00,$00,$00,$00,$00,$ff,$ff,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$ff,$ff
   		defb	$00,$00,$ff,$ff,$ff,$00,$ff,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $00,$00,$00,$00,$00,$00,$00
   		defb	$ff,$ff,$00,$00,$00,$ff,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$ff,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$ff,$00,$ff,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$ff,$00,$00,$ff, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$ff,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$ff,$ff,$00,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$ff,$ff,$00,$00,$00,$00, $ff,$ff,$ff,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$ff,$ff,$00,$ff, $00,$00,$00,$00,$ff,$ff,$ff
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$ff,$ff,$ff, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$ff,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$ff,$ff,$ff, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$ff,$00,$00,$ff, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$ff,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$ff,$ff,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$ff,$ff,$ff,$ff,$00,$00,$00,$ff,$00,$00, $00,$ff,$ff,$00,$00,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$ff,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$ff,$ff,$00,$00,$ff, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$ff,$ff,$ff
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $ff,$ff,$ff,$00,$00,$00,$00,$00,$00,$00, $ff,$ff,$ff,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00

pat32  		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff
		defb	$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff, $00,$ff,$00,$ff,$00,$ff,$00
		defb	$ff,$00,$00,$00,$ff,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$ff,$00,$00
		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
		defb	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $ff,$ff,$ff,$ff,$ff,$ff,$ff

img_col		defb	0

; Scroll the graphics buffer to the right one pixel.
scroll_gb_right_one_pixel macro
  ld hl,gb+gb_size-1-gb_width
  ld de,gb+gb_size-1
  ld bc,gb_size-gb_width
  lddr
  endm

animate_img_to_gb macro
  scroll_gb_right_one_pixel
  ld hl,img32
  ; Deterine which column of the image to add
  ld c,$1f ; 0001_1111 (mask)
  ld a,(img_col)
  inc a
  and c
  ld (img_col),a
  or a ; is a == 0?
  jr z,_img_col_draw

  ld b,a ; columns over
  ld de,gb_width
_img_ptr_loop:
  add hl,de
  djnz _img_ptr_loop
_img_col_draw:
  ld de,gb
  ld bc,gb_width
  ldir
  endm

; hl must point to the correct position in the graphics buffer.
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

save_sp		defs	2
trs80_model	defb	0 ; TRS80 Model? 1 = Model 1, 3 = Model 3, 4 = Model 4
m1_vblank	defb	0 ; Has the Model 1 VBLANK mod? 1 = yes, 0 = no.
m34_ticks	defb	0 ; Counts ticks of the timer (30 times per second)

; Our timer interrupt handler.
; Return back to ROM interrupt processing;
; the vector was set by init code below.
m34_ticks_interrupt:
  push af
  ld a,(m34_ticks)
  inc a
  ld (m34_ticks),a
  pop af
tick_jp:
  jp 0 ; The 0 is self-modified into the original handler address.

; Setup the 30 times/sec timer interrupt Model 3 & 4.
m34_setup_ticks macro
  di
  ld hl,(0x4013)
  ld (tick_jp+1),hl
  ld hl,m34_ticks_interrupt
  ld (0x4013),hl
  ei
  endm

wait_for_next_tick macro ?m34_wait,?m34_wait_loop,?done_waiting
  ld a,(trs80_model)
  xor 1 ; is a == 1 (Model 1)?
  jr nz,?m34_wait
  ; Check if we are suppose to use the VBLANK hardware.
  ld a,(m1_vblank)
  or a ; is a == 0 (no)?
  jr z,?done_waiting
  wait_for_vblank_start
  jr ?done_waiting
?m34_wait:
  ld a,(m34_ticks)
  ld b,a
?m34_wait_loop:
  ld a,(m34_ticks)
  xor b ; is a == b?
  jr z,?m34_wait_loop
?done_waiting:
  endm

main:
  ld sp,stack

  ; Save TRS80 Model and, if a Model 1, if the VBLANK mod is installed.
  call gp_get_trs80_model
  ld (trs80_model),a
  xor 1
  jr nz,_m34_interrupt_setup
  call detect_m1_vblank
  ld (m1_vblank),a
  jr prep_screen
_m34_interrupt_setup:
  m34_setup_ticks

prep_screen:
  ; Clear the graphics buffer
  ld d,$00
  ld hl,gb
  ld bc,gb_size
  call barden_fill

  ; Clear the back buffer
  ld d,$80
  ld hl,bb
  ld bc,bb_size
  call barden_fill

  ; Clear the screen
  ld d,$80
  ld hl,screen
  ld bc,row*16
  call barden_fill

  ld a,'>'
  ld (screen+row*3),a

  ; Frame the raycasting window on the screen.
  ld ix,window-row-1
  ld iy,window-row-1+row*(window_height+1)
  ld b,window_width+2
hline_loop:
  ld (ix),$b0 ; top horizontal line
  ld (iy),$83 ; bottom horizontal line
  inc ix
  inc iy
  djnz hline_loop

  ld ix,window-1
  ld iy,window-1+window_width+1
  ld de,row
  ld b,window_height
vline_loop:
  ld (ix),$bb   ; left vertical line
  ld (iy),$b7   ; right vertical line
  add ix,de
  add iy,de
  djnz vline_loop
  
  ; ---------------------
  ; ----- GAME LOOP -----
  ; ---------------------
game_loop:
  animate_img_to_gb
  draw_gb_to_bb

  wait_for_next_tick
  draw_bb_to_screen

  jp game_loop
  end main
