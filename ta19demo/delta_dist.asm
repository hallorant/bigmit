;  _____       _ _          _____  _     _   
; |  __ \     | | |        |  __ \(_)   | |  
; | |  | | ___| | |_ __ _  | |  | |_ ___| |_ 
; | |  | |/ _ \ | __/ _` | | |  | | / __| __|
; | |__| |  __/ | || (_| | | |__| | \__ \ |_ 
; |_____/ \___|_|\__\__,_| |_____/|_|___/\__|
;
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

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

; Lookup table with values for the distance a ray has to travel to go from
; one x-side to the next x-side. For each of our byte-angle values (0,64).
delta_dist_table		defw	65535	; or delta_dist_x_000
delta_dist_x_001		defw	10431
delta_dist_x_002		defw	5217
delta_dist_x_003		defw	3480
delta_dist_x_004		defw	2612
delta_dist_x_005		defw	2091
delta_dist_x_006		defw	1745
delta_dist_x_007		defw	1497
delta_dist_x_008		defw	1312
delta_dist_x_009		defw	1168
delta_dist_x_010		defw	1054
delta_dist_x_011		defw	960
delta_dist_x_012		defw	882
delta_dist_x_013		defw	816
delta_dist_x_014		defw	760
delta_dist_x_015		defw	711
delta_dist_x_016		defw	669
delta_dist_x_017		defw	632
delta_dist_x_018		defw	599
delta_dist_x_019		defw	569
delta_dist_x_020		defw	543
delta_dist_x_021		defw	519
delta_dist_x_022		defw	498
delta_dist_x_023		defw	479
delta_dist_x_024		defw	461
delta_dist_x_025		defw	445
delta_dist_x_026		defw	430
delta_dist_x_027		defw	416
delta_dist_x_028		defw	404
delta_dist_x_029		defw	392
delta_dist_x_030		defw	381
delta_dist_x_031		defw	371
delta_dist_x_032		defw	362
delta_dist_x_033		defw	353
delta_dist_x_034		defw	346
delta_dist_x_035		defw	338
delta_dist_x_036		defw	331
delta_dist_x_037		defw	325
delta_dist_x_038		defw	319
delta_dist_x_039		defw	313
delta_dist_x_040		defw	308
delta_dist_x_041		defw	303
delta_dist_x_042		defw	298
delta_dist_x_043		defw	294
delta_dist_x_044		defw	290
delta_dist_x_045		defw	287
delta_dist_x_046		defw	283
delta_dist_x_047		defw	280
delta_dist_x_048		defw	277
delta_dist_x_049		defw	274
delta_dist_x_050		defw	272
delta_dist_x_051		defw	270
delta_dist_x_052		defw	268
delta_dist_x_053		defw	266
delta_dist_x_054		defw	264
delta_dist_x_055		defw	262
delta_dist_x_056		defw	261
delta_dist_x_057		defw	260
delta_dist_x_058		defw	259
delta_dist_x_059		defw	258
delta_dist_x_060		defw	257
delta_dist_x_061		defw	257
delta_dist_x_062		defw	256
delta_dist_x_063		defw	256
delta_dist_x_064		defw	256
delta_dist_x_065		defw	256
delta_dist_x_066		defw	256
delta_dist_x_067		defw	257
delta_dist_x_068		defw	257
delta_dist_x_069		defw	258
delta_dist_x_070		defw	259
delta_dist_x_071		defw	260
delta_dist_x_072		defw	261
delta_dist_x_073		defw	262
delta_dist_x_074		defw	264
delta_dist_x_075		defw	266
delta_dist_x_076		defw	268
delta_dist_x_077		defw	270
delta_dist_x_078		defw	272
delta_dist_x_079		defw	274
delta_dist_x_080		defw	277
delta_dist_x_081		defw	280
delta_dist_x_082		defw	283
delta_dist_x_083		defw	287
delta_dist_x_084		defw	290
delta_dist_x_085		defw	294
delta_dist_x_086		defw	298
delta_dist_x_087		defw	303
delta_dist_x_088		defw	308
delta_dist_x_089		defw	313
delta_dist_x_090		defw	319
delta_dist_x_091		defw	325
delta_dist_x_092		defw	331
delta_dist_x_093		defw	338
delta_dist_x_094		defw	346
delta_dist_x_095		defw	353
delta_dist_x_096		defw	362
delta_dist_x_097		defw	371
delta_dist_x_098		defw	381
delta_dist_x_099		defw	392
delta_dist_x_100		defw	404
delta_dist_x_101		defw	416
delta_dist_x_102		defw	430
delta_dist_x_103		defw	445
delta_dist_x_104		defw	461
delta_dist_x_105		defw	479
delta_dist_x_106		defw	498
delta_dist_x_107		defw	519
delta_dist_x_108		defw	543
delta_dist_x_109		defw	569
delta_dist_x_110		defw	599
delta_dist_x_111		defw	632
delta_dist_x_112		defw	669
delta_dist_x_113		defw	711
delta_dist_x_114		defw	760
delta_dist_x_115		defw	816
delta_dist_x_116		defw	882
delta_dist_x_117		defw	960
delta_dist_x_118		defw	1054
delta_dist_x_119		defw	1168
delta_dist_x_120		defw	1312
delta_dist_x_121		defw	1497
delta_dist_x_122		defw	1745
delta_dist_x_123		defw	2091
delta_dist_x_124		defw	2612
delta_dist_x_125		defw	3480
delta_dist_x_126		defw	5217
delta_dist_x_127		defw	10431
delta_dist_x_128		defw	65535

