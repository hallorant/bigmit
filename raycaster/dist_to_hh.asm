;  _____  _     _     _______                              
; |  __ \(_)   | |   |__   __|                             
; | |  | |_ ___| |_     | | ___                            
; | |  | | / __| __|    | |/ _ \                           
; | |__| | \__ \ |_     | | (_) |                          
; |_____/|_|___/\__|_   |_|\___/  _      _       _     _   
; | |  | |     | |/ _|      | |  | |    (_)     | |   | |  
; | |__| | __ _| | |_ ______| |__| | ___ _  __ _| |__ | |_ 
; |  __  |/ _` | |  _|______|  __  |/ _ \ |/ _` | '_ \| __|
; | |  | | (_| | | |        | |  | |  __/ | (_| | | | | |_ 
; |_|  |_|\__,_|_|_|        |_|  |_|\___|_|\__, |_| |_|\__|
;                                           __/ |          
;                                          |___/      
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

; Returns c if hl >= (addr). Complex because we are doing a 16-bit comparison.
check_hh	macro	addr,?chk_lsb,?next
		ld de,(addr)	; Do the table lookup for this half-height.
		ld a,h
		cp d
		jr c,?next	; h < d  : msb dist < msb table lookup
		jr z,?chk_lsb	; h = d  : msb dist = msb table lookup
		ret		; h > d	 : msb dist > msb table lookup
?chk_lsb:	ld a,l
		cp e
		jr c,?next	; l < c  : lsb dist < lsb table lookup
		ret		; l >= c : lsb dist >= lsb table lookup
?next:		inc c
		endm

; Returns the half-height of a wall given the passed distance to it.
;
; Uses: a,c,de,hl
;
; Enter: hl  distance to wall.
; Exit:  c   half-height of wall: (1,17).
dist_to_hh:	ld c,1
		check_hh hh_01
		check_hh hh_02
		check_hh hh_03
		check_hh hh_04
		check_hh hh_05
		check_hh hh_06
		check_hh hh_07
		check_hh hh_08
		check_hh hh_09
		check_hh hh_10
		check_hh hh_11
		check_hh hh_12
		check_hh hh_13
		check_hh hh_14
		check_hh hh_15
		check_hh hh_16
		check_hh hh_17
		dec c		; 17 is the maximum value we want to return.
		ret

; Table of half-heights mapping to the smallest distance which should
; use a particular half-height to draw a wall.
hh_01		 defw	11520	; map distance 45.0
hh_02		 defw	10816	; map distance 42.25
hh_03		 defw	10112	; map distance 39.5
hh_04		 defw	9408	; map distance 36.75
hh_05		 defw	8704	; map distance 34.0
hh_06		 defw	8000	; map distance 31.25
hh_07		 defw	7296	; map distance 28.5
hh_08		 defw	6592	; map distance 25.75
hh_09		 defw	5888	; map distance 23.0
hh_10		 defw	5184	; map distance 20.25
hh_11		 defw	4480	; map distance 17.5
hh_12		 defw	3776	; map distance 14.75
hh_13		 defw	3072	; map distance 12.0
hh_14		 defw	2368	; map distance 9.25
hh_15		 defw	1664	; map distance 6.5
hh_16		 defw	960	; map distance 3.75
hh_17		 defw	256	; map distance 1.0

