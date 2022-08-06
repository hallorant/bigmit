  org $7000
z80unit_m3_TRSDOS1.3 equ 1
import 'z80unit.asm'

import '../bitstream.asm'

test_data  byte 10111011b,00010001b,11111111b,00001000b,10100110b,00000000b

; (count start) v  v  v    v  v  u
test_count byte 00000101b,11011110b

main:
  z80unit_test 'bitstream basic advances'

  bitstream_reset test_data
  call bitstream_get
  assertEquals8 10111011b,a

  ld a,1
  call bitstream_advance
  call bitstream_get
  assertEquals8 01110110b,a

  ld a,1
  call bitstream_advance
  call bitstream_get
  assertEquals8 11101100b,a

  ld a,6
  call bitstream_advance
  call bitstream_get
  assertEquals8 00010001b,a

  ld a,4
  call bitstream_advance
  call bitstream_get
  assertEquals8 00011111b,a

  ld a,9
  call bitstream_advance
  call bitstream_get
  assertEquals8 11100001b,a

  z80unit_test 'bitstream advance multiple bytes'
  bitstream_reset test_data
  ld a,31
  call bitstream_advance
  call bitstream_get
  assertEquals8 01010011b,a

  bitstream_reset test_data
  ld a,32
  call bitstream_advance
  call bitstream_get
  assertEquals8 10100110b,a

  bitstream_reset test_data
  ld a,33
  call bitstream_advance
  call bitstream_get
  assertEquals8 01001100b,a

  z80unit_test 'bitstream 3-bit counts'

  bitstream_reset test_count
  call bitstream_get_3bit_count
  assertEquals8 0,a
  call bitstream_get_3bit_count
  assertEquals8 1,a
  call bitstream_get_3bit_count
  assertEquals8 3,a
  call bitstream_get_3bit_count
  assertEquals8 5,a
  call bitstream_get_3bit_count
  assertEquals8 7,a

  z80unit_end_and_exit
  end main
