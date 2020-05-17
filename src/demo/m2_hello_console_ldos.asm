; LDOS 06.03.02
; Document: "The Programmer's Guide to TRSDOS Version 6" / LDOS Version 6 too
; (from Tim Mann's site)
; Toy Model 2 program that writes "Hello TRS-80 Model II" to the console
; via operating system calls.
  org $7000
text	defb	'Hello TRS-80 Model II',$0d	
trs	defb	'TRS-80 assembly OS programming ',$03
fun	defb	'is fun',$0d
newln	defb	$0d	
main:

  ld hl,newln
  ld a,10  ; @DSPLY (pg 7-19)
  rst 40

  ld hl,text
  ld a,10  ; @DSPLY (pg 7-19)
  rst 40

  ld hl,trs
  ld a,10  ; @DSPLY (pg 7-19)
  rst 40

  ld hl,fun
  ld a,10  ; @DSPLY (pg 7-19)
  rst 40

  ; Return to TRSDOS prompt.
  ld hl,0  ; Normal termination
  ld a,22  ; @EXIT (pg 7-19)
  rst 40

  end main
