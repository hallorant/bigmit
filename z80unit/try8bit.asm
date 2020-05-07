  org $3000

; Trys out 8-bit z80unit assertions.

import 'z80unit.asm'

_zero	defb	0
_ten	defb	10

; Try out z80unit stuff.
main:
  z80unit_test 'Passing assertZero8'
  assertZero8 0
  assertZero8 (_zero)
  ld ix,_zero
  assertZero8 (ix)
  ld a,0
  assertZero8 a

  z80unit_test 'Failing assertZero8'
  ld ix,_ten
  assertZero8 (ix)

  z80unit_test 'Passing assertEquals8'
  assertEquals8 5,$5
  ld a,$ff
  assertEquals8 a,$ff
  ld a,10
  ld ix,_ten
  assertEquals8 a,(ix)

  z80unit_test 'Failing assertEquals8'
  ld a,11
  ld ix,_ten
  assertEquals8 a,(ix)

  z80unit_test 'Passing assertNotEquals8'
  assertNotEquals8 4,$5
  ld a,$ef
  assertNotEquals8 a,$ff
  ld a,11
  ld ix,_ten
  assertNotEquals8 a,(ix)

  z80unit_test 'Failing assertNotEquals8'
  ld a,10
  ld ix,_ten
  assertNotEquals8 a,(ix)

  z80unit_end

  ; Return to TRSDOS prompt.
  ld hl,0  ; Normal termination
  ld a,22  ; @EXIT
  rst 40
  end main
