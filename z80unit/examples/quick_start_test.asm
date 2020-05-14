  org $7000
import '../z80unit.asm'

s1	defb	'a test'
s2	defb	'a test'

main:
  z80unit_test 'reg adds'
  ld a,5
  add 5
  assertEquals8 10,a
  ld hl,900
  inc hl
  assertEquals16 hl,901

  z80unit_test 'memory blocks'
  assertMemString s1,'a test'
  assertMemString s1+2,'test'
  assertMemEquals8 s1,s2,3,'3 chars only'
  assertMemEquals8 s1,s2,6

  z80unit_end_and_exit
  end main
