; Toy Model 2 program that writes "Hello TRS-80 Model II" at the center
; of the screen via operating system calls.
  org $7000
text	defb	'Hello TRS-80 Model II'	
textln	equ	$-text
cp	defb	'TRS-80 '	
cpln	equ	$-cp
fun	defb	'is fun'	
funln	equ	$-fun
main:
  ; Clear the screen.
;  ld b,1
;  ld c,1
;  ld a,7   ; VDINIT (pg 234)
;  rst 8

  ; Newline
  ld hl,0
  ld b,0  ; 'text' length
  ld c,$0d ; End of line character
  ld a,9  ; VDLINE (pg 236)
  rst 8

  ld hl,text
  ld b,textln
  ld c,$0d ; End of line character
  ld a,9  ; VDLINE (pg 236)
  rst 8

  ld hl,text
  ld b,textln
  ld c,$0d ; End of line character
  ld a,9  ; VDLINE (pg 236)
  rst 8

  ld hl,cp
  ld b,cpln
  ld c,$03 ; End of line character
  ld a,9  ; VDLINE (pg 236)
  rst 8

  ld hl,fun
  ld b,funln
  ld c,$0d ; End of line character
  ld a,9  ; VDLINE (pg 236)
  rst 8

  ; Return to TRSDOS prompt.
  rst 0
  end main
