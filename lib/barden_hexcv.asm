ifndef INCLUDE_BARDEN_HEXCV
INCLUDE_BARDEN_HEXCV equ 1

; _                   _              _
;| |                 | |            | |
;| |__   __ _ _ __ __| | ___ _ __   | |__   _____  _______   __
;| '_ \ / _` | '__/ _` |/ _ \ '_ \  | '_ \ / _ \ \/ / __\ \ / /
;| |_) | (_| | | | (_| |  __/ | | | | | | |  __/>  < (__ \ V /
;|_.__/ \__,_|_|  \__,_|\___|_| |_| |_| |_|\___/_/\_\___| \_/
;                               ______
;                              |______|
;
; Author: William Barden, Jr.
;         'TRS-80 Assembly-Language Programming', 1979 pg 198.
;
; Subroutine to covert 1 byte into a hex value in ASCII. This has been
; modified from the book so that simply drawing hl into video memory
; results in the bytes being in the correct order (which is what most uses
; actually want).
;
; Uses:  a,c,hl
;
; Entry: a   byte to be converted
; Exit:  hl  hex value in ASCII for a: h is low 4-bits and l is high 4-bits.
barden_hexcv:
  ld c,a     ; Save two hex digits
  srl a      ; Align high digit
  srl a
  srl a
  srl a
  call _cvt  ; Convert to ASCII
  ld l,a     ; Save for return
  ld a,c     ; Restore original
  and $0f    ; Get low digit
  call _cvt  ; Convert to ASCII
  ld h,a     ; Save for return
  ret
_cvt:
  add a,$30  ; Conversion factor
  cp $3a
  jr c,_cvt_is_done
  add a,7
_cvt_is_done:
  ret

endif ; INCLUDE_BARDEN_HEXCV
