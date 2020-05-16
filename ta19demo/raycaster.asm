;  __  __           _      _   __ 
; |  \/  |         | |    | | /_ |
; | \  / | ___   __| | ___| |  | |
; | |\/| |/ _ \ / _` |/ _ \ |  | |
; | |  | | (_) | (_| |  __/ |  | |
; |_|  |_|\___/ \__,_|\___|_|  |_|
;
;  _____                           _   _             
; |  __ \                         | | (_)            
; | |__) |__ _ _   _  ___ __ _ ___| |_ _ _ __   __ _ 
; |  _  // _` | | | |/ __/ _` / __| __| | '_ \ / _` |
; | | \ \ (_| | |_| | (_| (_| \__ \ |_| | | | | (_| |
; |_|  \_\__,_|\__, |\___\__,_|___/\__|_|_| |_|\__, |
;               __/ |                           __/ |
;              |___/                           |___/ 
;  _____                       
; |  __ \                      
; | |  | | ___ _ __ ___   ___  
; | |  | |/ _ \ '_ ` _ \ / _ \ 
; | |__| |  __/ | | | | | (_) |
; |_____/ \___|_| |_| |_|\___/
;
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

		org $4a00

import 'lib/barden_move.asm'
import 'lib/barden_fill.asm'
import 'lib/barden_mul16.asm'
import 'lib/barden_hexcv.asm'

; Address of the start of video memory.
screen		equ	$3c00

; Our video back buffer: 11 lines 56 characters wide.
; We'll center this on the screen with 4-character margin.
buff_line_width	equ	56
buff01		defs	buff_line_width
buff02		defs	buff_line_width
buff03		defs	buff_line_width
buff04		defs	buff_line_width
buff05		defs	buff_line_width
buff06		defs	buff_line_width
buff07		defs	buff_line_width
buff08		defs	buff_line_width
buff09		defs	buff_line_width
buff10		defs	buff_line_width
buff11		defs	buff_line_width

; To express the player direction (or angle) in one byte (unsigned) we
; adopt a circle with 256 divisions: (0,256].
;          0
;      -   |  -
;          |
; 192 -----+----- 64
;          |
;      -   |   -
;         128
player_dir	defb	110

; Our world is 24x24 (see world.asm).
player_x	defw	16
player_y	defw	16

frames_drawn	defw	0

demo_mode	defb	1	; 1 = yes, 0 = no.
use_vblank	defb	1	; 1 = yes, 0 = no.

title_txt	defb	'TRS-80 MODEL 1 RAYCASTING DEMONSTRATION'
title_len	equ	$-title_txt
frames_txt	defb	'FRAMES DRAWN'
frames_len	equ	$-frames_txt
pos_txt		defb	'PLAYER'
pos_len		equ	$-pos_txt
dir_txt		defb	'DIRECTION'
dir_len		equ	$-dir_txt
comma		equ	','

cast_col	defb	0
cast_camera_dir	defb	0
camera_dist_cor	defw	0
buff_addr	defw	0
cast_dir	defb	0
wall_hh		defb	0
wall_is_solid	defb	0

save_sp		defw	0

; Our raycasting modules.
import 'delta_dist.asm'
import 'dist_to_hh.asm'
import 'draw_walls.asm'
import 'line_to_screen.asm'
import 'world.asm'

import 'cast.asm'	; Depends upon the above includes

line_to_video	macro	src, dst
		; A line is 56 bytes.
		phillips_14byte_move src, dst
		phillips_14byte_move src+14, dst+14
		phillips_14byte_move src+28, dst+28
		phillips_14byte_move src+42, dst+42
		endm

		; ---------------------------------------
		; Setup the static portion of the screen.
		; ---------------------------------------
main:	di
		ld	sp,$6000

		; Clear the screen
		ld d,$80
		ld hl,screen
		ld bc,64*16
		call barden_fill

		; Frame the raycasting window on the screen.
		ld d,$b0		; Top horizontal line
		ld hl,screen+3
		ld bc,58
		call barden_fill
		ld d,$83		; Bottom horizontal line
		ld hl,screen+64*12+3
		ld bc,58
		call barden_fill
		ld a,$bf
		ld (screen+64*1+3),a	; Left vertical line
		ld (screen+64*2+3),a
		ld (screen+64*3+3),a
		ld (screen+64*4+3),a
		ld (screen+64*5+3),a
		ld (screen+64*6+3),a
		ld (screen+64*7+3),a
		ld (screen+64*8+3),a
		ld (screen+64*9+3),a
		ld (screen+64*10+3),a
		ld (screen+64*11+3),a
		ld (screen+64*1+60),a	; Right vertical line
		ld (screen+64*2+60),a
		ld (screen+64*3+60),a
		ld (screen+64*4+60),a
		ld (screen+64*5+60),a
		ld (screen+64*6+60),a
		ld (screen+64*7+60),a
		ld (screen+64*8+60),a
		ld (screen+64*9+60),a
		ld (screen+64*10+60),a
		ld (screen+64*11+60),a
		; Show the title on the screen.
		ld hl,title_txt
		ld de,screen+64*13
		ld bc,title_len
		call barden_move
		; Show 'FRAMES' on the screen.
		ld hl,frames_txt
		ld de,screen+64*14
		ld bc,frames_len
		call barden_move
		; Show 'PLAYER' on the screen.
		ld hl,pos_txt
		ld de,screen+64*14-12
		ld bc,pos_len
		call barden_move
		ld a,comma
		ld (screen+64*14-3),a
		; Show 'DIRECTION' on the screen.
		ld hl,dir_txt
		ld de,screen+64*15-12
		ld bc,dir_len
		call barden_move

		; Ensure the bit bit order for the map is corrent.
		call prepare_world

		; ----------------------------
		; Clear the video back buffer.
		; ----------------------------
game_loop:
		ld	(spsv),sp
		ld	sp,buff01+buff_line_width*11
		ld	de,$8080
		rept	buff_line_width*11/2
			push	de
		endm
		ld	sp,0
spsv	equ	$-2

		; ------------------------------
		; Check for input from the user.
		; ------------------------------
		ld a,($3840)	; A keyboard row
		ld c,a		; ...goes into c
txt_larrow:	bit 5,c		; Check bit 5: [<-]
		jr z,tst_rarrow
		; User is pressing the left-arrow key (<-) so we change the
		; player's direction one to the left.
		ld a,(player_dir)
		dec a
		dec a
		dec a
		ld (player_dir),a
tst_rarrow:	bit 6,c		; Check bit 6: [->]
		jr z,tst_a
		; User is pressing the right-arrow key (->) so we change the
		; player's direction one to the right.
		ld a,(player_dir)
		inc a
		inc a
		inc a
		ld (player_dir),a
tst_a:		ld a,($3801)	; A keyboard row
		ld c,a		; ...goes into c
		bit 1,c		; Check bit 1: [A]
		jr z,tst_d
		; Move the player EAST by one block.
		ld hl,(player_x)
		dec hl
		ld (player_x),hl
tst_d:		bit 4,c		; Check bit 4: [D]
		jr z,tst_w
		; Move the player WEST by one block.
		ld hl,(player_x)
		inc hl
		ld (player_x),hl
tst_w:		ld a,($3804)	; A keyboard row
		ld c,a		; ...goes into c
		bit 7,c		; Check bit 7: [W]
		jr z,tst_s
		; Move the player NORTH by one block.
		ld hl,(player_y)
		inc hl
		ld (player_y),hl
tst_s:		bit 3,c		; Check bit 3: [S]
		jr z,tst_t
		; Move the player SOUTH by one block.
		ld hl,(player_y)
		dec hl
		ld (player_y),hl
tst_t:		bit 4,c		; Check bit 4: [T]
		jr z,tst_v
		; Toggle demo mode.
		ld a,(demo_mode)
		xor 1
		ld (demo_mode),a
tst_v:		bit 6,c		; Check bit 6: [V]
		jr z,demo
		; Toggle use of VBLANK mod hardware.
		ld a,(use_vblank)
		xor 1
		ld (use_vblank),a

demo:		ld a,(demo_mode)
		or a
		jr z,raycast
		; In demo mode we rotate to the right all the time.
		ld a,(player_dir)
		inc a
		inc a
		inc a
		ld (player_dir),a

		; -----------------------------------
		; Raycast into the video back buffer.
		; -----------------------------------
raycast:	ld a,buff_line_width
		ld (cast_col),a		; # of columns to drawn walls for.

		ld a,64
		sub a,(buff_line_width/2)
		ld (cast_camera_dir),a	; Angle for camera correction.

		ld hl,buff06
		ld (buff_addr),hl	; First column addr in the back buffer.

		ld a,(player_dir)
		add a,256-(buff_line_width/2)
		ld (cast_dir),a		; Raycasting angle of the first column.
		
col_loop:	; Calculate the camera distance correction for this column
		; of the screen, unlike the ray distance this is independent
		; of the player's direction. It uses X delta_dist centered on
		; angle 64.
		ld a,(cast_camera_dir)
		ld c,a
		call delta_dist_x
		ld (camera_dist_cor),de

		; Cast and draw the wall at the left-hand-side of the column.
		call cast
		ld ix,(buff_addr)
		ld iy,wall_hh
		ld a,(wall_is_solid)	; Draw solid or outline wall?
		or a
		jr z,lhs_outline
		call draw_solid_wall
		jr col_next
lhs_outline:	call draw_outline_wall
		jr col_next

col_next:	; Move to next column and check if we are done drawing.
		ld a,(cast_col)
		dec a			; Decrement the # of columns left.
		jr z, copy_to_screen	; When done, copy buff to the screen.
		ld (cast_col),a
		ld a,(cast_dir)
		inc a			; Increment the raycasting angle.
		ld (cast_dir),a
		ld hl,(buff_addr)
		inc hl			; Increment the back buffer addr.
		ld (buff_addr),hl
		ld a,(cast_camera_dir)
		inc a			; Increment the camera lookup angle.
		ld (cast_camera_dir),a
		jr col_loop

		; -----------------------------------
		; Copy the back buffer to the screen.
		; -----------------------------------
copy_to_screen:	ld (save_sp),sp		; Save SP
		ld sp,$3ec0
		; Check if we are suppose to use the VBLANK hardware.
		ld a,(use_vblank)
		or a
		jr z,update_screen

		; ** Model 1 with VBLANK mod only **
		; Wait for the start of VBLANK. We want to see a 0 value to
		; Ensure we aren't jumping in at the end of VBLANK.
in_vblank:	in a,($ff)
		bit 0,a
		jr nz,in_vblank
not_in_vblank:	in a,($ff)
		bit 0,a
		jr z, not_in_vblank
		; VBLANK is beginning when we fall through to here.

		; Skipping the first line, copy the video back buffer to
		; lines 2-12 on the screen with a 4 character margin.
update_screen:	line_to_screen buff01,screen+64*1+4
		line_to_screen buff02,screen+64*2+4
		line_to_screen buff03,screen+64*3+4
		line_to_screen buff04,screen+64*4+4
		line_to_screen buff05,screen+64*5+4
		line_to_screen buff06,screen+64*6+4
		line_to_screen buff07,screen+64*7+4
		line_to_screen buff08,screen+64*8+4
		line_to_screen buff09,screen+64*9+4
		line_to_screen buff10,screen+64*10+4
		line_to_screen buff11,screen+64*11+4
		ld sp,(save_sp)		; Restore SP

		; Output stats to the screen.
		; Show the frame count drawn to the screen.
		ld hl,(frames_drawn)	; Increment value
		inc hl
		ld (frames_drawn),hl
		ld b,l			; Display on the screen
		ld a,h
		call barden_hexcv
		ld (screen+64*14+frames_len+1),hl
		ld a,b
		call barden_hexcv
		ld (screen+64*14+frames_len+3),hl
		; Show the player position on the screen.
		ld a,(player_y)
		call barden_hexcv
		ld (screen+64*14-2),hl
		ld a,(player_x)
		call barden_hexcv
		ld (screen+64*14-5),hl
		; Show the player direction on the screen.
		ld a,(player_dir)
		call barden_hexcv
		ld (screen+64*15-2),hl
		; Show we are in demo mode, if needed.
		ld a,(demo_mode)
		or a
		jr z,clear_star
		; Show a '*' on the screen to indicated we are in demo mode.
		ld a,'*'
		ld (screen+64*13+title_len+1),a
		jr vblank
clear_star:	; Clear the demo mode '*' from the screen.
		ld a,' '
		ld (screen+64*13+title_len+1),a
		; Show we are using VBLANK hardware, if needed.
vblank:		ld a,(use_vblank)
		or a
		jr z,clear_vblank
		; Show a 'V' on the screen to indicated we are in demo mode.
		ld a,'V'
		ld (screen+64*14+title_len+1),a
		jr game_cont
clear_vblank:	; Clear the VBLANK hardware use 'V' from the screen.
		ld a,' '
		ld (screen+64*14+title_len+1),a

		; ---------------------------------------------------
		; Now go back to the top of the game loop and repeat.
		; ---------------------------------------------------
game_cont:	jp game_loop

		end main
