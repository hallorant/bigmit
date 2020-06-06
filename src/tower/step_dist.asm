ifndef INCLUDE_STEP_DIST
INCLUDE_STEP_DIST equ 1

;     _                 _ _     _
;    | |               | (_)   | |
; ___| |_ ___ _ __   __| |_ ___| |_
;/ __| __/ _ \ '_ \ / _` | / __| __|
;\__ \ ||  __/ |_) | (_| | \__ \ |_
;|___/\__\___| .__/ \__,_|_|___/\__|
;            | |______
;            |_|______|

; Looks up the distance a ray has to travel to go from one x-side to
; the next x-side for a passed angle.
;
; Enter: c   the byte-angle
; Exit:  de  The distance a ray has to travel to go from one x-side
;            to the next x-side
delta_dist_x:	xor a
		ld b,a		; Zero out b
		; If c > 128 (bit 8 is set) subtract 128 from c.
		ld a,$7f	; To do this we just unset bit 8.
		and c
		ld c,a
		sla c		; Double the offset (2 bytes per table entry)
		ld hl,delta_dist_table
		add hl,bc	; Determine lookup table addr 
		ld e,(hl)	; Low order byte
		inc hl
		ld d,(hl)	; High order byte
		ret

; Looks up the distance a ray has to travel to go from one y-side to
; the next y-side for a passed angle.
;
; Enter: c   the byte-angle
; Exit:  de  The distance a ray has to travel to go from one y-side
;            to the next y-side
delta_dist_y:	ld a,c
		add a,64
		ld c,a
		call delta_dist_x
		ret


; For one unit step in the x direction this lookup table maps a
; given angle to the distance (hypotenuse) in the next finer unit.
; Can be used for:
;  - Map unit steps resulting in distances in world units.
;  - World unit steps resulting in distances in sub-world units.
; Usage notes: Only contains angles [0,64]. Despite containing values the
;              vertical/horizontal angles should be treated as a special
;              case, i.e., 255 != infinity.
x_step_distance	defb	255	; at angle 00
		defb	163	; at angle 01
		defb	82	; at angle 02
		defb	55	; at angle 03
		defb	41	; at angle 04
		defb	33	; at angle 05
		defb	28	; at angle 06
		defb	24	; at angle 07
		defb	21	; at angle 08
		defb	19	; at angle 09
		defb	17	; at angle 10
		defb	16	; at angle 11
		defb	14	; at angle 12
		defb	13	; at angle 13
		defb	13	; at angle 14
		defb	12	; at angle 15
		defb	11	; at angle 16
		defb	11	; at angle 17
		defb	10	; at angle 18
		defb	10	; at angle 19
		defb	10	; at angle 20
		defb	9	; at angle 21
		defb	9	; at angle 22
		defb	9	; at angle 23
		defb	9	; at angle 24
		defb	8	; at angle 25
		defb	8	; at angle 26
		defb	8	; at angle 27
		defb	8	; at angle 28
		defb	8	; at angle 29
		defb	8	; at angle 30
		defb	8	; at angle 31
		defb	8	; at angle 32
		defb	8	; at angle 33
		defb	8	; at angle 34
		defb	8	; at angle 35
		defb	8	; at angle 36
		defb	8	; at angle 37
		defb	8	; at angle 38
		defb	8	; at angle 39
		defb	9	; at angle 40
		defb	9	; at angle 41
		defb	9	; at angle 42
		defb	9	; at angle 43
		defb	10	; at angle 44
		defb	10	; at angle 45
		defb	10	; at angle 46
		defb	11	; at angle 47
		defb	11	; at angle 48
		defb	12	; at angle 49
		defb	13	; at angle 50
		defb	13	; at angle 51
		defb	14	; at angle 52
		defb	16	; at angle 53
		defb	17	; at angle 54
		defb	19	; at angle 55
		defb	21	; at angle 56
		defb	24	; at angle 57
		defb	28	; at angle 58
		defb	33	; at angle 59
		defb	41	; at angle 60
		defb	55	; at angle 61
		defb	82	; at angle 62
		defb	163	; at angle 63
		defb	255	; at angle 64

; For one unit step in the x direction this lookup table maps a
; given angle to the y-distance (length) in the next finer unit.
; Can be used for:
;  - Map unit steps resulting in lengths in world units.
;  - World unit steps resulting in lengths in sub-world units.
; Usage notes: Only contains angles [0,64]. Despite containing values the
;              vertical/horizontal angles should be treated as a special
;              case, i.e., 255 != infinity.
x_step_y_length	defb	255	; at angle 00
		defb	163	; at angle 01
		defb	81	; at angle 02
		defb	54	; at angle 03
		defb	40	; at angle 04
		defb	32	; at angle 05
		defb	26	; at angle 06
		defb	22	; at angle 07
		defb	19	; at angle 08
		defb	17	; at angle 09
		defb	15	; at angle 10
		defb	13	; at angle 11
		defb	12	; at angle 12
		defb	11	; at angle 13
		defb	10	; at angle 14
		defb	9	; at angle 15
		defb	8	; at angle 16
		defb	7	; at angle 17
		defb	7	; at angle 18
		defb	6	; at angle 19
		defb	5	; at angle 20
		defb	5	; at angle 21
		defb	4	; at angle 22
		defb	4	; at angle 23
		defb	3	; at angle 24
		defb	3	; at angle 25
		defb	2	; at angle 26
		defb	2	; at angle 27
		defb	2	; at angle 28
		defb	1	; at angle 29
		defb	1	; at angle 30
		defb	0	; at angle 31
		defb	0	; at angle 32
		defb	0	; at angle 33
		defb	1	; at angle 34
		defb	1	; at angle 35
		defb	2	; at angle 36
		defb	2	; at angle 37
		defb	2	; at angle 38
		defb	3	; at angle 39
		defb	3	; at angle 40
		defb	4	; at angle 41
		defb	4	; at angle 42
		defb	5	; at angle 43
		defb	5	; at angle 44
		defb	6	; at angle 45
		defb	7	; at angle 46
		defb	7	; at angle 47
		defb	8	; at angle 48
		defb	9	; at angle 49
		defb	10	; at angle 50
		defb	11	; at angle 51
		defb	12	; at angle 52
		defb	13	; at angle 53
		defb	15	; at angle 54
		defb	17	; at angle 55
		defb	19	; at angle 56
		defb	22	; at angle 57
		defb	26	; at angle 58
		defb	32	; at angle 59
		defb	40	; at angle 60
		defb	54	; at angle 61
		defb	81	; at angle 62
		defb	163	; at angle 63
		defb	255	; at angle 64

endif ; INCLUDE_STEP_DIST
