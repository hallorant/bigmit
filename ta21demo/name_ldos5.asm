; name_ldos5
; Reference Document:
;   LDOS Version 5.1: The TRS-80 Operating System Model I and III
;
; zmac name_ldos5.asm
; trs80gp -ld zout/name_ldos5.cmd
  org $7000

@DSPLY		equ	$4467 ; pg 6-66
@KEYIN		equ	$0040 ; pg 6-65
@EXIT		equ	$402d ; pg 6-60

ENTER		equ	$0d ; @DSPLY with newline
ETX		equ	$03 ; @DSPLY with no newline

hello_world	defb	'Hello, TRS-80 World!',ENTER
name_prompt	defb	'Hey! What is your name? ',ETX
name_prefix	defb	'Hello, ',ETX
goodbye		defb	'Goodbye, from the TRS-80 World!',ENTER

buffer	defs	32 ; a small IO buffer

main:
  ld hl,hello_world
  call @DSPLY
  ld hl,name_prompt
  call @DSPLY

  ld b,30
  ld hl,buffer
  call @KEYIN

  ld hl,name_prefix
  call @DSPLY
  ld hl,buffer
  call @DSPLY
  ld hl,goodbye
  call @DSPLY

  call @EXIT
  end main
