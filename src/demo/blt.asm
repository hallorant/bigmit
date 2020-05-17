  org $4000

import '../lib/barden_fill.asm'
import '../lib/gp_14byte_move.asm'

screen		equ	$3c00
row		equ	64
; Position the raycasting window on the screen.
window		equ	screen+64+3
window_width	equ	27
window_height	equ	9
bb_width	equ	window_width
bb_height	equ	window_height
gb_width	equ	window_width
gb_height	equ	window_height*3

; This graphics buffer (gb) layout differs from the back buffer (bb) and screen layout.
; It defines "pixels", one per byte, which are 2x1 TRS-80 graphics blocks. This gives us
; a 1:1 aspect ratio (or very close to it). We use $ff to set and $00 to unset a "pixel".
; Each row of in the gb represents a column in the bb. Defining bytes, left to right, that
; fill in 2x1 screen pixels (three per screen row) from top to bottom of the bb.
gb		defs	gb_width*gb_height
gb_end		equ	$

; Scroll the graphics buffer to the right one pixel.
scroll_gb macro
  ld hl,gb_end-gb_width
  ld de,gb_end
  ld bc,gb_width*gb_height-gb_width
  lddr
  endm

; This back buffer represnts a square on the TRS-80 screen.
; then this buffer is transferred onto the TRS-80 screen.
bb		defs	bb_width*bb_height

; hl must point to the positon in the graphics buffer.
draw_bb_pos macro bb_dst
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
  endm

draw_bb_vert macro gp_src,bb_dst
  ld hl,gp_src
  draw_bb_pos bb_dst+bb_width*0
  draw_bb_pos bb_dst+bb_width*1
  draw_bb_pos bb_dst+bb_width*2
  draw_bb_pos bb_dst+bb_width*3
  draw_bb_pos bb_dst+bb_width*4
  draw_bb_pos bb_dst+bb_width*5
  draw_bb_pos bb_dst+bb_width*6
  draw_bb_pos bb_dst+bb_width*7
  draw_bb_pos bb_dst+bb_width*8
  endm

gb_to_bb macro
  draw_bb_vert gb+gb_height*0,bb+bb_width*0
  draw_bb_vert gb+gb_height*1,bb+bb_width*1
  draw_bb_vert gb+gb_height*2,bb+bb_width*2
  draw_bb_vert gb+gb_height*3,bb+bb_width*3
  draw_bb_vert gb+gb_height*4,bb+bb_width*4
  draw_bb_vert gb+gb_height*5,bb+bb_width*5
  draw_bb_vert gb+gb_height*6,bb+bb_width*6
  draw_bb_vert gb+gb_height*7,bb+bb_width*7
  draw_bb_vert gb+gb_height*8,bb+bb_width*8
  draw_bb_vert gb+gb_height*9,bb+bb_width*9
  draw_bb_vert gb+gb_height*10,bb+bb_width*10
  draw_bb_vert gb+gb_height*11,bb+bb_width*11
  draw_bb_vert gb+gb_height*12,bb+bb_width*12
  draw_bb_vert gb+gb_height*13,bb+bb_width*13
  draw_bb_vert gb+gb_height*14,bb+bb_width*14
  draw_bb_vert gb+gb_height*15,bb+bb_width*15
  draw_bb_vert gb+gb_height*16,bb+bb_width*16
  draw_bb_vert gb+gb_height*17,bb+bb_width*17
  draw_bb_vert gb+gb_height*18,bb+bb_width*18
  draw_bb_vert gb+gb_height*19,bb+bb_width*19
  draw_bb_vert gb+gb_height*20,bb+bb_width*20
  endm

img32  		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$ff,$ff,$ff,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $ff,$ff,$ff,$00,$00,$00,$00,$00,$ff,$ff, $ff,$ff,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$ff,$ff,$ff,$00,$00
   		defb	$00,$00,$00,$00,$00,$ff,$ff,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$00,$ff,$ff
   		defb	$00,$00,$ff,$ff,$ff,$00,$ff,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$00,$00,$00
   		defb	$ff,$ff,$00,$00,$00,$ff,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$ff,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $00,$00,$00,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$ff,$00,$ff,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$ff,$00,$00,$ff, $00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$ff,$00,$00,$00, $ff,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$ff,$00,$00,$00,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$ff,$ff,$00,$00,$00,$00,$ff,$00, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$ff,$ff,$00,$00,$ff,$ff, $ff,$ff,$ff,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$ff,$ff,$00,$00, $00,$ff,$00,$00,$ff,$ff,$ff
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$ff,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$00,$ff,$ff,$ff,$00, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$ff,$00,$ff,$ff,$00, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$ff,$ff,$ff,$00,$ff,$00,$00,$ff, $00,$00,$ff,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$00,$00,$ff,$00,$00,$00,$ff, $00,$00,$ff,$00,$00,$00,$00
   		defb	$ff,$ff,$00,$00,$00,$00,$00,$ff,$00,$00, $00,$00,$00,$ff,$ff,$00,$00,$00,$00,$ff, $00,$00,$00,$ff,$00,$00,$00
   		defb	$00,$00,$ff,$ff,$00,$00,$00,$ff,$00,$00, $00,$ff,$ff,$00,$00,$00,$00,$00,$00,$ff, $00,$00,$00,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$ff,$00,$00,$ff,$00,$00, $ff,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$ff,$ff,$00,$00,$ff, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$ff,$ff,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$ff,$ff,$ff
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff, $ff,$ff,$ff,$00,$00,$00,$00,$00,$00,$00, $ff,$ff,$ff,$ff,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$ff,$ff,$ff,$ff,$ff,$ff,$ff, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00
   		defb	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00,$00

row_to_screen_27_bytes macro src,dst
  gp_14byte_move src, dst
  gp_14byte_move src+13, dst+13
  endm

tick	defb	0
save_sp	defw	0

; Timer interrupt handler
; Return back to ROM interrupt processing;
; the vector was set by init code above.
tick_interrupt:
  ld a,(tick)
  inc a
  ld (tick),a
  tick_jp: jp 0 ; The 0 is self-modified into the original address.

main:
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
  
  ; TODO don't need this long term -- clears back buffer
  ld d,$80
  ld hl,bb
  ld bc,bb_width*bb_height
  call barden_fill
  
  ; Setup timer interrupt Model 3 & 4.
  ; TODO move this into a call and support Model 1 VBLANK mod.
  di
  ld hl,(0x4013)
  ld (tick_jp+1),hl
  ld hl,tick_interrupt
  ld (0x4013),hl
  ei

; ----- GAME LOOP -----
_game_loop:

  ; Ready to draw the back buffer - wait for a tick.
  ld a,(tick)
  ld b,a
_wait_for_next_tick:
  ld a,(tick)
  xor b ; is a == b?
  jr z,_wait_for_next_tick

  ld (bb+3),a ; so we see something changing

  gb_to_bb

_bb_to_screen:
  ; Hard coded to 27 columns and 9 rows
  ld (save_sp),sp
  row_to_screen_27_bytes bb+27*0,window+row*0
  row_to_screen_27_bytes bb+27*1,window+row*1
  row_to_screen_27_bytes bb+27*2,window+row*2
  row_to_screen_27_bytes bb+27*3,window+row*3
  row_to_screen_27_bytes bb+27*4,window+row*4
  row_to_screen_27_bytes bb+27*5,window+row*5
  row_to_screen_27_bytes bb+27*6,window+row*6
  row_to_screen_27_bytes bb+27*7,window+row*7
  row_to_screen_27_bytes bb+27*8,window+row*8
  ld sp,(save_sp)

  jp _game_loop
  end main

