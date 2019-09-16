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

import '../lib/barden_fill.asm'
import '../lib/barden_move.asm'
import '../lib/draw_walls.asm'

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

save_sp		defw	0
toggle		defb	1
shot		defb	0
hha		defb	5
hhb		defb	17

to_video	macro	addr
		ld hl,(addr)
		push hl
		endm

line_to_video	macro	addr
		to_video addr+62
		to_video addr+60
		to_video addr+58
		to_video addr+56
		to_video addr+54
		to_video addr+52
		to_video addr+50
		to_video addr+48
		to_video addr+46
		to_video addr+44
		to_video addr+42
		to_video addr+40
		to_video addr+38
		to_video addr+36
		to_video addr+34
		to_video addr+32
		to_video addr+30
		to_video addr+28
		to_video addr+26
		to_video addr+24
		to_video addr+22
		to_video addr+20
		to_video addr+18
		to_video addr+16
		to_video addr+14
		to_video addr+12
		to_video addr+10
		to_video addr+8
		to_video addr+6
		to_video addr+4
		to_video addr+2
		to_video addr
		endm

main:
		; Clear the screen
		ld d,$80
		ld hl,screen
		ld bc,64*16
		call barden_fill
		; Draw a line at lines 1, 2, and 12 to separate the screen.
		ld d,$bf
		ld hl,screen
		ld bc,64
		call barden_fill
		ld d,$bf
		ld hl,screen+64
		ld bc,64
		call barden_fill
		ld d,$bf
		ld hl,screen+64*11
		ld bc,64
		call barden_fill
		ld d,$bf
		ld hl,screen+64*12
		ld bc,64
		call barden_fill
		ld d,$bf
		ld hl,screen+64*13
		ld bc,64
		call barden_fill
		ld d,$bf
		ld hl,screen+64*14
		ld bc,64
		call barden_fill
		ld d,$bf
		ld hl,screen+64*15
		ld bc,64
		call barden_fill

game_loop:	; Clear the video back buffer.
		ld d,$80
		ld hl,buff01
		ld bc,64*11
		call barden_fill

		; Check for input from the user.
		; TODO

		; Raycast into the video back buffer.
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

		line_to_video buff11
		line_to_video buff10
		line_to_video buff09
		line_to_video buff08
		line_to_video buff07
		line_to_video buff06
		line_to_video buff05
		line_to_video buff04
		line_to_video buff03
		ld sp,(save_sp)		; Restore SP

		; Now go back to the top of the game loop and repeat.
		jp game_loop

		end main
