;   _____          _   
;  / ____|        | |  
; | |     __ _ ___| |_ 
; | |    / _` / __| __|
; | |___| (_| \__ \ |_ 
;  \_____\__,_|___/\__|
;
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

cast_x			defb	0
cast_step_x		defb	0
cast_delta_dist_x	defw	0
cast_dist_x		defw	0
cast_next_dist_x	defw	0

cast_y			defb	0
cast_step_y		defb	0
cast_delta_dist_y	defw	0
cast_dist_y		defw	0
cast_next_dist_y	defw	0

; Casts a ray in the world from the players location in 'cast_dir' and finds
; the wall it hits. Then sets the wall half-height to draw. If the wall
; intersection is on X delta_dist then a solid wall is drawn, if on the Y
; delta_dist then a outline wall is drawn. This decision is flagged
; in 'wall_is_solid'.
;
; Entry: cast_dir        The angle to use for this call.
;        player_x/y      The position of the player in the world.
; Exit:  wall_hh         The half-height of the wall to draw
;        wall_is_solid   1 if the wall should be drawn solid, 0 for outline. 
cast:		; Set step x and step y to the correct values by 'cast_dir'.
		;          0
		;   X- Y+  |  X+ Y+
		;   1  1   |  0  0   bit 7 bit 6
		; 192 -----+----- 64
		;          |
		;   X- Y-  |  X+ Y-
		;   1  0  128 0  1

		ld a,(cast_dir)
		ld c,a
		bit 7,c
		jr nz,over_128
		ld a,1
		ld (cast_step_x),a	; X positive step
		bit 6,c
		jr nz,xpos_over64
		ld a,1
		ld (cast_step_y),a	; Y positive step
		jr lookup_delta_dist_x
xpos_over64:	ld a,-1
		ld (cast_step_y),a	; Y negative step
		jr lookup_delta_dist_x
over_128:	ld a,-1
		ld (cast_step_x),a	; X negative step
		bit 6,c
		jr nz,xneg_over64
		ld a,-1
		ld (cast_step_y),a	; Y negative step
		jr lookup_delta_dist_x
xneg_over64:	ld a,1
		ld (cast_step_y),a	; Y positive step

lookup_delta_dist_x:
		ld a,(cast_dir)
		ld c,a
		call delta_dist_x
		ld (cast_delta_dist_x),de
lookup_delta_dist_y:
		ld a,(cast_dir)
		ld c,a
		call delta_dist_y
		ld (cast_delta_dist_y),de

		; Initialize location to the player's location
		ld a,(player_x)
		ld (cast_x),a
		ld a,(player_y)
		ld (cast_y),a

		; Initialize the distance variables.
		ld hl,0
		ld (cast_dist_x),hl
		ld (cast_dist_y),hl
		ld hl,(cast_delta_dist_x)
		ld (cast_next_dist_x),hl
		ld hl,(cast_delta_dist_y)
		ld (cast_next_dist_y),hl

step_in_world:	; if next dist X < next dist Y
		ld hl,(cast_next_dist_x)
		ld de,(cast_next_dist_y)
		ld a,h
		cp d
		jr c,do_step_x	; h < d  : next_dist_x < next_dist_y
		jr z,do_chk_lsb	; h = d  : next_dist_x msb = next_dist_y msb
		jr do_step_y
do_chk_lsb:	ld a,l
		cp e
		jr c,do_step_x	; l < e  : next_dist_x < next_dist_y
		jr do_step_y

do_step_x:	ld a,1
		ld (wall_is_solid),a	; X steps draw solid walls.

		; Add a step (delta_dist_x) our total dist stepping Xs.
		ld hl,(cast_next_dist_x)
		ld (cast_dist_x),hl
		ld de,(cast_delta_dist_x);
		add hl,de
		ld (cast_next_dist_x),hl

		; Step the map postion we are at (cast_x,cast_y).
		ld a,(cast_x)
		ld c,a
		ld a,(cast_step_x)
		add a,c
		ld (cast_x),a

		jr check_if_wall

do_step_y:	ld a,0
		ld (wall_is_solid),a	; Y steps draw outline walls.

		; Add a step (delta_dist_y) our total dist stepping Ys.
		ld hl,(cast_next_dist_y)
		ld (cast_dist_y),hl
		ld de,(cast_delta_dist_y);
		add hl,de
		ld (cast_next_dist_y),hl

		; Step the map postion we are at (cast_x,cast_y).
		ld a,(cast_y)
		ld c,a
		ld a,(cast_step_y)
		add a,c
		ld (cast_y),a

check_if_wall:
	ld	a,(cast_y)
	add	a,high($6000)
	ld	h,a
	ld	a,(cast_x)
	ld	l,a
	ld	a,(hl)
	or	a
	jp	z,step_in_world

found_wall:	ld a,(wall_is_solid)
		or a
		jr z,found_wall_y
found_wall_x:	ld hl,(cast_dist_x)
		jr calculate_hh
found_wall_y:	ld hl,(cast_dist_y)

calculate_hh:	; Using the distance to the wall, determine half-height of
		; the wall we should draw.
		call dist_to_hh
		ld a,c
		ld (wall_hh),a
		ret
