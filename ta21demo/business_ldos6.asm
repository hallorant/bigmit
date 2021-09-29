; business_ldos6.asm
; Reference doc:
;   The Programmer's Guide to TRSDOS Version 6 (also LDOS Version 6)
;
; zmac hello_ldos6.asm
; trs80gp -m2 -ld zout/business_ldos6.cmd
; trs80gp -m12 -ld zout/business_ldos6.cmd
; trs80gp -m16 -ld zout/business_ldos6.cmd
; trs80gp -m4 -ld zout/business_ldos6.cmd
  org $7000

@DSPLY	equ	10 ; pg 7-19
@EXIT	equ	22 ; pg 7-19

ENTER	equ	$0d ; @DSPLY with newline

text	defb	'Hello, Business TRS-80 World!',ENTER

main:
  ld hl,text
  ld a,@DSPLY
  rst 40

  ld hl,0 ; Normal termination
  ld a,@EXIT
  rst 40

  end main
