; Unit tests for dist_to_hh.asm
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/barden_hexcv.asm'
import '../lib/barden_move.asm'
import '../raycaster/dist_to_hh.asm'

blank		equ	$80
screen		equ	$3c00

; Compares a to (expected) and reports
; o 'P' if equal
; o 'F' if not equal
; on column 'col' of line 'line' on the screen.
; Then it prints the value of a one space over in hex.
cp_a_byte_to	macro	expected,line,col,?pass,?fail,?result
		ld d,a
		ld c,expected
		cp c
		jr c,?fail
		jr z,?pass
		jr ?fail
?pass:		ld a,'P'
		jr ?result
?fail:		ld a,'F'
?result:	ld (screen+64*line+col),a
		ld a,d
		call barden_hexcv
		ld (screen+64*line+col+2),hl
		endm

show_title	macro	name,line,col
		ld hl,`name`_txt
		ld de,screen+64*line+col
		ld bc,`name`_len
		call barden_move
		endm

title_txt	defb    'DIST_TO_HH.ASM UNIT TESTS'
title_len	equ     $-title_txt

test_0_txt	defb    ': dist_to_hh(11521) = 1'
test_0_len	equ     $-test_0_txt
test_1_txt	defb    ': dist_to_hh(10820) = 2)'
test_1_len	equ     $-test_1_txt
test_2_txt	defb    ': dist_to_hh(0) = 17'
test_2_len	equ     $-test_2_txt
test_3_txt	defb    ': dist_to_hh(960) = 16'
test_3_len	equ     $-test_3_txt
test_4_txt	defb    ': dist_to_hh(8000) = 6'
test_4_len	equ     $-test_4_txt
test_5_txt	defb    ': dist_to_hh($1f40) = 6  (note $1f40 = 8000)'
test_5_len	equ     $-test_5_txt
test_6_txt	defb    ': dist_to_hh($1f00) = 7'
test_6_len	equ     $-test_6_txt
test_7_txt	defb    ': dist_to_hh($1f4f) = 6'
test_7_len	equ     $-test_7_txt

main:
		; Clear the screen.
		ld d,blank
		ld hl,screen 
		ld bc,64*16
		call barden_fill
		show_title title,0,18

		; ----------------------
		; -- DIST_TO_HH TESTS --
		; ----------------------

		; Test 0: dist_to_hh(11521) = 1
		show_title test_0,1,5
		ld hl,11521
		call dist_to_hh
		ld a,c
		cp_a_byte_to 1,1,0

		; Test 1: dist_to_hh(10820) = 2
		show_title test_1,2,5
		ld hl,10820
		call dist_to_hh
		ld a,c
		cp_a_byte_to 2,2,0

		; Test 2: dist_to_hh(0) = 17
		show_title test_2,3,5
		ld hl,0
		call dist_to_hh
		ld a,c
		cp_a_byte_to 17,3,0

		; Test 3: dist_to_hh(960) = 16
		show_title test_3,4,5
		ld hl,960
		call dist_to_hh
		ld a,c
		cp_a_byte_to 16,4,0

		; Test 4: dist_to_hh(8000) = 6
		show_title test_4,5,5
		ld hl,8000
		call dist_to_hh
		ld a,c
		cp_a_byte_to 6,5,0

		; Test 5: dist_to_hh($1f40) = 6
		show_title test_5,6,5
		ld hl,$1f40
		call dist_to_hh
		ld a,c
		cp_a_byte_to 6,6,0

		; Test 6: dist_to_hh($1f00) = 7
		show_title test_6,7,5
		ld hl,$1f00
		call dist_to_hh
		ld a,c
		cp_a_byte_to 7,7,0

		; Test 7: dist_to_hh($1f4f) = 6
		show_title test_7,8,5
		ld hl,$1f4f
		call dist_to_hh
		ld a,c
		cp_a_byte_to 6,8,0

hcf:		jr hcf
		end main
