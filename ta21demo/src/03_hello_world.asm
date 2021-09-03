;
; 03_hello_world.asm -- Use org to get the text on the screen
;
; zmac --zmac 03_hello_world.asm
; trs80gp -m1 zout/03_hello_world.bds
screen	equ	$3c00
screen_pos equ screen+64*5

; This is how fancy tape loaders (like Big Five) wrote to the screen.
  org screen
  dc 64*16,$20    ; clear the entire screen

  org screen+64*5 ; start of the 6th line on the screen
text	defb	'Hello, TRS-80 World!'

  org $5200
main:
  ; Pause until the machine is rebooted.
  jr main

  end main
