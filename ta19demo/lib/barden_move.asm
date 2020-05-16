; William Barden, Jr. 'TRS-80 Assembly-Language Programming', 1979 pg 190.
;
; Moves one block of memory to another area in memory.
; The blocks may be overlapping. The move is either done
; forwards or backwards depending upon overlap (if any).
;
; Uses: a, bc, de, hl
;
; Entry: hl  addr source start
;        de  addr destination start
;        bc  # of bytes to move
; Exit:  hl  addr source area + 1
;        de  addr destination area + 1
;        bc  0
barden_move:
	push hl
	or a		; Clear carry
	sbc hl,de	; Carry set if dest before start
	pop hl		; Restore source start
	jr c,__barden_move_in_reverse
	ldir
	ret
__barden_move_in_reverse:
	add hl,bc	; Setup for reverse move by
	dec hl		; setting addrs to source and
	ex de,hl	; dest end.
	add hl,bc
	dec hl
	ex de,hl
	lddr
	ret
