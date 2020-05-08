  org $7000
import 'z80unit.asm'

_zero	defw	0
_ten	defw	10

; Trys out 16-bit z80unit assertions.
main:
  z80unit_test 'assertZero16'
  assertZero16 0
  assertZero16 (_zero)

  z80unit_test 'assertZero16'
  assertZero16 $ffff,'expected'

  z80unit_end_and_exit
  end main
