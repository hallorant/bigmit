; Shift-left of a 16-bit value.
;
; Used: a, hl, d
;
; Entry: hl  16-bit value
;	  a  shift count
; Exit:  hl  result of hl shifted left by c bits
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
