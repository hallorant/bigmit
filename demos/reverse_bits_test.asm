; Unit tests for reverse_bits.asm
	org $4a00
import '../lib/barden_fill.asm'
import '../lib/barden_move.asm'
import '../lib/reverse_bits.asm'

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

title_txt	defb    'REVERSE_BITS.ASM UNIT TESTS'
title_len	equ     $-title_txt

test_0_txt	defb    ': reverse_bits($55) = $aa'
test_0_len	equ     $-test_0_txt
test_1_txt	defb    ': reverse_bits($aa) = $55'
test_1_len	equ     $-test_1_txt
test_2_txt	defb    ': reverse_bits($01) = $80'
test_2_len	equ     $-test_2_txt
test_3_txt	defb    ': reverse_bits($80) = $01'
test_3_len	equ     $-test_3_txt

main:
		; Clear the screen.
		ld d,blank
		ld hl,screen 
		ld bc,64*16
		call barden_fill
		show_title title,0,18

		; ------------------------
		; -- REVERSE_BITS TESTS --
		; ------------------------

		; Test 0: reverse_bits($aa) = $55
		show_title test_0,1,2
		ld a,$aa
		call reverse_bits
		cp_a_byte_to $55,1,0

		; Test 1: reverse_bits($55) = $aa
		show_title test_1,2,2
		ld a,$55
		call reverse_bits
		cp_a_byte_to $aa,2,0

		; Test 2: reverse_bits($01) = $80
		show_title test_2,3,2
		ld a,$01
		call reverse_bits
		cp_a_byte_to $80,3,0

		; Test 2: reverse_bits($80) = $01
		show_title test_3,4,2
		ld a,$80
		call reverse_bits
		cp_a_byte_to $01,4,0

hcf:		jr hcf
		end main
