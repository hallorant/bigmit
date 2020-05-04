ifndef INCLUDE_FAST_MOVE
INCLUDE_FAST_MOVE equ 1

import 'gp_14byte_move'

;  __          _                              
; / _|        | |                             
;| |_ __ _ ___| |_   _ __ ___   _____   _____ 
;|  _/ _` / __| __| | '_ ` _ \ / _ \ \ / / _ \
;| || (_| \__ \ |_  | | | | | | (_) \ V /  __/
;|_| \__,_|___/\__| |_| |_| |_|\___/ \_/ \___|
;               ______                        
;              |______|
;
; Author: Tim Halloran
;         'TRS-80 Assembly-Language Programming', 1979 pg 190.
;
; Moves one block of memory to another area in memory.
; The blocks may be overlapping. The move is either done
; forwards or backwards depending upon overlap (if any).
;
; Uses:  a,bc,de,hl,(the stack)
;
; Entry: hl  addr source start
;        de  addr destination start
;        bc  # of bytes to move
barden_move:
  push hl
  or a       ; Clear carry
  sbc hl,de  ; Carry set if dest before start
  pop hl     ; Restore source start
  jr c,_backwards_move
  ldir
  ret
_backwards_move:
  ; Setup for backwards move by setting addrs to source and dest end.
  add hl,bc
  dec hl
  ex de,hl
  add hl,bc
  dec hl
  ex de,hl
  lddr
  ret

endif ; INCLUDE_FAST_MOVE
