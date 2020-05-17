  org $4200

import '../lib/barden_fill.asm'
import '../lib/gp_14byte_move.asm'

stack_space	defs	100
stack		equ	$-1

screen		equ	$3c00
row		equ	64

; Position the raycasting window on the screen.
window		equ	screen+64+3
window_width	equ	27 ; WARNING some hardcoding to this value
window_height	equ	9  ; WARNING some hardcoding to this value

; This back buffer represnts a 27x9 square on the TRS-80 screen.
bb_width	equ	window_width
bb_height	equ	window_height
bb		defs	bb_width*bb_height
bb_size		equ	$-bb

; This graphics buffer (gb) layout differs from the back buffer (bb) and
; screen layout.
; It defines "pixels", one per byte, which are 2x1 TRS-80 graphics blocks.
; This gives us a 1:1 aspect ratio (or very close to it). We use $ff to
; set and $00 to unset a "pixel" (allowing branch-free code in drawing).
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
draw_gb_to_bb_char macro bb_dst
  ld d,$80 ; empty graphics character
  ld a,$83 ; top 2x1 dot
  and (hl)
  or d
  ld d,a ; update character result
  inc hl
  ld a,$8c ; middle 2x1 dot
  and (hl)
  or d
  ld d,a ; update character result
  inc hl
  ld a,$b0 ; bottom 2x1 dot
  and (hl)
  or d
  ld (bb_dst),a ; write character result to dst (in back buffer)
  inc hl
  endm

; blts a single vertical column on the screen (9 lines).
; hl must point to the start row position in the graphics buffer.
; 9 rows of the screen (hardcoded)
draw_gb_to_bb_column macro bb_dst
  draw_gb_to_bb_char bb_dst+bb_width*0
  draw_gb_to_bb_char bb_dst+bb_width*1
  draw_gb_to_bb_char bb_dst+bb_width*2
  draw_gb_to_bb_char bb_dst+bb_width*3
  draw_gb_to_bb_char bb_dst+bb_width*4
  draw_gb_to_bb_char bb_dst+bb_width*5
  draw_gb_to_bb_char bb_dst+bb_width*6
  draw_gb_to_bb_char bb_dst+bb_width*7
  draw_gb_to_bb_char bb_dst+bb_width*8
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

tick		defb	0 ; Counts ticks of the timer (30 times per second)
save_sp		defw	0

ifdef model1 ; Model 1 - poll VBLANK (if mod) or just inc tick.

m1_vblank	defb	1 ; Has VBLANK mod? 1 = yes, 0 = no.

setup_ticks macro
  ; TODO Check if maching has the VBLANK mod
  nop
  endm

wait_for_next_tick macro
  ; increment tick
  ld a,(tick)
  inc a
  ld (tick),a

  ; Check if we are suppose to use the VBLANK hardware.
  ld a,(m1_vblank)
  or a ; is a == 0?
  jr z,_wait_is_over

  ; ** Model 1 with VBLANK mod only **
  ; Wait for the start of VBLANK. We want to see a 0 value to
  ; Ensure we aren't jumping in at the end of VBLANK.
_wait_in_vblank:
  in a,($ff)
  bit 0,a
  jr nz,_wait_in_vblank
_wait_not_in_vblank:
  in a,($ff)
  bit 0,a
  jr z, _wait_not_in_vblank
  ; VBLANK is beginning when we fall through to here.
_wait_is_over:
  nop
  endm

else ; Model 3 or 4 - Use timer interrupt for ticks

; Our timer interrupt handler.
; Return back to ROM interrupt processing;
; the vector was set by init code below.
tick_interrupt:
  ld a,(tick)
  inc a
  ld (tick),a
tick_jp:
  jp 0 ; The 0 is self-modified into the original handler address.

; Setup timer interrupt Model 3 & 4.
setup_ticks macro
  di
  ld hl,(0x4013)
  ld (tick_jp+1),hl
  ld hl,tick_interrupt
  ld (0x4013),hl
  ei
  endm

wait_for_next_tick macro,?wait_loop
  ld a,(tick)
  ld b,a
?wait_loop:
  ld a,(tick)
  xor b ; is a == b?
  jr z,?wait_loop
  endm

; ticks_to_wait immediate 8bit value.
wait_ticks macro,ticks_to_wait,?wait_loop
  ld a,(tick)
  add ticks_to_wait ; future time
  ld b,a
?wait_loop:
  ld a,(tick)
  xor b ; is a == b?
  jr nz,?wait_loop
  endm

endif

main:
  ld sp,stack

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

  ; Frame the raycasting window on the screen.
  ld ix,window-row-1
  ld iy,window-row-1+row*(window_height+1)
  ld b,window_width+2
_hl_loop:
  ld (ix),$b0 ; top horizontal line
  ld (iy),$83 ; bottom horizontal line
  inc ix
  inc iy
  djnz _hl_loop

  ld ix,window-1
  ld iy,window-1+window_width+1
  ld de,row
  ld b,window_height
_vl_loop:
  ld (ix),$bb   ; left vertical line
  ld (ix-1),$8c ; decoration to left of line
  ld (iy),$b7   ; right vertical line
  ld (iy+1),$8c ; decoration to right of line
  add ix,de
  add iy,de
  djnz _vl_loop
  
  setup_ticks
  
  ; ---------------------
  ; ----- GAME LOOP -----
  ; ---------------------
_game_loop:
  animate_img_to_gb
  draw_gb_to_bb

  wait_for_next_tick
  draw_bb_to_screen

  jp _game_loop
  end main
