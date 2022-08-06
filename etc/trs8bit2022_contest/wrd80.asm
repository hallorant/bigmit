;
; wrd80.z -- word guessing game
;

@dsp	equ	2		; outputs C
@keyin	equ	9		; wants C = 0
numans	equ	2313		; number of answers (count of words in answers.txt)

	org	$5200
start:	ld	h,2		; maybe Model II
	in	a,($fa)
	or	a
	jr	z,gotmod
	ld	hl,0		; cheap, cheap Model 4 test
	ld	a,(hl)
	inc	(hl)
	cp	(hl)
	jr	z,gotmod	; Model 1 or 3, we presume.
	dec	(hl)
	ld	h,1		; Model 4
gotmod:	ld	a,h
	ld	(model),a

	ld	hl,intro
	call	print

puzin:	ld	hl,puzmsg
	call	print
	ld	b,4
	ld	hl,buf
	call	input
	ld	a,b
	or	a
	jr	z,puzin
	ld	de,buf
	ld	a,(de)
	cp	'Q'
	ret	z
	cp	'q'
	ret	z
	ld	hl,0
pint:	ld	a,(de)
	inc	de
	sub	'0'
	jr	c,puzin
	cp	10
	jr	nc,puzin
	push	bc		; [
	push	hl		; [
	add	hl,hl		; *2
	add	hl,hl		; *4
	pop	bc		; ]
	add	hl,bc		; *5
	add	hl,hl		; *10
	ld	b,0
	ld	c,a
	add	hl,bc		; put in digit
	pop	bc		; ]
	djnz	pint

	ld	a,h
	or	l
	jr	z,puzin

	dec	hl
	push	hl		; [
	ld	de,-numans
	add	hl,de
	pop	hl		; ]
	jr	c,puzin

	ex	de,hl
	ld	hl,target

	call	getpuz

	ld	a,'1'
	ld	(gnum),a
	jr	guess
bad:	ld	hl,upmsg+1
	call	print
guess:	ld	hl,guemsg
	call	print
	ld	b,5
	ld	hl,buf
	call	input
	ld	a,b
	cp	5
	jr	nz,bad

	; Check that all 5 input values are letters.
	; And uppercase them as needed.

	ld	hl,buf
	ld	b,5
vlp:	ld	a,(hl)
	sub	'A'
	jr	c,bad
	cp	26
	jr	c,lok
	sub	'a'-'A'
	jr	c,bad
	cp	26
	jr	nc,bad
lok:	add	'A'
	ld	(hl),a
	inc	hl
	djnz	vlp

	ld	hl,buf
	call	isword
	or	a
	jr	nz,valid

	ld	hl,notmsg
	call	print
	ld	hl,upmsg
	call	print
	jr	guess

	; Look for exact matches and initialize hint and avail
	; those or the remaining letters.
valid:	ld	ix,buf
	ld	b,5
	ld	e,1		; assume we matched all
exlp:	ld	a,(ix)
	ld	c,'='		; assume we match
	ld	d,(ix+target-buf)
	cp	d
	jr	z,exact
	ld	e,0		; we didn't match all
	ld	c,d		; can use this letter for near matches
exact:	ld	(ix+hint-buf),c	; update hint
	ld	(ix+avail-buf),c; update available letters
	inc	ix
	djnz	exlp

	; Now check the rest to see if they're in the wrong place
	ld	ix,buf
	ld	b,5
nrlp:	ld	hl,avail
	ld	d,5
	ld	a,(ix+hint-buf)
	cp	'='
	jr	z,done		; skip if we've already done exact match
	ld	a,(ix)
	ld	c,'-'		; assume we'll find it
nrlp2:	cp	(hl)
	jr	z,near
	inc	hl
	dec	d
	jr	nz,nrlp2
	ld	c,' '		; didn't find it
near:	ld	(hl),'-'	; letter N no longer available (might be 6th)
	ld	(ix+hint-buf),c	; hint that we found it or not
done:	inc	ix
	djnz	nrlp

	push	de		; [
	ld	ix,hint
	ld	b,5
show:	ld	a,(ix)
	ld	c,a
	call	putc
	ld	a,(ix+buf-hint)
;	add	'A'
	call	putc
	ld	a,c
	call	putc
	ld	a,' '
	call	putc
	inc	ix
	djnz	show

	ld	a,13
	call	putc
	pop	de		; ]

	dec	e
	jr	z,win

	ld	a,(gnum)
	inc	a
	ld	(gnum),a
	cp	'6'+1
	jp	nz,guess

	ld	hl,losmsg
	call	print

	ld	hl,target
	ld	b,5
ptar:	ld	a,(hl)
	inc	hl
;	add	'A'
	call	putc
	djnz	ptar
	ld	a,13
	call	putc
	jp	puzin

win:	ld	hl,winmsg
	call	print
	jp	puzin

putc:	push	af
	ld	a,(model)
	dec	a
	jr	z,p4
	dec	a
	jr	nz,p13
	; Model II character print
	pop	af
	push	af		; [
	push	bc		; [
	ld	b,a
	cp	27
	jr	nz,chok
	ld	b,11
chok:	ld	a,8		; VDCHAR
	rst	8
	pop	bc		; ]
	pop	af		; ]
	ret

p4:	pop	af
	push	bc
	ld	c,a
	ld	a,@dsp
	rst	$28
	ld	a,c
	pop	bc
	ret
p13:	pop	af
	jp	$33

print:	ld	a,(hl)
	inc	hl
	or	a
	ret	z
	call	putc
	jr	print

input:	ld	a,(model)
	dec	a
	jr	z,i4
	dec	a
	jp	nz,$40
	; Model II input auto inputs at end so add a character
	inc	b
	ld	a,5		; KBLINE
	rst	8
	; And it counts the terminating enter so trim that off
	dec	b
	ret

i4:	ld	c,0
	ld	a,@keyin
	rst	$28
	ret

strfy	macro	n
	ascii	'&n'
	endm

intro:	ascii	'Welcome to wrd80! You have 6 tries to guess a 5 letter word.',13
	ascii	'After each guess you will be given some hints.',13
	ascii	'Letters surrounded with = = are in the right place.',13
	ascii	'Letters surrounded with - - are in the wrong place. ',13
	ascii	'Unmarked letters are not in the word at all. ',13,0
puzmsg:	ascii	'Puzzle number (1 .. '
	strfy	%numans
	ascii	') or Q to quit? ',0
guemsg:	ascii	'Guess number '
gnum:	ascii	'1? ',0
notmsg:	ascii	'Word invalid.',13,0
upmsg:	ascii	27,27,0
winmsg:	ascii	'Correct!  Well done.',13,0
losmsg:	ascii	'Sorry.  The word was ',0

	include	dictionary.asm

model:	defs	1
hint:	defs	5
avail:	defs	5+1
target:	defs	5
buf:	defs	5+1

	end	start
