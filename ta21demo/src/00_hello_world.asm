;
; 00_hello_world.asm -- One byte at a time
;
; zmac --zmac 00_hello_world.asm
; trs80gp -m1 zout/00_hello_world.bds
  org $5200

text	defb	'Hello, TRS-80 World!'

main:
  ; Prints the text defined above to the screen. We add no offset, so the text
  ; will appear in the upper-left of the screen.
  ld a,'H'
  ld ($3c00),a
  ld a,'e'
  ld ($3c01),a
  ld a,'l'
  ld ($3c02),a
  ld a,'l'
  ld ($3c03),a
  ld a,'o'
  ld ($3c04),a

  ; Pause until the machine is rebooted.
loop:
  jr loop

  end main
