  org $7000
z80unit_m3_TRSDOS1.3 equ 1
import 'z80unit.asm'

import '../dictionary.asm'

buffer defs 5

answer1 defb 'TANDY'
answer2 defb 'RADIO'
answer3 defb 'SHACK'
answer4 defb 'CIGAR'
answer5 defb 'FICUS'
answer6 defb 'DWARF'

badword1 defb '-----'
badword2 defb 'FFFFF'
badword3 defb '     '

main:
  z80unit_test 'helper check_equals'

  ld ix,answer1
  ld iy,answer1
  call equals_check
  assertEquals8 1,a ; true

  ld ix,answer1
  ld iy,answer2
  call equals_check
  assertEquals8 0,a ; false

  z80unit_test 'helper decode_answer_word'

  bitstream_reset answer_data
  ld ix,buffer
  call decode_answer_word
  ld ix,buffer
  ld iy,answer1
  call equals_check
  assertEquals8 1,a ; true should be 'TANDY'

  ld ix,buffer
  call decode_answer_word
  ld ix,buffer
  ld iy,answer2
  call equals_check
  assertEquals8 1,a ; true should be 'RADIO'

  ld ix,buffer
  call decode_answer_word
  ld ix,buffer
  ld iy,answer3
  call equals_check
  assertEquals8 1,a ; true should be 'SHACK'

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

  z80unit_test 'isword from answers'

  ld hl,answer1
  call isword
  assertEquals8 1,a ; true

  ld hl,answer2
  call isword
  assertEquals8 1,a ; true

  ld hl,answer3
  call isword
  assertEquals8 1,a ; true

  ld hl,answer4
  call isword
  assertEquals8 1,a ; true

  ld hl,answer5
  call isword
  assertEquals8 1,a ; true

  ld hl,answer6
  call isword
  assertEquals8 1,a ; true

  z80unit_test 'isword not a word'

  ld hl,badword1
  call isword
  assertEquals8 0,a ; false

  ld hl,badword2
  call isword
  assertEquals8 0,a ; false

  ld hl,badword3
  call isword
  assertEquals8 0,a ; false

  z80unit_end_and_exit
  end main
