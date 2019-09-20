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

import '../lib/barden_move.asm'
import '../lib/barden_fill.asm'
import '../lib/barden_mul16.asm'
import '../lib/barden_hexcv.asm'
import '../lib/sla16.asm'
import '../lib/srl16.asm'

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
player_dir	defb	0

; Our world is 24x24 (see world.asm).
player_x	defw	11
player_y	defw	11

frames_drawn	defw	0

title_txt	defb	'TRS-80 MODEL 1 RAYCASTING DEMONSTRATION'
title_len	equ	$-title_txt
frames_txt	defb	'FRAMES DRAWN'
frames_len	equ	$-frames_txt
pos_txt		defb	'PLAYER'
pos_len		equ	$-pos_txt
dir_txt		defb	'DIRECTION'
dir_len		equ	$-dir_txt
comma		equ	','

save_sp		defw	0
toggle		defb	1
shot		defb	0
hha		defb	5
hhb		defb	17

; Our raycasting specific modules.
import 'delta_dist.asm'
import 'draw_walls.asm'
import 'line_to_screen.asm'
import 'world.asm'

line_to_video	macro	src, dst
		; A line is 56 bytes.
		phillips_14byte_move src, dst
		phillips_14byte_move src+14, dst+14
		phillips_14byte_move src+28, dst+28
		phillips_14byte_move src+42, dst+42
		endm

main:		; Setup the static portion of the screen.

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

game_loop:	; Clear the video back buffer.
		ld d,$80
		ld hl,buff01
		ld bc,buff_line_width*11
		call barden_fill

		; Check for input from the user.
		ld a,($3840)	; A keyboard row
		ld c,a		; ...goes into c
		bit 5,c		; Check bit 5: [<-]
		jr z,tst_rarrow_key
		; User is pressing the left-arrow key (<-) so we change the
		; player's direction one to the left.
		ld a,(player_dir)
		dec a
		ld (player_dir),a
tst_rarrow_key:	bit 6,c		; Check bit 6: [->]
		jr z,raycast
		; User is pressing the right-arrow key (<-) so we change the
		; player's direction one to the right.
		ld a,(player_dir)
		inc a
		ld (player_dir),a

raycast:	; Raycast into the video back buffer.
		; TODO

		; SUPER ROUGH STUFF TO TEST BACK TO SCREEN TIMING
		; ON THE MODEL 1.

		; Draw a block.
		ld a,$bf
		ld (buff04+30),a
		ld (buff04+31),a
		ld (buff04+32),a
		ld (buff04+33),a
		ld (buff04+34),a
		ld (buff04+35),a
		ld (buff05+30),a
		ld (buff05+31),a
		ld (buff05+32),a
		ld (buff05+33),a
		ld (buff05+34),a
		ld (buff05+35),a
		ld (buff06+30),a
		ld (buff06+31),a
		ld (buff06+32),a
		ld (buff06+33),a
		ld (buff06+34),a
		ld (buff06+35),a

                ; shoot a block across the screen in a few lines
		ld a,(shot)
		inc a
		and $3f
		ld (shot),a
		ld bc,buff03
		ld hl,0
		ld l,a
		add hl,bc
		ld (hl),$bf

		; And shoot another block offset a bit.
		inc a
		and $3f
		inc a
		and $3f
		inc a
		and $3f
		inc a
		and $3f
		inc a
		and $3f
		inc a
		and $3f
		ld bc,buff08
		ld hl,0
		ld l,a
		add hl,bc
		ld (hl),$bf

		; Draw a solid line.
		ld ix,buff06+20
		ld iy,hhb
		call draw_solid_wall_lhs

                ; quick toggle some stuff
		ld a,(toggle)
		xor 1
		jr z,zero_action
		ld (toggle),a

		ld ix,buff06+50
		ld iy,hha
		call draw_outline_wall_lhs

		; Show a '3' on line 3 (should flicker)
		ld a,$33
		ld (buff03),a

		jr copy_to_screen

zero_action:	ld (toggle),a

		ld ix,buff06+51
		ld iy,hhb
		call draw_solid_wall_lhs

		; Show a '4' on line 4 (should flicker)
		ld a,$34
		ld (buff04),a
		; Show a '5' on line 5 (should flicker)
		ld a,$35
		ld (buff05),a

		; Copy the back buffer to the screen
copy_to_screen:	ld (save_sp),sp		; Save SP
		ld sp,$3ec0
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
		line_to_screen buff01,screen+64*1+4
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

		; Now go back to the top of the game loop and repeat.
		jp game_loop

		end main
