;   _____          _   
;  / ____|        | |  
; | |     __ _ ___| |_ 
; | |    / _` / __| __|
; | |___| (_| \__ \ |_ 
;  \_____\__,_|___/\__|
;
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

; Entry: cast_dir        The angle to use for this call.
;        delta_dist_addr The address of the delta_dist lookup table.
;        player_x/y      The position of the player in the world.
; Exit:  wall_hh         The half-height of the wall to draw
;        wall_is_solid   1 if the wall should be drawn solid, 0 for outline. 
cast:	ld a,(cast_dir)
	ld c,$07
	and c
	ld (wall_hh),a
	ld a,0
	ld (wall_is_solid),a
	ret
