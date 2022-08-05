  org $7000
z80unit_m3_TRSDOS1.3 equ 1
import 'z80unit.asm'

import '../dictionary.asm'

buffer defs 5

main:
  z80unit_test 'getpuz first answers'

  ld de,1
  ld hl,buffer
  call getpuz
  assertMemString buffer,'TANDY'

  ld de,2
  ld hl,buffer
  call getpuz
  assertMemString buffer,'RADIO'

  ld de,3
  ld hl,buffer
  call getpuz
  assertMemString buffer,'SHACK'

  z80unit_test 'getpuz last answers'

  ld de,2311
  ld hl,buffer
  call getpuz
  assertMemString buffer,'AVERT'

  ld de,2312
  ld hl,buffer
  call getpuz
  assertMemString buffer,'FICUS'

  ld de,2313
  ld hl,buffer
  call getpuz
  assertMemString buffer,'DWARF'

  z80unit_test 'getpuz middle answers'

  ld de,296
  ld hl,buffer
  call getpuz
  assertMemString buffer,'EAGLE'

  ld de,959
  ld hl,buffer
  call getpuz
  assertMemString buffer,'SPARK'

  ld de,1874
  ld hl,buffer
  call getpuz
  assertMemString buffer,'RUMOR'

  z80unit_end_and_exit
  end main
