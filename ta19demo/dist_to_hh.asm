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
		jr c,?next	; l < e  : lsb dist < lsb table lookup
		ret		; l >= e : lsb dist >= lsb table lookup
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
hh_01		 defw	4352	; map distance 17.0
hh_02		 defw	4096	; map distance 16.0
hh_03		 defw	3840	; map distance 15.0
hh_04		 defw	3584	; map distance 14.0
hh_05		 defw	3328	; map distance 13.0
hh_06		 defw	3072	; map distance 12.0
hh_07		 defw	2816	; map distance 11.0
hh_08		 defw	2560	; map distance 10.0
hh_09		 defw	2304	; map distance 9.0
hh_10		 defw	2048	; map distance 8.0
hh_11		 defw	1792	; map distance 7.0
hh_12		 defw	1536	; map distance 6.0
hh_13		 defw	1280	; map distance 5.0
hh_14		 defw	1024	; map distance 4.0
hh_15		 defw	768	; map distance 3.0
hh_16		 defw	512	; map distance 2.0
hh_17		 defw	256	; map distance 1.0

