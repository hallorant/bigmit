  org $7000
z80unit_m3_TRSDOS1.3 equ 1
import 'z80unit.asm'

import '../bitstream.asm'
import '../huffman.asm'

; The alphabet in Huffman priority order.
; (start bit) S  E  A     R   T     I   O     L   Y      N
alphabet byte 11001110b,11100110b,00010000b,11000111b,11111110b
; (start bit) D    U      C    H      M      P    K      G
         byte 11101101b,00010110b,10100010b,10010000b,00100000b
; (start bit)  B    F       W        V        Z        X
         byte 11100010b,10101110b,01111100b,10101011b,01010111b
; (start bit)  J          Q
         byte 11010111b,01101011b,10000000b

; A word: JUMP
; (start bit) J          U    M      P
jump     byte 10101110b,11010000b,10100100b

result byte 0

main:
  z80unit_test 'decode alphabet'
  bs_reset alphabet

  call huffman_decode_char
  ld (result),a
  assertMemString result,'S'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'E'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'A'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'R'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'T'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'I'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'O'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'L'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'Y'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'N'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'D'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'U'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'C'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'H'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'M'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'P'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'K'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'G'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'B'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'F'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'W'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'V'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'Z'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'X'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'J'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'Q'

  z80unit_test 'decode word'
  bs_reset jump

  call huffman_decode_char
  ld (result),a
  assertMemString result,'J'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'U'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'M'

  call huffman_decode_char
  ld (result),a
  assertMemString result,'P'

  z80unit_end_and_exit
  end main
