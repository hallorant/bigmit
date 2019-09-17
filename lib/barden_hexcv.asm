; William Barden, Jr. 'TRS-80 Assembly-Language Programming', 1979 pg 198.
;
; Subroutine to covert 1 byte into a hex value in ASCII.
;
; Uses:  a,c,hl
;
; Entry: a   byte to be converted
; Exit:  hl  hex value in ASCII for a, high and low
barden_hexcv:		ld c,a			; Save two hex digits
			srl a			; Align high digit
			srl a
			srl a
			srl a
			call __barden_hexcv_cvt	; Convert to ASCII
			ld h,a			; Save for return
			ld a,c			; Restore original
			and $0f			; Get low digit
			call __barden_hexcv_cvt	; Convert to ASCII
			ld l,a			; Save for return
			ret
__barden_hexcv_cvt:	add a,$30		; Conversion factor
			cp $3a
			jr c,__barden_hexcv
			add a,7
__barden_hexcv:		ret

