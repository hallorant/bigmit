; Multiplies a 16-bit number by a power of 2.
;
; Used: a, hl, d
;
; Entry: hl  16-bit multiplicand, unsigned
;	  a  shift count
; Exit:  hl  result of de shifted by c bits
sla16:			ld d,a
			or a
__sla16_loop:		ret z
			sla h
			sla l
			jr nc,__sla16_cont
			ld a,1
			add a,h
			ld h,a
__sla16_cont:		dec d
			jr __sla16_loop
