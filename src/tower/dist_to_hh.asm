ifndef INCLUDE_DIST_TO_HH
INCLUDE_DIST_TO_HH equ 1

;     _ _     _    _         _     _
;    | (_)   | |  | |       | |   | |
;  __| |_ ___| |_ | |_ ___  | |__ | |__
; / _` | / __| __|| __/ _ \ | '_ \| '_ \
;| (_| | \__ \ |_ | || (_) || | | | | | |
; \__,_|_|___/\__| \__\___/ |_| |_|_| |_|
;              ______   ______
;             |______| |______|
;
; Used to calculate the half-height of a wall in the raycaster using
; the distance to the wall and the viewer deflection angle. The latter
; is used to do fisheye correction.

; Comparision macro for a single table row. Returns if distance to the
; wall is less than the table lookup distance, otherwise increments the
; table row address and the wall half-height.
;
; Entry: hl  address of table row to examine
;        a   distance to the wall
;        c   current wall half-height
; Exit:  c   incremented if no return
;       hl   incremented if no return
; @private
hh_row_check macro ?next_row
  ld b,(hl)
  cp b
  jr c,?next_row ; dist <  table lookup dist (check next)
  ret            ; dist >= table lookup dist
?next_row:
  inc c
  inc hl
  endm

; Calculates the wall half-height based upon the distance to the wall
; and the deflection angle off-center. Fisheye correction is built into
; the table distances and drives the need to know the deflection angle.
;
; Entry: c   distance in world units
;        b   deflection angle off-center [0,11) where 0 is center
; Exit:  c   wall half height [0,11]
;        hl  pointer to the table entry last checked (testing only)
dist_to_hh:
  ; Find lookup table address using deflection angle.
  ld hl,hh_for_angle_00
  ld a,b
  or a ; is a == 0?
  jr z,_calc_hh
  ; There is a non-zero deflection angle, calculate the table address.
  ld de,hh_table_size
_table_loop:
  add hl,de
  djnz _table_loop
_calc_hh:
  ; Calculate the wall half-height.
  ld a,c ; distance to the wall
  ld c,0 ; where we return the wall half-height
  hh_row_check ; row 0
  hh_row_check ; row 1
  hh_row_check ; row 2
  hh_row_check ; row 3
  hh_row_check ; row 4
  hh_row_check ; row 5
  hh_row_check ; row 6
  hh_row_check ; row 7
  hh_row_check ; row 8
  hh_row_check ; row 9
  hh_row_check ; row 10
  ret

; Half-height lookup table for the center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_00		defb	248	; for a wall half height of 0
			defb	224	; for a wall half height of 1
			defb	199	; for a wall half height of 2
			defb	175	; for a wall half height of 3
			defb	150	; for a wall half height of 4
			defb	126	; for a wall half height of 5
			defb	102	; for a wall half height of 6
			defb	77	; for a wall half height of 7
			defb	53	; for a wall half height of 8
			defb	28	; for a wall half height of 9
			defb	4	; for a wall half height of 10
hh_table_size		equ	$-hh_for_angle_00

; Half-height lookup table for angle 1 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_01		defb	247	; for a wall half height of 0
			defb	223	; for a wall half height of 1
			defb	198	; for a wall half height of 2
			defb	174	; for a wall half height of 3
			defb	149	; for a wall half height of 4
			defb	125	; for a wall half height of 5
			defb	101	; for a wall half height of 6
			defb	76	; for a wall half height of 7
			defb	52	; for a wall half height of 8
			defb	27	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 2 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_02		defb	246	; for a wall half height of 0
			defb	222	; for a wall half height of 1
			defb	197	; for a wall half height of 2
			defb	173	; for a wall half height of 3
			defb	149	; for a wall half height of 4
			defb	125	; for a wall half height of 5
			defb	100	; for a wall half height of 6
			defb	76	; for a wall half height of 7
			defb	52	; for a wall half height of 8
			defb	27	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 3 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_03		defb	245	; for a wall half height of 0
			defb	221	; for a wall half height of 1
			defb	197	; for a wall half height of 2
			defb	172	; for a wall half height of 3
			defb	148	; for a wall half height of 4
			defb	124	; for a wall half height of 5
			defb	100	; for a wall half height of 6
			defb	76	; for a wall half height of 7
			defb	51	; for a wall half height of 8
			defb	27	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 4 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_04		defb	243	; for a wall half height of 0
			defb	219	; for a wall half height of 1
			defb	195	; for a wall half height of 2
			defb	171	; for a wall half height of 3
			defb	147	; for a wall half height of 4
			defb	123	; for a wall half height of 5
			defb	99	; for a wall half height of 6
			defb	75	; for a wall half height of 7
			defb	51	; for a wall half height of 8
			defb	27	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 5 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_05		defb	240	; for a wall half height of 0
			defb	216	; for a wall half height of 1
			defb	193	; for a wall half height of 2
			defb	169	; for a wall half height of 3
			defb	145	; for a wall half height of 4
			defb	122	; for a wall half height of 5
			defb	98	; for a wall half height of 6
			defb	74	; for a wall half height of 7
			defb	50	; for a wall half height of 8
			defb	27	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 6 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_06		defb	237	; for a wall half height of 0
			defb	214	; for a wall half height of 1
			defb	190	; for a wall half height of 2
			defb	167	; for a wall half height of 3
			defb	143	; for a wall half height of 4
			defb	120	; for a wall half height of 5
			defb	97	; for a wall half height of 6
			defb	73	; for a wall half height of 7
			defb	50	; for a wall half height of 8
			defb	26	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 7 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_07		defb	233	; for a wall half height of 0
			defb	210	; for a wall half height of 1
			defb	187	; for a wall half height of 2
			defb	164	; for a wall half height of 3
			defb	141	; for a wall half height of 4
			defb	118	; for a wall half height of 5
			defb	95	; for a wall half height of 6
			defb	72	; for a wall half height of 7
			defb	49	; for a wall half height of 8
			defb	26	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 8 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_08		defb	229	; for a wall half height of 0
			defb	206	; for a wall half height of 1
			defb	184	; for a wall half height of 2
			defb	161	; for a wall half height of 3
			defb	139	; for a wall half height of 4
			defb	116	; for a wall half height of 5
			defb	93	; for a wall half height of 6
			defb	71	; for a wall half height of 7
			defb	48	; for a wall half height of 8
			defb	26	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 9 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_09		defb	224	; for a wall half height of 0
			defb	202	; for a wall half height of 1
			defb	180	; for a wall half height of 2
			defb	158	; for a wall half height of 3
			defb	136	; for a wall half height of 4
			defb	114	; for a wall half height of 5
			defb	91	; for a wall half height of 6
			defb	69	; for a wall half height of 7
			defb	47	; for a wall half height of 8
			defb	25	; for a wall half height of 9
			defb	3	; for a wall half height of 10

; Half-height lookup table for angle 10 off center of view.
; Maps the smallest distance which should use a particular wall half-height.
; All values are (uncorrected for fisheye) distances in world units.
hh_for_angle_10		defb	218	; for a wall half height of 0
			defb	197	; for a wall half height of 1
			defb	175	; for a wall half height of 2
			defb	154	; for a wall half height of 3
			defb	132	; for a wall half height of 4
			defb	111	; for a wall half height of 5
			defb	89	; for a wall half height of 6
			defb	68	; for a wall half height of 7
			defb	46	; for a wall half height of 8
			defb	25	; for a wall half height of 9
			defb	3	; for a wall half height of 10

endif ; INCLUDE_DIST_TO_HH
