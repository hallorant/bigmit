;
; 01_hello_world.asm -- Using Z80 ldir
;
; zmac --zmac 01_hello_world.asm
; trs80gp -m1 zout/01_hello_world.bds
  org $5200

text	defb	'Hello, TRS-80 World!'

main:
  ; Prints the text defined above to the screen. We add no offset, so the text
  ; will appear in the upper-left of the screen.
  ld hl,text   ; source: our text
  ld de,$3c00  ; destination: the screen
  ld bc,20     ; bytes to move
  ldir

  ; Pause until the machine is rebooted.
loop:
  jr loop

  end main
