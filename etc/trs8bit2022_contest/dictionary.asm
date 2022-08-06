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

; -----------------------------------------------------------------
; getpuz - put 5 letter answer number DE to memory at HL
;          DE should be in the range [0,2313) to match data.
; -----------------------------------------------------------------
getpuz:
  jr _getpuz_start
getpuz_answer_ptr word 0  ; passed value
getpuz_counter    word 0  ; counts down from passed answer # to 0
_getpuz_start:
  ld (getpuz_answer_ptr),hl
  inc de ; shift up so we can count down to zero to find the desired word.
  ld (getpuz_counter),de
  bitstream_reset answer_data
  ; Decode a 5 letter word and store in result memory.
_decode_all_answer_words:
  ld ix,(getpuz_answer_ptr)
  call decode_answer_word
  ; Decrement the counter.
  ld hl,(getpuz_counter)
  dec hl
  ld (getpuz_counter),hl
  ; Check if hl is now zero (annoying that 16 bit DECs don't set status bits)
  ld a,h
  or l
  cp 0
  jr nz,_decode_all_answer_words
  ret

; -----------------------------------------------------------------
; isword - check if 5 letter answer at HL is a valid word
;          returns A non-zero if word is valid, A = 0 otherwise
; -----------------------------------------------------------------
isword:
  jr _isword_start
isword_answer_ptr word 0 ; passed value
isword_buffer     defs 5 ; scratch word
isword_counter    word 0 ; for answer.txt words
_isword_start:
  ld (isword_answer_ptr),hl
  ld hl,2313 ; word count in answer.txt
  ld (isword_counter),hl
  bitstream_reset answer_data
_search_all_answer_values
  ; loop through all answers [1,2313] using getpuz.
  ld ix,isword_buffer
  call decode_answer_word
  ; Check if the answer word decoded is the passed word.
  ld ix,isword_buffer
  ld iy,(isword_answer_ptr)
  call equals_check
  cp 0
  jr nz,_ret_is_valid
  ; Decrement our counter (going through all the answers).
  ld hl,(isword_counter)
  dec hl
  ld (isword_counter),hl
  ; Check if hl is now zero (annoying that 16 bit DECs don't set status bits)
  ld a,h
  or l
  cp 0
  jr nz,_search_all_answer_values
_ret_is_not_valid:
  ld a,0
  ret
_ret_is_valid:
  ld a,1
  ret

; -- DICTIONARY HELPER FUNCTIONS --

; -----------------------------------------------------------------
; decode_answer_word - decodes 5 letters into buffer pointed to by ix
;                      the bitstream is advanced
; -----------------------------------------------------------------
decode_answer_word:
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
  ret

; -----------------------------------------------------------------
; equals_check - checks if 5 letters pointed to by ix and iy are equal.
;                returns A non-zero if equal, A = 0 otherwise
; -----------------------------------------------------------------
equals_check:
  ld a,(ix)
  cp (iy)
  jr nz,_not_equal
  ld a,(ix+1)
  cp (iy+1)
  jr nz,_not_equal
  ld a,(ix+2)
  cp (iy+2)
  jr nz,_not_equal
  ld a,(ix+3)
  cp (iy+3)
  jr nz,_not_equal
  ld a,(ix+4)
  cp (iy+4)
  jr nz,_not_equal
  ld a,1 ; strings are equal
  ret
_not_equal:
  ld a,0
  ret

; The total size of subroutines and data.
dict_size equ $-dict_start
