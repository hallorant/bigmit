;
; 04_hello_world.asm -- Model II / Model 4 LDOS 6
;
; Reference: The Programmer's Guide to TRSDOS Version 6 (also LDOS Version 6)
;
; zmac --zmac 04_hello_world.asm
; trs80gp -m2 -ld zout/04_hello_world.cmd
; trs80gp -m4 -ld zout/04_hello_world.cmd
  org $7000

ETX	equ	$03
text	defb	'Hello, TRS-80 World!',ETX

main:
  ; Call DOS to print a line of text.
  ld hl,text
  ld a,10  ; @DSPLY (pg 7-19)
  rst 40

  ; Return to the DOS prompt.
  ld hl,0  ; Normal termination
  ld a,22  ; @EXIT (pg 7-19)
  rst 40
  end main
