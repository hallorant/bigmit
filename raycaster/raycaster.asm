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
import '../lib/barden_hexcv.asm'
import '../lib/draw_walls.asm'
import '../lib/phillips_14byte_move.asm'

screen		equ	$3c00
; An 11-line video back buffer.
buff01		defs	64
buff02		defs	64
buff03		defs	64
buff04		defs	64
buff05		defs	64
buff06		defs	64
buff07		defs	64
buff08		defs	64
buff09		defs	64
buff10		defs	64
buff11		defs	64

; 0 means up, circle divided into 256 divisions.
player_dir	defb	0
player_x	defw	0
player_y	defw	0

pos_text	defb	'PLAYER'	; 6
dir_text	defb	'DIRECTION'	; 9
comma		equ	','

save_sp		defw	0
toggle		defb	1
shot		defb	0
hha		defb	5
hhb		defb	17

line_to_video	macro	src, dst
		; A line is 64 bytes.
		phillips_14byte_move src, dst
		phillips_14byte_move src+14, dst+14
		phillips_14byte_move src+28, dst+28
		phillips_14byte_move src+42, dst+42
		endm

main:
		; Clear the screen
		ld d,$80
		ld hl,screen
		ld bc,64*16
		call barden_fill
		; Draw at lines 1 and 13 to define the raycasting window.
		ld d,$b0
		ld hl,screen
		ld bc,64
		call barden_fill
		ld d,$83
		ld hl,screen+64*12
		ld bc,64
		call barden_fill
		; Show 'PLAYER' on the screen.
		ld hl,pos_text
		ld de,screen+64*14-12
		ld bc,6
		call barden_move
		ld a,comma
		ld (screen+64*14-3),a
		; Show 'DIRECTION' on the screen.
		ld hl,dir_text
		ld de,screen+64*15-12
		ld bc,9
		call barden_move

game_loop:	; Clear the video back buffer.
		ld d,$80
		ld hl,buff01
		ld bc,64*11
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

		ld ix,buff06+55
		ld iy,hha
		call draw_outline_wall_lhs

		; Show a '3' on line 3 (should flicker)
		ld a,$33
		ld (buff03),a

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

		jr back_to_screen

zero_action:	ld (toggle),a

		ld ix,buff06+54
		ld iy,hhb
		call draw_solid_wall_lhs

		; Show a '4' on line 4 (should flicker)
		ld a,$34
		ld (buff04),a
		; Show a '5' on line 5 (should flicker)
		ld a,$35
		ld (buff05),a

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

		; Copy the back buffer to the screen
back_to_screen:	ld (save_sp),sp		; Save SP
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
		; lines 2-12 on the screen.
		line_to_video buff01,screen+64*1
		line_to_video buff02,screen+64*2
		line_to_video buff03,screen+64*3
		line_to_video buff04,screen+64*4
		line_to_video buff05,screen+64*5
		line_to_video buff06,screen+64*6
		line_to_video buff07,screen+64*7
		line_to_video buff08,screen+64*8
		line_to_video buff09,screen+64*9
		line_to_video buff10,screen+64*10
		line_to_video buff11,screen+64*11
		ld sp,(save_sp)		; Restore SP

		; Output stats to the screen.
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
