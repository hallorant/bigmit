  org $5200
import '../../z80unit/z80unit.asm'
import 'dist_to_hh.asm'

main:
  ; -----------------------------------------------------------
  z80unit_test 'angle deflection uses correct table'

  ld b,0   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_00,hl
  assertEquals8 0,c

  ld b,1   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_01,hl
  assertEquals8 0,c

  ld b,2   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_02,hl
  assertEquals8 0,c

  ld b,3   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_03,hl
  assertEquals8 0,c

  ld b,4   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_04,hl
  assertEquals8 0,c

  ld b,5   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_05,hl
  assertEquals8 0,c

  ld b,6   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_06,hl
  assertEquals8 0,c

  ld b,7   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_07,hl
  assertEquals8 0,c

  ld b,8   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_08,hl
  assertEquals8 0,c

  ld b,9   ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_09,hl
  assertEquals8 0,c

  ld b,10  ; deflection angle
  ld c,255 ; max distance to wall to return 0 half-height.
  call dist_to_hh
  assertEquals16 hh_for_angle_10,hl
  assertEquals8 0,c

  ; -----------------------------------------------------------
  z80unit_test 'boundary cases on table lookup'

  ld b,0   ; deflection angle
  ld c,0   ; distance to wall
  call dist_to_hh
  assertEquals8 11,c

  ld b,0   ; deflection angle
  ld c,255 ; distance to wall
  call dist_to_hh
  assertEquals8 0,c

  ld b,10  ; deflection angle
  ld c,0   ; distance to wall
  call dist_to_hh
  assertEquals8 11,c

  ld b,10  ; deflection angle
  ld c,255 ; distance to wall
  call dist_to_hh
  assertEquals8 0,c

  ; -----------------------------------------------------------
  z80unit_test 'distance transition from one hh to another'

  ld b,7   ; deflection angle
  ld c,27  ; distance to wall
  call dist_to_hh
  assertEquals8 9,c

  ld b,7   ; deflection angle
  ld c,26  ; distance to wall
  call dist_to_hh
  assertEquals8 9,c

  ld b,7   ; deflection angle
  ld c,25  ; distance to wall
  call dist_to_hh
  assertEquals8 10,c

  z80unit_end_and_exit
  end main
