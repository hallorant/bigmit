ifndef INCLUDE_BITSTREAM
INCLUDE_BITSTREAM equ 1

;  _     _ _       _
; | |   (_) |     | |
; | |__  _| |_ ___| |_ _ __ ___  __ _ _ __ ___
; | '_ \| | __/ __| __| '__/ _ \/ _` | '_ ` _ \
; | |_) | | |_\__ \ |_| | |  __/ (_| | | | | | |
; |_.__/|_|\__|___/\__|_|  \___|\__,_|_| |_| |_|
;
; Tim Halloran

; The address of the current byte.
bs_byte_ptr word 0
; The bit position within the current byte [0,8).
bs_bit_pos  byte 0

; Reset this bitstream to read from to_address at bit 0.
; Uses: A,HL
bs_reset macro ?to_address
  ld hl,?to_address
  ld (bs_byte_ptr),hl
  ld a,0
  ld (bs_bit_pos),a
  endm

; Returns bits at the current position, msb to lsb, in A.
; Uses: A,BC,HL
bs_get:
  ld hl,(bs_byte_ptr)
  ld b,(hl)
  inc hl
  ld c,(hl)
  ld h,b
  ld l,c
  ld a,(bs_bit_pos)
  ; Setup how many left shifts + 1 (see djnz use) are needed in B.
  inc a
  ld b,a
  jr _testifshiftneeded
_shift16left:
  add hl,hl
_testifshiftneeded:
  djnz _shift16left
  ld a,h
  ret

; Advances this bitsream by A bits.
; Uses: A,B,HL
bs_advance:
  ld hl,(bs_byte_ptr)
  ; Advance bs_bit_pos by A bits.
  ld b,a
  ld a,(bs_bit_pos)
  add a,b
_advance_byte_ptr_if_needed:
  ; If A in [0,8) goto _done (to return).
  ld b,a
  and 00000111b
  cmp b
  jr z,_done_advance
  ; If A >= 8 subtract 8 bits and advance bs_byte_ptr.
  ld a,b ; restore A to its value before range check
  sub a,8
  inc hl
  jr _advance_byte_ptr_if_needed
_done_advance:
  ld (bs_byte_ptr),hl
  ld (bs_bit_pos),a
  ret

endif ; INCLUDE_BITSTREAM
