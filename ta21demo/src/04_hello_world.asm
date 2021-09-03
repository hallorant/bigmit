;
; 04_hello_world.asm -- Model 1/3 LDOS 5.1
;
; Reference: LDOS Version 5.1: The TRS-80 Operating System Model I and III
;
; zmac --zmac 04_hello_world.asm
; trs80gp -m1 -ld zout/04_hello_world.cmd
; trs80gp -m3 -ld zout/04_hello_world.cmd
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
