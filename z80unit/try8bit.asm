  org $7000
import 'z80unit.asm'

_zero	defb	0
_ten	defb	10

; Trys out 8-bit z80unit assertions.
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
  assertZero8 (ix),'expected'
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
  assertEquals8 a,(ix),'expected'
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
  assertNotEquals8 a,(ix),'expected'
  assertNotEquals8 a,(ix)

  z80unit_test 'Passing assertGreaterThan8'
  assertGreaterThan8 $45,6
  ld a,11
  ld ix,_ten
  assertGreaterThan8 a,(ix)

  z80unit_test 'Failing assertGreaterThan8'
  ld a,1
  ld ix,_ten
  assertGreaterThan8 a,(ix),'expected'
  assertGreaterThan8 a,(ix)

  z80unit_test 'Passing assertGreaterThanOrEquals8'
  assertGreaterThanOrEquals8 $45,6
  assertGreaterThanOrEquals8 $45,$45
  ld a,11
  ld ix,_ten
  assertGreaterThanOrEquals8 a,(ix)
  ld a,10
  assertGreaterThanOrEquals8 a,(ix)

  z80unit_test 'Failing assertGreaterThanOrEquals8'
  ld a,1
  ld ix,_ten
  assertGreaterThanOrEquals8 a,(ix),'expected'
  ld a,1
  assertGreaterThanOrEquals8 a,(ix)

  z80unit_test 'Passing assertLessThan8'
  assertLessThan8 6,$45
  ld a,8
  ld ix,_ten
  assertLessThan8 a,(ix)

  z80unit_test 'Failing assertLessThan8'
  ld a,100
  ld ix,_ten
  assertLessThan8 a,(ix),'expected'
  assertLessThan8 a,(ix)

  z80unit_test 'Passing assertLessThanOrEquals8'
  assertLessThanOrEquals8 6,$45
  ld a,8
  ld ix,_ten
  assertLessThanOrEquals8 a,(ix)
  ld a,10
  assertLessThanOrEquals8 a,(ix)

  z80unit_test 'Failing assertLessThanOrEquals8'
  ld a,100
  ld ix,_ten
  assertLessThanOrEquals8 a,(ix),'expected'
  assertLessThanOrEquals8 a,(ix)

  z80unit_end_and_exit
  end main
