  org $5200
import '../../z80unit/z80unit.asm'
import 'step_dist.asm'

main:
  ; -----------------------------------------------------------
  z80unit_test 'step_x table compass lookups'

  ld e,0
  call step_x
  assertEquals8 255,c ; distance
  assertEquals8 255,b ; y-distance

  ld e,32
  call step_x
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,64
  call step_x
  assertEquals8 255,c ; distance
  assertEquals8 255,b ; y-distance

  ld e,96
  call step_x
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ; -----------------------------------------------------------
  z80unit_test 'step_x table near compass lookups'

  ld e,1
  call step_x
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,31
  call step_x
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,33
  call step_x
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,63
  call step_x
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,65
  call step_x
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,95
  call step_x
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,97
  call step_x
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,127
  call step_x
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ; -----------------------------------------------------------
  z80unit_test 'step_y table compass lookups'

  ld e,0
  call step_y
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,32
  call step_y
  assertEquals8 255,c ; distance
  assertEquals8 255,b ; y-distance

  ld e,64
  call step_y
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,96
  call step_y
  assertEquals8 255,c ; distance
  assertEquals8 255,b ; y-distance

  ; -----------------------------------------------------------
  z80unit_test 'step_y table near compass lookups'

  ld e,1
  call step_y
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,31
  call step_y
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,33
  call step_y
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,63
  call step_y
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,65
  call step_y
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  ld e,95
  call step_y
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,97
  assertEquals8 163,c ; distance
  assertEquals8 163,b ; y-distance

  ld e,127
  call step_y
  assertEquals8 8,c ; distance
  assertEquals8 0,b ; y-distance

  z80unit_end_and_exit
  end main
