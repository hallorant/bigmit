ifndef INCLUDE_SRL16
INCLUDE_SRL16 equ 1

;          _  __    ____
;         | |/  |  / ___|
; ___ _ __| |`| | / /___ 
;/ __| '__| | | | | ___ \
;\__ \ |  | |_| |_| \_/ |
;|___/_|  |_|\___/\_____/
;                        
; Author: Tim Halloran
;
; Shift-right for a 16-bit value.
;
; Uses: a,hl,d
;
; Entry: hl  16-bit value
;	  a  shift count
; Exit:  hl  result of hl shifted right by c bits
srl16:
  ld d,a
  or a
_loop:
  ret z
  srl l
  srl h
  jr nc,_cont
  ld a,$80
  or a,l
  ld l,a
_cont:
  dec d
  jr _loop

endif ; INCLUDE_SRL16
