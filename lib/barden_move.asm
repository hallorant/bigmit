; Moves one block of memory to another area in memory.
; The blocks may be overlapping. The move is either done
; forwards or backwards depending upon overlap (if any).
; ENTRY: (hl) addr source start
;        (de) addr destination start
;        (bc) # of bytes to move
;        CALL MOVE
; EXIT:  (hl) addr source area + 1
;        (de) addr destination area + 1
;        (bc) 0
move:		push	hl
		or	a		; Clear carry
		sbc	hl,de		; Carry set if dest before start
		pop	hl		; Restore source start
		jr	c,move_reverse	; To reverse move, if needed
		ldir
		jr	move_ret
move_reverse:	add	hl,bc		; Setup for reverse move by
		dec	hl		; setting addrs to source and
		ex	de,hl		; dest end.
		add	hl,bc
		dec	hl
		ex	de,hl
		lddr
move_ret:	ret
