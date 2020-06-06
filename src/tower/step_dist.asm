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

; Returns, for one unit step in the horizontal direction at the given angle,
; the distance travelled and the vertical distance (in the next finer unit).
;
; Entry: e  the angle [0,128)
; Exit:  c  for one unit step in the x direction at the given angle the distance
;           (hypotenuse) in the next finer unit.
;        b  for one unit step in the x direction at the given angle the y-distance
;           (length) in the next finer unit.
step_x:
  ; If the angle > 64 subtract 64 from it.
  ld a,e
  and $3f ; unset bit 7 (and 8)
  ld e,a
  ld d,0  ; ensure d is zero (it is the msb of the offset adds below)
  ld hl,x_step_distance
  add hl,de  ; offset the lookup table addr 
  ld c,(hl)
  ld hl,x_step_y_length
  add hl,de  ; offset the lookup table addr 
  ld b,(hl)
  ret

; Returns, for one unit step in the vertical direction at the given angle,
; the distance travelled and the horizontal distance (in the next finer unit).
;
; Entry: e  the angle [0,128)
; Exit:  c  for one unit step in the y direction at the given angle the distance
;           (hypotenuse) in the next finer unit.
;        b  for one unit step in the y direction at the given angle the x-distance
;           (length) in the next finer unit.
step_y:
  ; Rotate the angle clockwise 32 then reuse the step_x function.
  ld a,e
  add a,32
  and $7f ; ensure angle range remains within [0,128)
  ld e,a
  call step_x
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
