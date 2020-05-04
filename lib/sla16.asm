ifndef INCLUDE_SLA16
INCLUDE_SLA16 equ 1

;     _       __    ____ 
;    | |     /  |  / ___|
; ___| | __ _`| | / /___ 
;/ __| |/ _` || | | ___ \
;\__ \ | (_| || |_| \_/ |
;|___/_|\__,_\___/\_____/
;                        
; Author: Tim Halloran
;
; Shift-left of a 16-bit value.
;
; Uses:  a,hl,d
;
; Entry: hl  16-bit value
;	  a  shift count
; Exit:  hl  result of hl shifted left by c bits
sla16:
  ld d,a
  or a
_loop:
  ret z
  sla h
  sla l
  jr nc,_cont
  ld a,1
  add a,h
  ld h,a
_cont:
  dec d
  jr _loop

endif ; INCLUDE_SLA16
