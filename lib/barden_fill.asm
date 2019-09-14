; William Barden, Jr. 'TRS-80 Assembly-Language Programming', 1979 pg 189.
;
; Fills a block of memory with a given 8-bit value.
;
; Uses: a, bc, d, hl
;
; Entry: d   data to be filled (the 8-bit value)
;        hl  start addr of the fill area
;        bc  # of bytes to fill
; Exit:  d   same
;        hl  end addr of the fill area + 1
;        bc  0
;        a   0
barden_fill:
	ld (hl),d	; Actually do fill
	inc hl		; To next addr
	dec bc		; Count down byte count
	ld a,b		; Goto FILL if byte count != 0
	or c
	jr nz,barden_fill
	ret
