; Reverses the bits within a byte.
;
; Uses: a,b,c
;
; Entry: a  a byte
; Exit:  a  a with its bits reversed.
reverse_bits:		ld c,8
			ld b,a	; b is now the input value.
			xor a	; clear for output.
__reverse_bits_loop:	sla a
			srl b	; c >>> 1
			jp nc,__reverse_bits_cont
			or a,1
__reverse_bits_cont:	dec c
			ret z
			jr __reverse_bits_loop
