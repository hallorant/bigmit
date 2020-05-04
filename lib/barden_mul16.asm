ifndef INCLUDE_BARDEN_MUL16
INCLUDE_BARDEN_MUL16 equ 1

; _                   _                              _  __    ____
;| |                 | |                            | |/  |  / ___|
;| |__   __ _ _ __ __| | ___ _ __    _ __ ___  _   _| |`| | / /___
;| '_ \ / _` | '__/ _` |/ _ \ '_ \  | '_ ` _ \| | | | | | | | ___ \
;| |_) | (_| | | | (_| |  __/ | | | | | | | | | |_| | |_| |_| \_/ |
;|_.__/ \__,_|_|  \__,_|\___|_| |_| |_| |_| |_|\__,_|_|\___/\_____/
;                               ______
;                              |______|
;
; Author: William Barden, Jr.
;         'TRS-80 Assembly-Language Programming', 1979 pg 196.
;
; Multiplies a 16-bit number by an 8-bit number.
;
; Uses:  hl,b,de
;
; Entry: de  16-bit multiplicand, unsigned
;         b  8-bit multiplier, unsigned
; Exit:  hl  product
barden_mul16:
  ld hl,0      ; Clear initial product
_loop:
  srl b        ; Shift out multiplier bit
  jr nc,_cont  ; go if no carry (1 bit)
  add hl,de    ; Add multiplicand
_cont:
  ret z        ; Go if multiplicand
  ex de,hl     ; Multiplicand to hl
  add hl,hl    ; Shift Multiplicand
  ex de,hl     ; Swap back
  jr _loop

endif ; INCLUDE_BARDEN_MUL16
