ifndef INCLUDE_HUFFMAN
INCLUDE_HUFFMAN equ 1

import bitstream.asm

;  _            __  __
; | |          / _|/ _|
; | |__  _   _| |_| |_ _ __ ___   __ _ _ __
; | '_ \| | | |  _|  _| '_ ` _ \ / _` | '_ \
; | | | | |_| | | | | | | | | | | (_| | | | |
; |_| |_|\__,_|_| |_| |_| |_| |_|\__,_|_| |_|
;
; Tim Halloran

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

huffman_bits byte 0

huffman_letter_decode macro ?byte,?next,?advance,?letter
  cmp ?byte
  jr nz,?next
  ld a,?advance
  call bitstream_advance
  ld a,'?letter'
  ret
  endm

; Returns the next encoded character as ASCII in A that is referenced by
; bitstream.asm. Advances the bitstream past the encoded character bits.
huffman_decode_char:
  call bitstream_get
  ld (huffman_bits),a ; save the bits in our buffer: huffman_bits
_decode_S:
  and 11100000b ; 3 bit mask
  huffman_letter_decode 11000000b,_decode_E,3,'S'
_decode_E:
  huffman_letter_decode 01100000b,_decode_A,3,'E'
_decode_A:
  ld a,(huffman_bits)
  and 11110000b ; 4 bit mask
  huffman_letter_decode 10110000b,_decode_R,4,'A'
_decode_R:
  huffman_letter_decode 10010000b,_decode_T,4,'R'
_decode_T:
  huffman_letter_decode 10000000b,_decode_I,4,'T'
_decode_I:
  huffman_letter_decode 01000000b,_decode_O,4,'I'
_decode_O:
  huffman_letter_decode 00110000b,_decode_L,4,'O'
_decode_L:
  huffman_letter_decode 00010000b,_decode_Y,4,'L'
_decode_Y:
  ld a,(huffman_bits)
  and 11111000b ; 5 bit mask
  huffman_letter_decode 11111000b,_decode_N,5,'Y'
_decode_N:
  huffman_letter_decode 11110000b,_decode_D,5,'N'
_decode_D:
  huffman_letter_decode 11101000b,_decode_U,5,'D'
_decode_U:
  huffman_letter_decode 10100000b,_decode_C,5,'U'
_decode_C:
  huffman_letter_decode 01011000b,_decode_H,5,'C'
_decode_H:
  huffman_letter_decode 01010000b,_decode_M,5,'H'
_decode_M:
  huffman_letter_decode 00101000b,_decode_P,5,'M'
_decode_P:
  huffman_letter_decode 00100000b,_decode_K,5,'P'
_decode_K:
  huffman_letter_decode 00001000b,_decode_G,5,'K'
_decode_G:
  huffman_letter_decode 00000000b,_decode_B,5,'G'
_decode_B:
  ld a,(huffman_bits)
  and 11111100b ; 6 bit mask
  huffman_letter_decode 11100000b,_decode_F,6,'B'
_decode_F:
  huffman_letter_decode 10101000b,_decode_W,6,'F'
_decode_W:
  ld a,(huffman_bits)
  and 11111110b ; 7 bit mask
  huffman_letter_decode 11100110b,_decode_V,7,'W'
_decode_V:
  huffman_letter_decode 11100100b,_decode_Z,7,'V'
_decode_Z:
  huffman_letter_decode 10101100b,_decode_X,7,'Z'
_decode_X:
  ld a,(huffman_bits) ; 8 bits (no mask)
  huffman_letter_decode 10101111b,_decode_J,8,'X'
  ; J and Q require 9 bits to be checked.  bitstream_get only returns 8 bits in A,
  ; so we must check A and shift the bitstream to examine the last bit.
_decode_J:
  cmp 10101110b ; prefix of J and Q
  jr nz,_decode_failure
  ld a,8
  call bitstream_advance
  call bitstream_get
  and 10000000b ; just check first bit
  jr z,_decode_Q
  ld a,1
  call bitstream_advance
  ld a,'J'
  ret
_decode_Q
  ld a,1
  call bitstream_advance
  ld a,'Q'
  ret
_decode_failure:
  ld a,'?' ; Unknown encoding, bitstream has not been advanced.
  ret

endif ; INCLUDE_HUFFMAN
