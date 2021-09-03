;
; hello_ldos5 -- Model 1 or Model 3 running LDOS 5.1
;
; Reference: LDOS Version 5.1: The TRS-80 Operating System Model I and III
;
; zmac --zmac hello_ldos5.asm
; trs80gp -m1 -ld zout/hello_ldos5.cmd
; trs80gp -m3 -ld zout/hello_ldos5.cmd
  org $7000

ETX	equ	$03
text	defb	'Hello, TRS-80 World!',ETX

main:
  ; Call DOS to print a line of text.
  ld hl,text
  call $4467 ; @DSPLY

  ; Return to the DOS prompt.
  call $402d ; @EXIT (pg 6-51)
  end main
