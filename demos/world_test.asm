; Unit tests for world.asm.
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/barden_hexcv.asm'
import '../lib/barden_move.asm'
import '../lib/sla16.asm'
import '../lib/srl16.asm'

import '../raycaster/world.asm'

blank		equ	$80
screen		equ	$3c00

; Compares a to (expected) and reports
; o 'P' if equal
; o 'F' if not equal
; on column 'col' of line 'line' on the screen.
cp_a_byte_to	macro	expected,line,col,?pass,?fail,?result
		ld c,expected
		cp c
		jr c,?fail
		jr z,?pass
		jr ?fail
?pass:		ld a,'P'
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

; Compares de to expected and reports
; o 'P' if equal
; o 'F' if not equal
; on column 'col' of line 'line' on the screen.
cp_de_int16_to  macro   expected,line,col,?pass_high,?pass_both,?fail,?result
                ld hl,expected
                ld a,d
                cp h
                jr c,?fail
                jr z,?pass_high
                jr ?fail
?pass_high:     ld a,e
                cp l
                jr c,?fail
                jr z,?pass_both
                jr ?fail
?pass_both:     ld a,'P'
                jr ?result
?fail:          ld a,'F'
?result:        ld (screen+64*line+col),a
                endm

tmp16		defw	0

title_txt	defb    'WORLD.ASM UNIT TESTS'
title_len	equ     $-title_txt

test_0_txt	defb    ': is_wall(0,0) = 1'
test_0_len	equ     $-test_0_txt
test_1_txt	defb    ': is_wall(1,1) = 0'
test_1_len	equ     $-test_1_txt
test_2_txt	defb    ': is_wall(31,31) = 1'
test_2_len	equ     $-test_2_txt
test_3_txt	defb    ': is_wall(30,30) = 0'
test_3_len	equ     $-test_3_txt
test_4_txt	defb    ': is_wall(30,31) = 1'
test_4_len	equ     $-test_4_txt
test_5_txt	defb    ': is_wall(1,31) = 1'
test_5_len	equ     $-test_5_txt
test_6_txt	defb    ': is_wall(20,10) = 1'
test_6_len	equ     $-test_6_txt
test_7_txt	defb    ': is_wall(20,9) = 0'
test_7_len	equ     $-test_7_txt

test_10_txt	defb    ': sla16(1 << 5) = 32'
test_10_len	equ     $-test_10_txt
test_11_txt	defb    ': sla16(1 << 8) = 256'
test_11_len	equ     $-test_11_txt
test_12_txt	defb    ': sla16(2 << 8) = 512'
test_12_len	equ     $-test_12_txt
test_13_txt	defb    ': sla16(1 << 9) = 512'
test_13_len	equ     $-test_13_txt

test_14_txt	defb    ': srl16(1024 >> 1) = 512'
test_14_len	equ     $-test_14_txt
test_15_txt	defb    ': srl16(32 >> 5) = 1'
test_15_len	equ     $-test_15_txt
test_16_txt	defb    ': srl16(32568 >> 4) = 2035'
test_16_len	equ     $-test_16_txt

main:
		; Clear the screen.
		ld d,blank
		ld hl,screen 
		ld bc,64*16
		call barden_fill
		show_title title,0,22

		; -------------------
		; -- IS_WALL TESTS --
		; -------------------

		; Test 0: is_wall(0,0) = 1
		show_title test_0,1,2
		ld l,0
		ld c,0
		call is_wall
		cp_a_byte_to 1,1,0

		; Test 1: is_wall(1,1) = 0
		show_title test_1,2,2
		ld l,1
		ld c,1
		call is_wall
		cp_a_byte_to 0,2,0

		; Test 2: is_wall(31,31) = 1
		show_title test_2,3,2
		ld l,31
		ld c,31
		call is_wall
		cp_a_byte_to 1,3,0

		; Test 3: is_wall(30,30) = 0
		show_title test_3,4,2
		ld l,30
		ld c,30
		call is_wall
		cp_a_byte_to 0,4,0

		; Test 4: is_wall(30,31) = 1
		show_title test_4,5,2
		ld l,30
		ld c,31
		call is_wall
		cp_a_byte_to 1,5,0

		; Test 5: is_wall(1,31) = 1
		show_title test_5,6,2
		ld l,1
		ld c,31
		call is_wall
		cp_a_byte_to 1,6,0

		; Test 6: is_wall(20,10) = 1
		show_title test_6,7,2
		ld l,20
		ld c,10
		call is_wall
		cp_a_byte_to 1,7,0

		; Test 7: is_wall(20,9) = 0
		show_title test_7,8,2
		ld l,20
		ld c,9
		call is_wall
		cp_a_byte_to 0,8,0

                ; -----------------
                ; -- SLA16 TESTS --
                ; -----------------

                ; Test 10: sla16(1 << 5) = 32
                show_title test_10,1,34
                ld hl,1
                ld a,5
                call sla16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 32,1,32

                ; Test 11: sla16(1 << 8) = 256
                show_title test_11,2,34
                ld hl,1
                ld a,8
                call sla16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 256,2,32

                ; Test 12: sla16(2 << 8) = 512
                show_title test_12,3,34
                ld hl,2
                ld a,8
                call sla16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 512,3,32

                ; Test 13: sla16(1 << 9) = 512
                show_title test_13,4,34
                ld hl,1
                ld a,9
                call sla16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 512,4,32

                ; Test 14: srl16(1024 << 1) = 512
                show_title test_14,6,34
                ld hl,1024
                ld a,1
                call srl16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 512,6,32

                ; Test 15: srl16(32 >> 5) = 1
                show_title test_15,7,34
                ld hl,32
                ld a,5
                call srl16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 1,7,32

                ; Test 16: srl16(32568 >> 4) = 2035
                show_title test_16,8,34
                ld hl,32568
                ld a,4
                call srl16
		ld (tmp16),hl
		ld de,(tmp16)
                cp_de_int16_to 2035,8,32

hcf:		jr hcf
		end main
