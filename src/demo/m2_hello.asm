; Toy Model 2 program that writes "Hello TRS-80 Model II" at the center
; of the screen via operating system calls.
  org $3000
text	defb	'Hello TRS-80 Model II'	
main:
  ; Clear the screen.
  ld b,1
  ld c,1
  ld a,7   ; VDINIT (pg 234)
  rst 8
  ; Display our text @ row 11 column 29.
  ld b,11  ; row
  ld c,29  ; column
  ld d,21  ; 'text' length
  ld hl,text
  ld a,10  ; VDGRAF (pg 237)
  rst 8
  ; Return to TRSDOS prompt.
  rst 0
  end main
