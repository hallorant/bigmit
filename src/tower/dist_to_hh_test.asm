  org $5200
import '../../z80unit/z80unit.asm'
import 'dist_to_hh.asm'

main:
  z80unit_test 'angle deflection uses correct table'
  ; In this test we try each deflection angle [0,11) to
  ; ensure the correct lookup table as accessed.
  ld b,0   ; deflection angle
  ld a,200 ; distance to wall
  call dist_to_hh
  assertEquals8 2,c

  z80unit_end_and_exit
  end main
