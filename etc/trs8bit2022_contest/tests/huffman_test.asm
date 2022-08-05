  org $7000
z80unit_m3_TRSDOS1.3 equ 1
import 'z80unit.asm'

import '../bitstream.asm'
import '../huffman.asm'

; -----------------------------
; -- Wordle Huffman encoding --
; -----------------------------
;    s       110
;    e       011
;    a       1011
;    r       1001
;    t       1000
;    i       0100
;    o       0011
;    l       0001
;    y       11111
;    n       11110
;    d       11101
;    u       10100
;    c       01011
;    h       01010
;    m       00101
;    p       00100
;    k       00001
;    g       00000
;    b       111000
;    f       101010
;    w       1110011
;    v       1110010
;    z       1010110
;    x       10101111
;    j       101011101
;    q       101011100

; (start bit) S  E  A     R   T     I   O     L   Y      N
alphabet byte 11001110b,11100110b,00010000b,11000111b,11111110b
; (start bit) D    U      C    H      M      P    K      G
         byte 11101101b,00010110b,10100010b,10010000b,00100000b
; (start bit)  B    F       W        V        Z        X
         byte 11100010b,10101110b,01111100b,10101011b,01010111b
; (start bit)  J          Q
         byte 11010111b,01101011b,10000000b

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

  z80unit_end_and_exit
  end main
