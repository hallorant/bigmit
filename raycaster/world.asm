
; Enter: hl  The row in the world (y value).
;        c   The column in the world (x value).
; Exit:  a   Wall value (0 or 1).
is_wall:	ld a,5
		call sla16	; a << 5 equals row * 32.
		add hl,c
		ld b,(hl)	; Table lookup byte is in b.
		ld a,$07
		and l
		ld l,a		; Position 0-7 of bit in b is in l.
		check_bit b,l
		check_bit b,l
		check_bit b,l
		check_bit b,l
		check_bit b,l
		check_bit b,l
		check_bit b,l
		check_bit b,l

; Checks if the bit in byte is the value we should return. Reduces pos by one
; and logical shifts byte right one bit to get ready for the next call.
; Returns if the correct bit is found.
;
; byte is the tabel lookup byte.
; pos  position 0-7 of bit in byte.
check_bit	macro byte,pos,?
		ld a,pos
		or a
		jr nz,?cont
		bit 0,byte
		jr z,?ret0
		ld a,1
		ret
?ret0:		ld a,0
		ret
?cont:		dec pos
		srl byte
		endm

; The world map 32x32 (2^5x3^5 -- a power of 2).
world		defb	11111111b,11111111b,11111111b,11111111b
world_01	defb	10000000b,01100011b,00011000b,00000001b
world_02	defb	10000000b,01100011b,00011000b,00000001b
world_03	defb	10011110b,00000000b,00000000b,00000001b
world_04	defb	10011110b,00000000b,00000000b,00000001b
world_05	defb	10011110b,00000000b,00000000b,00000001b
world_06	defb	10000000b,00000001b,11110000b,00000001b
world_07	defb	10000000b,00001101b,11110000b,00000001b
world_08	defb	10000000b,00001101b,11110000b,00000001b
world_09	defb	10000000b,00000001b,11110000b,00000001b
world_10	defb	10000000b,00000000b,00000000b,00000001b
world_11	defb	10000000b,00000000b,00000000b,00000001b
world_12	defb	10001110b,00000000b,00011110b,00000001b
world_13	defb	11111110b,00000000b,00011110b,00000001b
world_14	defb	10001110b,00000000b,00000000b,00000001b
world_15	defb	10000000b,00000111b,00000000b,00000001b
world_16	defb	10000000b,00000111b,00000000b,00000001b
world_17	defb	10000000b,00000000b,00000011b,00000001b
world_18	defb	11011011b,01101100b,11000011b,00000001b
world_19	defb	11111111b,11111111b,11000000b,00000001b
world_20	defb	10000000b,00000011b,00000000b,00000001b
world_21	defb	10000000b,00000000b,00000000b,00000001b
world_22	defb	10101010b,10101010b,10101011b,00000001b
world_23	defb	11111111b,11111111b,11111111b,00000001b
world_24	defb	10000000b,00000000b,00000011b,00000001b
world_25	defb	10000000b,00000000b,00000011b,00000001b
world_26	defb	10000111b,00000000b,00000011b,00000001b
world_27	defb	10000111b,00000000b,00000011b,00000001b
world_28	defb	10000111b,00000000b,00000011b,00000001b
world_29	defb	10000000b,00000011b,00000000b,00000001b
world_30	defb	10000000b,00000011b,00000000b,00000001b
world_31	defb	10000000b,00000011b,00000000b,00000001b
world_32	defb	11111111b,11111111b,11111111b,11111111b
