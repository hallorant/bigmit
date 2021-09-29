; org_fun.asm
;
; zmac org_fun.asm
; trs80gp -dx -c zout/org_fun.1500.cas (do "system" then "o")
screen	equ	$3c00

; This is how fancy tape loaders (like Big Five) wrote to the screen.
  org screen
  dc 64*16,$20    ; clear the entire screen

  org screen+64*5 ; start of the 6th line on the screen
	defb	'Hello, TRS-80 World!'
  org screen+64*7 ; start of the 6th line on the screen
	defb	'(This is how BigFive did fancy cassette loads)'

  org $5200
main:
  ; Pause until the machine is rebooted.
  jr main

  org $41e2
  jp (hl) ; cassette auto-start
  end main
