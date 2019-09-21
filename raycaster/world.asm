; __          __        _     _ 
; \ \        / /       | |   | |
;  \ \  /\  / /__  _ __| | __| |
;   \ \/  \/ / _ \| '__| |/ _` |
;    \  /\  / (_) | |  | | (_| |
;     \/  \/ \___/|_|  |_|\__,_|
;
; Author: Tim Halloran
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

import '../lib/reverse_bits.asm'
import '../lib/sla16.asm'
import '../lib/srl16.asm'

; Checks if the bit in byte is the value we should return. Reduces pos by one
; and logical shifts byte right one bit to get ready for the next call.
; Returns if the correct bit is found.
;
; byte is the tabel lookup byte.
; pos  position 1-8 of bit in byte.
check_bit	macro byte,pos,?ret0value,?cont
		dec pos
		jr nz,?cont
		bit 0,byte
		jr z,?ret0value
		ld a,1
		ret
?ret0value:	ld a,0
		ret
?cont:		srl byte
		endm

; Checks if the passed row and column are a wall in the world.
; Enter: l  The row in the world (y value).
;        c  The column in the world (x value).
; Exit:  a  Wall value (0 or 1).
is_wall:	ld h,0
		ld b,0
		ld a,5
		call sla16	; a << 5 equals row * 32.
		add hl,bc
		ld a,$07
		and l
		ld c,a		; Position 0-7 of bit is in c.
		ld a,3
		call srl16	; a >> 3 to remove position bits.
		ld de,world	; Start at addr of world table.
		add hl,de	; Add byte offset calculated above.
		ld b,(hl)	; Table lookup byte is in b.
		inc c		; Change to 1-8 (from 0-7).
		check_bit b,c
		check_bit b,c
		check_bit b,c
		check_bit b,c
		check_bit b,c
		check_bit b,c
		check_bit b,c
		check_bit b,c

; Called once to flip the bits in the world map below. This allows the
; map to be easier for humans to work on and is only done at program
; start so it won't hurt performance of the raycaster.
prepare_world:		ld bc,32*4
			ld hl,world
__prepare_world_loop:	ld a,(hl)
			push bc		; Save bc value (or lost on call).
			call reverse_bits
			pop bc
			ld (hl),a
			inc hl
			dec bc		; Doesn't set zero flag!
			ld a,c		; Check if bc is zero.
			or b
			ret z
			jr __prepare_world_loop
			

; The world map 32x32 (2^5x3^5 -- a power of 2).
;
; Note that the bitmap is not difficult to read because we use
; the 'prepare_world' subroutine to reverse the bits. If you do
; not call this then the bit order will be backwards!
world		defb	11111111b,11111111b,11111111b,11111111b
world_01	defb	10000000b,00000000b,00000000b,00000001b
world_02	defb	10000000b,00000000b,00000000b,00000001b
world_03	defb	10000000b,00000000b,00000001b,11100001b
world_04	defb	10000000b,00111000b,00000001b,11100001b
world_05	defb	10000000b,00111000b,00000001b,11100001b
world_06	defb	10000000b,00111000b,00000000b,00000001b
world_07	defb	10000000b,00000000b,00000000b,00000001b
world_08	defb	10000000b,00000000b,00000000b,00000001b
world_09	defb	10000000b,00000000b,00000000b,00000001b
world_10	defb	10000000b,00000000b,00000000b,00000001b
world_11	defb	10000000b,00000000b,00000000b,00000001b
world_12	defb	10000000b,00000000b,00000000b,00000001b
world_13	defb	10000000b,00000000b,00000000b,00000001b
world_14	defb	10000000b,00000000b,00000000b,00000001b
world_15	defb	10000000b,00000000b,00000000b,00000001b
world_16	defb	10000000b,00000000b,00000000b,00000001b
world_17	defb	10000000b,00000000b,00000000b,00000001b
world_18	defb	10000000b,00111000b,00000000b,00000001b
world_19	defb	10000000b,00111000b,00000000b,00000001b
world_20	defb	10000000b,00111000b,00000000b,00000001b
world_21	defb	10000000b,00000000b,00000000b,00000001b
world_22	defb	10000000b,00000000b,00000000b,00000001b
world_23	defb	10000000b,00000000b,00000000b,00000001b
world_24	defb	10000000b,00000000b,00000000b,00000001b
world_25	defb	10000000b,00000000b,00000000b,00000001b
world_26	defb	10000000b,00000000b,00000000b,00000001b
world_27	defb	10000000b,00000000b,00000000b,00000001b
world_28	defb	10000000b,00000000b,00000000b,00000001b
world_29	defb	10000000b,00000000b,00000000b,00000001b
world_30	defb	10000000b,00000000b,00000000b,00000001b
world_31	defb	11111111b,11111111b,11111111b,11111111b
