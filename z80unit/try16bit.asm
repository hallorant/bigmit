  org $3000
import 'z80unit.asm'

_zero	defw	0
_ten	defw	10

; Trys out 16-bit z80unit assertions.
main:
  z80unit_test 'Passing assertZero16'
  assertZero16 0
  assertZero16 (_zero)

  z80unit_test 'Failing assertZero16'
  assertZero16 $ffff,'expected'
  assertZero16 $ffff

  z80unit_end

  ; Return to TRSDOS prompt.
  ld hl,0  ; Normal termination
  ld a,22  ; @EXIT
  rst 40
  end main
