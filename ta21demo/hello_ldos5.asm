; hello_ldos5
; Reference Document:
;   LDOS Version 5.1: The TRS-80 Operating System Model I and III
;
; zmac hello_ldos5.asm
; trs80gp -ld zout/hello_ldos5.cmd
  org $7000

@DSPLY	equ	$4467 ; pg 6-66
@EXIT	equ	$402d ; pg 6-60

ENTER	equ	$0d ; @DSPLY with newline

text	defb	'Hello, TRS-80 World!',ENTER

main:
  ld hl,text
  call @DSPLY

  call @EXIT
  end main
