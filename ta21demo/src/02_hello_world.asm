;
; 02_hello_world.asm -- Don't calculate: use the assembler ;
;
; zmac --zmac 02_hello_world.asm
; trs80gp -m1 ./zout/02_hello_world.bds
  org $5200

screen	equ	$3c00

text	defb	'Hello, TRS-80 World!'
text_ln	equ	$-text

main:
  ; Prints the text defined above to the screen. We center the text on the
  ; third line.
  ld hl,text  ; source: our text
screen_pos equ screen+64*2+(32-text_ln/2)  ; 3rd line on the screen, centered
  ld de,screen_pos
  ld bc,text_ln ; bytes to move
  ldir

  ; Pause until the machine is rebooted.
loop:
  jr loop

  end main
