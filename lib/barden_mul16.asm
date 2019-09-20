; William Barden, Jr. 'TRS-80 Assembly-Language Programming', 1979 pg 190.
;
; Multiplies a 16-bit number by an 8-bit number.
;
; Entry: de  16-bit multiplicand, unsigned
;         b  8-bit multiplier, unsigned
; Exit:  hl  product
;        de  addr destination area + 1
;        bc  0
barden_mul16:		ld hl,0		; Clear initial product
__barden_mul16_loop:	srl b		; Shift out multiplier bit
			jr nc,__barden_mul16_cont  ; go if no carry (1 bit)
			add hl,de	; Add multiplicand
__barden_mul16_cont:	ret	z	; Go if multiplicand
			ex de,hl	; Multiplicand to hl
			add hl,hl	; Shift Multiplicand
			ex de,hl	; Swap back
			jr __barden_mul16_loop
