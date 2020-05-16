ifndef INCLUDE_BARDEN_FILL
INCLUDE_BARDEN_FILL equ 1

; _                   _               __ _ _ _
;| |                 | |             / _(_) | |
;| |__   __ _ _ __ __| | ___ _ __   | |_ _| | |
;| '_ \ / _` | '__/ _` |/ _ \ '_ \  |  _| | | |
;| |_) | (_| | | | (_| |  __/ | | | | | | | | |
;|_.__/ \__,_|_|  \__,_|\___|_| |_| |_| |_|_|_|
;                               ______
;                              |______|
;
; Author: William Barden, Jr.
;         'TRS-80 Assembly-Language Programming', 1979 pg 189.
;
; Fills a block of memory with a given 8-bit value.
;
; Uses:  a,bc,d,hl
;
; Entry: d   data to be filled
;        hl  start addr of the fill area
;        bc  # of bytes to fill
barden_fill:
  ld (hl),d  ; Actually do fill
  inc hl     ; To next addr
  dec bc     ; Count down byte count
  ld a,b     ; Get MSB of count
  or c       ; Merge in LSB of count -- will be 0 iff both bytes were 0
  jr nz,barden_fill
  ret

endif ; INCLUDE_BARDEN_FILL
