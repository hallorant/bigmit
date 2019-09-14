; Fills a block of memory with a given 8-bit value.
; ENTRY: (D)  data to be filled
;        (HL) addr start of fill area
;        (BC) # of bytes to fill
;        CALL FILL
; EXIT:  (D)  same
;        (HL) addr end of fill area + 1
;        (BC) 0
;        (A)  0
fill:	ld (hl),d	; Actually do fill
	inc hl		; To next addr
	dec bc		; Count down byte count
	ld a,b		; Goto FILL if byte count != 0
	or c
	jr nz,fill
	ret
