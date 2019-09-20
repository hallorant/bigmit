; Unit tests for delta_dist.asm.
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/barden_move.asm'
import '../raycaster/delta_dist.asm'

blank		equ	$80
screen		equ	$3c00

; Compares de to (expected) and reports
; o 'P' if equal
; o 'F' if not equal
; on column 'col' of line 'line' on the screen.
cp_de_int16_to	macro	expected,line,col,?pass_high,?pass_both,?fail,?result
		ld hl,(expected)
		ld a,d
		cp h
		jr c,?fail
		jr z,?pass_high
		jr ?fail
?pass_high:	ld a,e
		cp l
		jr c,?fail
		jr z,?pass_both
		jr ?fail
?pass_both:	ld a,'P'
		jr ?result
?fail:		ld a,'F'
?result:	ld (screen+64*line+col),a
		endm

show_title	macro	name,line,col
		ld hl,`name`_txt
		ld de,screen+64*line+col
		ld bc,`name`_len
		call barden_move
		endm

title_txt	defb    'DELTA_DIST.ASM UNIT TESTS'
title_len	equ     $-title_txt

test_0_txt	defb    ': delta_dist_x(0) lookup'
test_0_len	equ     $-test_0_txt
test_1_txt	defb    ': delta_dist_x(64) lookup'
test_1_len	equ     $-test_1_txt
test_2_txt	defb    ': delta_dist_x(128) lookup'
test_2_len	equ     $-test_2_txt
test_3_txt	defb    ': delta_dist_x(192) lookup'
test_3_len	equ     $-test_3_txt
test_4_txt	defb    ': delta_dist_x(255) lookup'
test_4_len	equ     $-test_4_txt
test_5_txt	defb    ': delta_dist_x(5) lookup'
test_5_len	equ     $-test_5_txt
test_6_txt	defb    ': delta_dist_x(90) lookup'
test_6_len	equ     $-test_6_txt
test_7_txt	defb    ': delta_dist_x(175) lookup'
test_7_len	equ     $-test_7_txt
test_8_txt	defb    ': delta_dist_x(200) lookup'
test_8_len	equ     $-test_8_txt

test_9_txt	defb    ': delta_dist_y(0) lookup'
test_9_len	equ     $-test_9_txt
test_10_txt	defb    ': delta_dist_y(64) lookup'
test_10_len	equ     $-test_10_txt
test_11_txt	defb    ': delta_dist_y(128) lookup'
test_11_len	equ     $-test_11_txt
test_12_txt	defb    ': delta_dist_y(192) lookup'
test_12_len	equ     $-test_12_txt
test_13_txt	defb    ': delta_dist_y(255) lookup'
test_13_len	equ     $-test_13_txt
test_14_txt	defb    ': delta_dist_y(5) lookup'
test_14_len	equ     $-test_14_txt
test_15_txt	defb    ': delta_dist_y(90) lookup'
test_15_len	equ     $-test_15_txt
test_16_txt	defb    ': delta_dist_y(175) lookup'
test_16_len	equ     $-test_16_txt
test_17_txt	defb    ': delta_dist_y(200) lookup'
test_17_len	equ     $-test_17_txt

test_18_txt	defb    ': delta_skew_x(0) lookup'
test_18_len	equ     $-test_18_txt
test_19_txt	defb    ': delta_skew_x(64) lookup'
test_19_len	equ     $-test_19_txt
test_20_txt	defb    ': delta_skew_x(128) lookup'
test_20_len	equ     $-test_20_txt
test_21_txt	defb    ': delta_skew_x(192) lookup'
test_21_len	equ     $-test_21_txt
test_22_txt	defb    ': delta_skew_x(255) lookup'
test_22_len	equ     $-test_22_txt

test_23_txt	defb    ': delta_skew_y(0) lookup'
test_23_len	equ     $-test_23_txt
test_24_txt	defb    ': delta_skew_y(64) lookup'
test_24_len	equ     $-test_24_txt
test_25_txt	defb    ': delta_skew_y(128) lookup'
test_25_len	equ     $-test_25_txt
test_26_txt	defb    ': delta_skew_y(192) lookup'
test_26_len	equ     $-test_26_txt
test_27_txt	defb    ': delta_skew_y(255) lookup'
test_27_len	equ     $-test_27_txt

main:
		; Clear the screen.
		ld d,blank
		ld hl,screen 
		ld bc,64*16
		call barden_fill
		show_title title,0,19

		; ------------------------
		; -- DELTA_DIST_X TESTS --
		; ------------------------

		; Test 0: delta_dist_x(0) lookup
		show_title test_0,1,2
		ld hl,delta_dist_table
		ld c,0
		call delta_dist_x
		cp_de_int16_to delta_dist_table,1,0

		; Test 1: delta_dist_x(64) lookup
		show_title test_1,2,2
		ld hl,delta_dist_table
		ld c,64
		call delta_dist_x
		cp_de_int16_to delta_dist_x_064,2,0

		; Test 2: delta_dist_x(128) lookup
		show_title test_2,3,2
		ld hl,delta_dist_table
		ld c,128
		call delta_dist_x
		cp_de_int16_to delta_dist_x_128,3,0

		; Test 3: delta_dist_x(192) lookup
		show_title test_3,4,2
		ld hl,delta_dist_table
		ld c,192
		call delta_dist_x
		cp_de_int16_to delta_dist_x_064,4,0

		; Test 4: delta_dist_x(255)
		show_title test_4,5,2
		ld hl,delta_dist_table
		ld c,255
		call delta_dist_x
		cp_de_int16_to delta_dist_x_127,5,0

		; Test 5: delta_dist_x(5)
		show_title test_5,6,2
		ld hl,delta_dist_table
		ld c,5
		call delta_dist_x
		cp_de_int16_to delta_dist_x_005,6,0

		; Test 6: delta_dist_x(90)
		show_title test_6,7,2
		ld hl,delta_dist_table
		ld c,90
		call delta_dist_x
		cp_de_int16_to delta_dist_x_090,7,0

		; Test 7: delta_dist_x(175)
		show_title test_7,8,2
		ld hl,delta_dist_table
		ld c,175
		call delta_dist_x
		cp_de_int16_to delta_dist_x_081,8,0

		; Test 8: delta_dist_x(200)
		show_title test_8,9,2
		ld hl,delta_dist_table
		ld c,200
		call delta_dist_x
		cp_de_int16_to delta_dist_x_072,9,0

		; ------------------------
		; -- DELTA_DIST_Y TESTS --
		; ------------------------

		; Test 9: delta_dist_y(0) lookup
		show_title test_9,1,34
		ld hl,delta_dist_table
		ld c,0
		call delta_dist_y
		cp_de_int16_to delta_dist_x_064,1,32

		; Test 10: delta_dist_y(64) lookup
		show_title test_10,2,34
		ld hl,delta_dist_table
		ld c,64
		call delta_dist_y
		cp_de_int16_to delta_dist_table,2,32

		; Test 11: delta_dist_y(128) lookup
		show_title test_11,3,34
		ld hl,delta_dist_table
		ld c,128
		call delta_dist_y
		cp_de_int16_to delta_dist_x_064,3,32

		; Test 12: delta_dist_y(192) lookup
		show_title test_12,4,34
		ld hl,delta_dist_table
		ld c,192
		call delta_dist_y
		cp_de_int16_to delta_dist_table,4,32

		; Test 13: delta_dist_y(255)
		show_title test_13,5,34
		ld hl,delta_dist_table
		ld c,255
		call delta_dist_y
		cp_de_int16_to delta_dist_x_063,5,32

		; Test 14: delta_dist_y(5)
		show_title test_14,6,34
		ld hl,delta_dist_table
		ld c,5
		call delta_dist_y
		cp_de_int16_to delta_dist_x_059,6,32

		; Test 15: delta_dist_y(90)
		show_title test_15,7,34
		ld hl,delta_dist_table
		ld c,90
		call delta_dist_y
		cp_de_int16_to delta_dist_x_026,7,32

		; Test 16: delta_dist_y(175)
		show_title test_16,8,34
		ld hl,delta_dist_table
		ld c,175
		call delta_dist_y
		cp_de_int16_to delta_dist_x_017,8,32

		; Test 17: delta_dist_y(200)
		show_title test_17,9,34
		ld hl,delta_dist_table
		ld c,200
		call delta_dist_y
		cp_de_int16_to delta_dist_x_008,9,32

		; ------------------------
		; -- DELTA_SKEW_X TESTS --
		; ------------------------

		; Test 18: delta_skew_x(0) lookup
		show_title test_18,11,2
		ld hl,delta_skew_table
		ld c,0
		call delta_dist_x
		cp_de_int16_to delta_skew_table,11,0

		; Test 19: delta_skew_x(64) lookup
		show_title test_19,12,2
		ld hl,delta_skew_table
		ld c,64
		call delta_dist_x
		cp_de_int16_to delta_skew_x_064,12,0

		; Test 20: delta_skew_x(128) lookup
		show_title test_20,13,2
		ld hl,delta_skew_table
		ld c,128
		call delta_dist_x
		cp_de_int16_to delta_skew_x_128,13,0

		; Test 21: delta_skew_x(192) lookup
		show_title test_21,14,2
		ld hl,delta_skew_table
		ld c,192
		call delta_dist_x
		cp_de_int16_to delta_skew_x_064,14,0

		; Test 22: delta_skew_x(255)
		show_title test_22,15,2
		ld hl,delta_skew_table
		ld c,255
		call delta_dist_x
		cp_de_int16_to delta_skew_x_127,15,0

		; ------------------------
		; -- DELTA_SKEW_Y TESTS --
		; ------------------------

		; Test 23: delta_skew_y(0) lookup
		show_title test_23,11,34
		ld hl,delta_skew_table
		ld c,0
		call delta_dist_y
		cp_de_int16_to delta_skew_x_064,11,32

		; Test 24: delta_skew_y(64) lookup
		show_title test_24,12,34
		ld hl,delta_skew_table
		ld c,64
		call delta_dist_y
		cp_de_int16_to delta_skew_table,12,32

		; Test 25: delta_skew_y(128) lookup
		show_title test_25,13,34
		ld hl,delta_skew_table
		ld c,128
		call delta_dist_y
		cp_de_int16_to delta_skew_x_064,13,32

		; Test 26: delta_skew_y(192) lookup
		show_title test_26,14,34
		ld hl,delta_skew_table
		ld c,192
		call delta_dist_y
		cp_de_int16_to delta_skew_table,14,32

		; Test 27: delta_skew_y(255)
		show_title test_27,15,34
		ld hl,delta_skew_table
		ld c,255
		call delta_dist_y
		cp_de_int16_to delta_skew_x_063,15,32


hcf:		jr hcf
		end main
