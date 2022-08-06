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
bitstream_byte_ptr word 0
; The bit position within the current byte [0,8).
bitstream_bit_pos  byte 0

; Reset this bitstream to read from to_address at bit 0.
; Uses: A,HL
bitstream_reset macro ?to_address
  ld hl,?to_address
  ld (bitstream_byte_ptr),hl
  ld a,0
  ld (bitstream_bit_pos),a
  endm

; Returns bits at the current position, msb to lsb, in A.
; The bitstream is not advanced.
; Uses: A,BC,HL
bitstream_get:
  ld hl,(bitstream_byte_ptr)
  ld b,(hl)
  inc hl
  ld c,(hl)
  ld h,b
  ld l,c
  ld a,(bitstream_bit_pos)
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

; Returns a 3-bit count in A from the bitstream.
; The bitstream is advanced 3 bits.
; Uses: A,BC,HL
bitstream_get_3bit_count:
  call bitstream_get
  srl a ; Shift the MSB 3 bits to LSB in the byte
  srl a
  srl a
  srl a
  srl a
  ld c,a
  ld a,3
  call bitstream_advance ; 3 bits
  ld a,c
  ret

; Advances this bitstream by A bits.
; Uses: A,B,HL
bitstream_advance:
  ld hl,(bitstream_byte_ptr)
  ; Advance bitstream position by A bits.
  ld b,a
  ld a,(bitstream_bit_pos)
  add a,b
_advance_byte_ptr_if_needed:
  ; If A in [0,8) goto _done (to return).
  ld b,a
  and 00000111b
  cmp b
  jr z,_done_advance
  ; If A >= 8 subtract 8 bits and advance bitstream_byte_ptr.
  ld a,b ; restore A to its value before range check
  sub a,8
  inc hl
  jr _advance_byte_ptr_if_needed
_done_advance:
  ld (bitstream_byte_ptr),hl
  ld (bitstream_bit_pos),a
  ret

endif ; INCLUDE_BITSTREAM
