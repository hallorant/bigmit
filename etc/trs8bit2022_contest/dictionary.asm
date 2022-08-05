;      _ _      _   _
;     | (_)    | | (_)
;   __| |_  ___| |_ _  ___  _ __   __ _ _ __ _   _
;  / _` | |/ __| __| |/ _ \| '_ \ / _` | '__| | | |
; | (_| | | (__| |_| | (_) | | | | (_| | |  | |_| |
;  \__,_|_|\___|\__|_|\___/|_| |_|\__,_|_|   \__, |
;                                             __/ |
;                                            |___/
; Two core subroutines for wrd80:
;
; getpuz - put 5 letter answer number DE to memory at HL
; isword - check if 5 letter answer at HL is a valid word
;	   returns A non-zero if word is valid, A = 0 otherwise
;
; Both routines only need work on valid input.
;
; Original code by George Phillips modified by Tim Halloran.

; Label so we can compute the total size of the subroutines and data.
dict_start:

  include dictionary_data.asm
  include bitstream.asm
  include huffman.asm

assumed_first_letter byte 'A'
counter              word 0
buffer_ptr           word 0

; getpuz - put 5 letter answer number DE to memory at HL

getpuz:
  ld (buffer_ptr),hl
  ld (counter),de
  bitstream_reset answer_data
  ; Decode a 5 letter word and store in result memory.
_decode_answer_word:
  ld ix,(buffer_ptr)
  call huffman_decode_char
  ld (ix),a
  call huffman_decode_char
  ld (ix+1),a
  call huffman_decode_char
  ld (ix+2),a
  call huffman_decode_char
  ld (ix+3),a
  call huffman_decode_char
  ld (ix+4),a
  
  ld hl,(counter)
  dec hl
  ld (counter),hl
  ; Check if hl is now zero (annoying that 16 bit DECs don't set status bits)
  ld a,h
  or l
  cmp 0
  jr nz,_decode_answer_word
  ret

; isword - check if 5 letter answer at HL is a valid word

isword:	ret

; The total size of subroutines and data.
dict_size equ $-dict_start
