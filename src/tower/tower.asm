  org $5200
import '../lib/barden_fill.asm'
import 'dist_to_hh.asm'
import 'screen.asm'
import 'step_dist.asm'
import 'timer.asm'

; _   _                   _           _   _____
;| | | |                 | |         | | |_   _|
;| |_| | __ _ _   _ _ __ | |_ ___  __| |   | | _____      _____ _ __ 
;|  _  |/ _` | | | | '_ \| __/ _ \/ _` |   | |/ _ \ \ /\ / / _ \ '__|
;| | | | (_| | |_| | | | | ||  __/ (_| |   | | (_) \ V  V /  __/ |
;\_| |_/\__,_|\__,_|_| |_|\__\___|\__,_|   \_/\___/ \_/\_/ \___|_|
;

stack_space	defs	100
stack		equ	$-1

; We express the player's direction (or angle) using a circle with
; 128 divisions: [0,128). One "unit" in our scheme is ~2.8125 degrees.
;          0
;      -   |  -
;          |
;  96 -----+----- 32
;          |
;      -   |   -
;          64
player_dir	defb	0
cast_dir	defb	0

; The player's location in world units.
player_x	defb	8
player_y	defb	8


main:
  ld sp,stack
  setup_timer

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
  draw_gb_to_bb

  await_vblank
  draw_bb_to_screen

  jp game_loop
  end main
