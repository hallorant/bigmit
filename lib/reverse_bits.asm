;                                    _     _ _       
;                                   | |   (_) |      
; _ __ _____   _____ _ __ ___  ___  | |__  _| |_ ___ 
;| '__/ _ \ \ / / _ \ '__/ __|/ _ \ | '_ \| | __/ __|
;| | |  __/\ V /  __/ |  \__ \  __/ | |_) | | |_\__ \
;|_|  \___| \_/ \___|_|  |___/\___| |_.__/|_|\__|___/
;                               ______               
;                              |______|
;
; Author: Tim Halloran
;
; Reverses the bits within a byte.
;
; Uses:  a,b,c
;
; Entry: a  a byte
; Exit:  a  a with its bits reversed.
reverse_bits:
  ld c,8
  ld b,a  ; b is now the input value.
  xor a   ; clear for output.
_loop:
  sla a
  srl b	; c >>> 1
  jp nc,_cont
  or a,1
_cont:
  dec c
  ret z
  jr _loop

