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

; The world map 32x32 (2^5x3^5 -- a power of 2).
;
; Note that the bitmap is a bit difficult to read because the
; bit order is backwards (we'd want 0......7 not what we have).
;                       7......0  7......0  7......0  7......0
world		defb	11111111b,11111111b,11111111b,11111111b
world_01	defb	00000001b,01100011b,00011000b,10000000b
world_02	defb	00000001b,01100011b,00011000b,10000000b
world_03	defb	00011111b,00000000b,00000000b,10000000b
world_04	defb	00000111b,00000000b,00000000b,10000000b
world_05	defb	00011111b,00000000b,00000000b,10000000b
world_06	defb	00000001b,00000000b,11110000b,10000000b
world_07	defb	00000001b,00000000b,11110000b,10000011b
world_08	defb	00000001b,00000000b,11110000b,10000011b
world_09	defb	00000001b,00000000b,11110000b,10000000b
world_10	defb	00000001b,00000000b,00000000b,10000000b
world_11	defb	00000001b,00000000b,00000000b,10000000b
world_12	defb	00001111b,00000000b,00011110b,10000000b
world_13	defb	00001111b,00000000b,00011110b,10000000b
world_14	defb	00001111b,00000000b,00000000b,10000000b
world_15	defb	00000001b,00000111b,00000000b,10000000b
world_16	defb	00000001b,00000111b,00000000b,10000000b
world_17	defb	00000001b,00000000b,00000000b,10000000b
world_18	defb	00000001b,00000000b,00000000b,11100000b
world_19	defb	00000001b,00000000b,00000000b,11100000b
world_20	defb	00000001b,00011100b,00000000b,11100000b
world_21	defb	00000001b,00011100b,00000000b,11100000b
world_22	defb	00000001b,00011100b,00000000b,10000000b
world_23	defb	11111111b,11111111b,11111111b,10000000b
world_24	defb	00000001b,00000000b,11000000b,10000000b
world_25	defb	00000001b,00000000b,11000000b,10000000b
world_26	defb	00000001b,00000000b,11000000b,10000000b
world_27	defb	00000001b,00000000b,11000000b,10000000b
world_28	defb	00000001b,00000000b,11000000b,11100000b
world_29	defb	00000001b,11100000b,00000000b,11100000b
world_30	defb	00000001b,11100000b,00000000b,10000000b
world_31	defb	11111111b,11111111b,11111111b,11111111b
