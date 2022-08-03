  org $7000
z80unit_m3_TRSDOS1.3 equ 1
import 'z80unit.asm'

import '../bitstream.asm'

test_data byte 10111011b,00010001b,11111111b,00001000b,10100110b,00000000b

main:
  z80unit_test 'bitstream basic advances'

  bs_reset test_data
  call bs_get
  assertEquals8 10111011b,a

  ld a,1
  call bs_advance
  call bs_get
  assertEquals8 01110110b,a

  ld a,1
  call bs_advance
  call bs_get
  assertEquals8 11101100b,a

  ld a,6
  call bs_advance
  call bs_get
  assertEquals8 00010001b,a

  ld a,4
  call bs_advance
  call bs_get
  assertEquals8 00011111b,a

  ld a,9
  call bs_advance
  call bs_get
  assertEquals8 11100001b,a

  z80unit_test 'bitstream advance multiple bytes'
  bs_reset test_data
  ld a,31
  call bs_advance
  call bs_get
  assertEquals8 01010011b,a

  bs_reset test_data
  ld a,32
  call bs_advance
  call bs_get
  assertEquals8 10100110b,a

  bs_reset test_data
  ld a,33
  call bs_advance
  call bs_get
  assertEquals8 01001100b,a

  z80unit_end_and_exit
  end main
