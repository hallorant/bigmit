; Toy Model 2 program that writes "Hello TRS-80 Model II" at the center
; of the screen via operating system calls.
  org $3000
text	defb	'Hello TRS-80 Model II'	
main:
; Use VDINIT (pg 234) to clear the screen.
  ld b,1
  ld c,1
  ld a,7   ; TRSDOS function code
  rst 8
; Use VDGRAF (pg 237) to display our text.
  ld b,11  ; row
  ld c,29  ; column
  ld d,21  ; 'text' length
  ld hl,text
  ld a,10  ; TRSDOS function code
  rst 8
; Just hang the machine here so we can see the text.
; This is bad form on an OS.
hcf:
  jp hcf
  end main
