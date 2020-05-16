; Shift-right for a 16-bit value.
;
; Used: a, hl, d
;
; Entry: hl  16-bit value
;	  a  shift count
; Exit:  hl  result of hl shifted right by c bits
srl16:			ld d,a
			or a
__srl16_loop:		ret z
			srl l
			srl h
			jr nc,__srl16_cont
			ld a,$80
			or a,l
			ld l,a
__srl16_cont:		dec d
			jr __srl16_loop
