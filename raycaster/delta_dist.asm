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
; Enter: hl  The lookup table address (either delta_dist_table or
;            delta_skew_table).
;	 c   the byte-angle
; Exit:  de  The distance a ray has to travel to go from one x-side
;            to the next x-side
delta_dist_x:	xor a
		ld b,a		; Zero out b
		; If c > 128 (bit 8 is set) subtract 128 from c.
		ld a,$7f	; To do this we just unset bit 8.
		and c
		ld c,a
		sla c		; Double the offset (2 bytes per table entry)
		add hl,bc	; Determine lookup table addr 
		ld e,(hl)	; Low order byte
		inc hl
		ld d,(hl)	; High order byte
		ret

; Looks up the distance a ray has to travel to go from one y-side to
; the next y-side for a passed angle.
;
; Enter: hl  The lookup table address (either delta_dist_table or
;            delta_skew_table).
;	 c   the byte-angle
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
delta_dist_x_001		defw	10435
delta_dist_x_002		defw	5224
delta_dist_x_003		defw	3489
delta_dist_x_004		defw	2624
delta_dist_x_005		defw	2107
delta_dist_x_006		defw	1763
delta_dist_x_007		defw	1519
delta_dist_x_008		defw	1337
delta_dist_x_009		defw	1196
delta_dist_x_010		defw	1084
delta_dist_x_011		defw	993
delta_dist_x_012		defw	918
delta_dist_x_013		defw	855
delta_dist_x_014		defw	802
delta_dist_x_015		defw	756
delta_dist_x_016		defw	716
delta_dist_x_017		defw	682
delta_dist_x_018		defw	651
delta_dist_x_019		defw	624
delta_dist_x_020		defw	600
delta_dist_x_021		defw	579
delta_dist_x_022		defw	560
delta_dist_x_023		defw	543
delta_dist_x_024		defw	527
delta_dist_x_025		defw	513
delta_dist_x_026		defw	500
delta_dist_x_027		defw	489
delta_dist_x_028		defw	478
delta_dist_x_029		defw	468
delta_dist_x_030		defw	459
delta_dist_x_031		defw	451
delta_dist_x_032		defw	443
delta_dist_x_033		defw	436
delta_dist_x_034		defw	430
delta_dist_x_035		defw	424
delta_dist_x_036		defw	419
delta_dist_x_037		defw	414
delta_dist_x_038		defw	409
delta_dist_x_039		defw	404
delta_dist_x_040		defw	400
delta_dist_x_041		defw	397
delta_dist_x_042		defw	393
delta_dist_x_043		defw	390
delta_dist_x_044		defw	387
delta_dist_x_045		defw	384
delta_dist_x_046		defw	382
delta_dist_x_047		defw	379
delta_dist_x_048		defw	377
delta_dist_x_049		defw	375
delta_dist_x_050		defw	373
delta_dist_x_051		defw	372
delta_dist_x_052		defw	370
delta_dist_x_053		defw	369
delta_dist_x_054		defw	368
delta_dist_x_055		defw	367
delta_dist_x_056		defw	366
delta_dist_x_057		defw	365
delta_dist_x_058		defw	364
delta_dist_x_059		defw	363
delta_dist_x_060		defw	363
delta_dist_x_061		defw	363
delta_dist_x_062		defw	362
delta_dist_x_063		defw	362
delta_dist_x_064		defw	0
delta_dist_x_065		defw	362
delta_dist_x_066		defw	362
delta_dist_x_067		defw	363
delta_dist_x_068		defw	363
delta_dist_x_069		defw	363
delta_dist_x_070		defw	364
delta_dist_x_071		defw	365
delta_dist_x_072		defw	366
delta_dist_x_073		defw	367
delta_dist_x_074		defw	368
delta_dist_x_075		defw	369
delta_dist_x_076		defw	370
delta_dist_x_077		defw	372
delta_dist_x_078		defw	373
delta_dist_x_079		defw	375
delta_dist_x_080		defw	377
delta_dist_x_081		defw	379
delta_dist_x_082		defw	382
delta_dist_x_083		defw	384
delta_dist_x_084		defw	387
delta_dist_x_085		defw	390
delta_dist_x_086		defw	393
delta_dist_x_087		defw	397
delta_dist_x_088		defw	400
delta_dist_x_089		defw	404
delta_dist_x_090		defw	409
delta_dist_x_091		defw	414
delta_dist_x_092		defw	419
delta_dist_x_093		defw	424
delta_dist_x_094		defw	430
delta_dist_x_095		defw	436
delta_dist_x_096		defw	443
delta_dist_x_097		defw	451
delta_dist_x_098		defw	459
delta_dist_x_099		defw	468
delta_dist_x_100		defw	478
delta_dist_x_101		defw	489
delta_dist_x_102		defw	500
delta_dist_x_103		defw	513
delta_dist_x_104		defw	527
delta_dist_x_105		defw	543
delta_dist_x_106		defw	560
delta_dist_x_107		defw	579
delta_dist_x_108		defw	600
delta_dist_x_109		defw	624
delta_dist_x_110		defw	651
delta_dist_x_111		defw	682
delta_dist_x_112		defw	716
delta_dist_x_113		defw	756
delta_dist_x_114		defw	802
delta_dist_x_115		defw	855
delta_dist_x_116		defw	918
delta_dist_x_117		defw	993
delta_dist_x_118		defw	1084
delta_dist_x_119		defw	1196
delta_dist_x_120		defw	1337
delta_dist_x_121		defw	1519
delta_dist_x_122		defw	1763
delta_dist_x_123		defw	2107
delta_dist_x_124		defw	2624
delta_dist_x_125		defw	3489
delta_dist_x_126		defw	5224
delta_dist_x_127		defw	10435
delta_dist_x_128		defw	65535

; Lookup table with values for the distance a ray has to travel to go from
; one x-side to the next x-side. For each of our byte-angle values (0,64).
; Each value in this table is skewed clockwise half a byte-angle.
delta_skew_table		defw	20863	; or delta_skew_x_000
delta_skew_x_001		defw	6960
delta_skew_x_002		defw	4183
delta_skew_x_003		defw	2995
delta_skew_x_004		defw	2337
delta_skew_x_005		defw	1919
delta_skew_x_006		defw	1632
delta_skew_x_007		defw	1422
delta_skew_x_008		defw	1262
delta_skew_x_009		defw	1137
delta_skew_x_010		defw	1037
delta_skew_x_011		defw	954
delta_skew_x_012		defw	885
delta_skew_x_013		defw	828
delta_skew_x_014		defw	778
delta_skew_x_015		defw	735
delta_skew_x_016		defw	698
delta_skew_x_017		defw	666
delta_skew_x_018		defw	637
delta_skew_x_019		defw	612
delta_skew_x_020		defw	589
delta_skew_x_021		defw	569
delta_skew_x_022		defw	551
delta_skew_x_023		defw	535
delta_skew_x_024		defw	520
delta_skew_x_025		defw	506
delta_skew_x_026		defw	494
delta_skew_x_027		defw	483
delta_skew_x_028		defw	473
delta_skew_x_029		defw	464
delta_skew_x_030		defw	455
delta_skew_x_031		defw	447
delta_skew_x_032		defw	440
delta_skew_x_033		defw	433
delta_skew_x_034		defw	427
delta_skew_x_035		defw	421
delta_skew_x_036		defw	416
delta_skew_x_037		defw	411
delta_skew_x_038		defw	407
delta_skew_x_039		defw	402
delta_skew_x_040		defw	399
delta_skew_x_041		defw	395
delta_skew_x_042		defw	392
delta_skew_x_043		defw	388
delta_skew_x_044		defw	386
delta_skew_x_045		defw	383
delta_skew_x_046		defw	381
delta_skew_x_047		defw	378
delta_skew_x_048		defw	376
delta_skew_x_049		defw	374
delta_skew_x_050		defw	373
delta_skew_x_051		defw	371
delta_skew_x_052		defw	370
delta_skew_x_053		defw	368
delta_skew_x_054		defw	367
delta_skew_x_055		defw	366
delta_skew_x_056		defw	365
delta_skew_x_057		defw	364
delta_skew_x_058		defw	364
delta_skew_x_059		defw	363
delta_skew_x_060		defw	363
delta_skew_x_061		defw	362
delta_skew_x_062		defw	362
delta_skew_x_063		defw	362
delta_skew_x_064		defw	362
delta_skew_x_065		defw	362
delta_skew_x_066		defw	362
delta_skew_x_067		defw	363
delta_skew_x_068		defw	363
delta_skew_x_069		defw	364
delta_skew_x_070		defw	364
delta_skew_x_071		defw	365
delta_skew_x_072		defw	366
delta_skew_x_073		defw	367
delta_skew_x_074		defw	368
delta_skew_x_075		defw	370
delta_skew_x_076		defw	371
delta_skew_x_077		defw	373
delta_skew_x_078		defw	374
delta_skew_x_079		defw	376
delta_skew_x_080		defw	378
delta_skew_x_081		defw	381
delta_skew_x_082		defw	383
delta_skew_x_083		defw	386
delta_skew_x_084		defw	388
delta_skew_x_085		defw	392
delta_skew_x_086		defw	395
delta_skew_x_087		defw	399
delta_skew_x_088		defw	402
delta_skew_x_089		defw	407
delta_skew_x_090		defw	411
delta_skew_x_091		defw	416
delta_skew_x_092		defw	421
delta_skew_x_093		defw	427
delta_skew_x_094		defw	433
delta_skew_x_095		defw	440
delta_skew_x_096		defw	447
delta_skew_x_097		defw	455
delta_skew_x_098		defw	464
delta_skew_x_099		defw	473
delta_skew_x_100		defw	483
delta_skew_x_101		defw	494
delta_skew_x_102		defw	506
delta_skew_x_103		defw	520
delta_skew_x_104		defw	535
delta_skew_x_105		defw	551
delta_skew_x_106		defw	569
delta_skew_x_107		defw	589
delta_skew_x_108		defw	612
delta_skew_x_109		defw	637
delta_skew_x_110		defw	666
delta_skew_x_111		defw	698
delta_skew_x_112		defw	735
delta_skew_x_113		defw	778
delta_skew_x_114		defw	828
delta_skew_x_115		defw	885
delta_skew_x_116		defw	954
delta_skew_x_117		defw	1037
delta_skew_x_118		defw	1137
delta_skew_x_119		defw	1262
delta_skew_x_120		defw	1422
delta_skew_x_121		defw	1632
delta_skew_x_122		defw	1919
delta_skew_x_123		defw	2337
delta_skew_x_124		defw	2995
delta_skew_x_125		defw	4183
delta_skew_x_126		defw	6960
delta_skew_x_127		defw	20863
delta_skew_x_128		defw	20863

