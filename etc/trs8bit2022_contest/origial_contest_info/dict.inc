;
; Two core subroutines for wrd80:
;
; getpuz - put 5 letter answer number DE to memory at HL
; isword - check if 5 letter answer at HL is a valid word
;	   returns A non-zero if word is valid, A = 0 otherwise
;
; Both routines only need work on valid input.

; Label so we can compute the total size of the subroutines and data.
dict_start:

; getpuz - put 5 letter answer number DE to memory at HL

getpuz:	push	hl		; [
	ld	h,d
	ld	l,e
	add	hl,de		; *2
	add	hl,de		; *3
	ld	de,words
	add	hl,de		; address of packed word

	; load packed target
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	ld	b,0
	push	bc
	exx
	pop	hl
	exx
	ex	de,hl		; HL'HL is 24 bit answer

	; unpack target
	ld	b,5
	pop	ix		; ]
upck:	ld	a,'A'-1
m26	equ	-1*26*26*26*26
	ld	de,m26 & $ffff
	exx
	ld	de,m26 >> 16
	exx
getlet:	add	hl,de
	exx
	adc	hl,de
	exx
	inc	a
	jr	c,getlet
	sbc	hl,de
	exx
	sbc	hl,de
	exx
	ld	(ix),a
	inc	ix
	call	mul26
	djnz	upck
	ret

; isword - check if 5 letter answer at HL is a valid word

isword:	push	hl
	pop	ix

	ld	hl,0
	exx
	ld	hl,0
	exx

	ld	b,5
pg:	call	mul26
	ld	a,(ix)
	inc	ix
	sub	'A'
	ld	e,a
	ld	d,0
	add	hl,de
	exx
	ld	de,0
	adc	hl,de
	exx
	djnz	pg

	exx
	ld	a,l
	exx			; AHL is 24 bit packed word
	ld	d,a
	ld	e,h
	ld	a,l		; rearranged to DEA

	; Is DEA a valid word?

	ld	bc,numall
	ld	hl,words
vchk:	cpi
	jr	z,maybe	
	inc	hl
	inc	hl
	jp	v,vchk
nope:	xor	a
	ret

maybe:	ex	af,af'
	ld	a,(hl)
	inc	hl
	cp	e
	jr	nz,nomth
	ld	a,(hl)
	inc	hl
	cp	d
	jr	z,itis
	ld	a,0
	org	$-1
nomth:	inc	hl
	ex	af,af'
	jp	v,vchk
	jr	nope

itis:	ld	a,1
	ret

; Some 32 bit math macros and subroutines.

add32	macro	rp
	add	hl,rp
	exx
	adc	hl,rp
	exx
	endm

push32	macro	rp
	push	rp
	exx
	push	rp
	exx
	endm

pop32	macro	rp
	exx
	pop	rp
	exx
	pop	rp
	endm

mul26:	push32	hl		; [
	push32	hl		; [
	add32	hl		; *2
	pop32	de		; ]
	add32	de		; *3
	add32	hl		; *6
	add32	hl		; *12
	pop32	de		; ]
	add32	de		; *13
	add32	hl		; *26
	ret

pack5	macro	a1,a2,a3,a4,a5
	def3	(((('&a1'-'a')*26+('&a2'-'a'))*26+('&a3'-'a'))*26+('&a4'-'a'))*26+('&a5'-'a')
	endm

	include	wrd.inc

; The total size of subroutines and data.
dict_size equ $-dict_start
