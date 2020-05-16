ifndef INCLUDE_GP_GET_TRS80_MODEL
INCLUDE_GP_GET_TRS80_MODEL equ 1

;                          _    _             _____ _____
;                         | |  | |           |  _  |  _  |
;  __ _ _ __     __ _  ___| |_ | |_ _ __ ___  \ V /| |/' |
; / _` | '_ \   / _` |/ _ \ __|| __| '__/ __| / _ \|  /| |
;| (_| | |_) | | (_| |  __/ |_ | |_| |  \__ \| |_| \ |_/ /
; \__, | .__/   \__, |\___|\__| \__|_|  |___/\_____/\___/
;  __/ | |______ __/ |      ______
; |___/|_|______|___/      |______|
;                          _      _
;                         | |    | |
;      _ __ ___   ___   __| | ___| |
;     | '_ ` _ \ / _ \ / _` |/ _ \ |
;     | | | | | | (_) | (_| |  __/ |
;     |_| |_| |_|\___/ \__,_|\___|_|
; ______
;|______|
;
; Author: George Phillips (gp)
;
; Determines the TRS-80 model number this program is running on.
;
; Uses: a,b,c,
;
; Exit: a  1 = Model 1 (Level 1 or 2)
;          3 = Model 3
;          4 = Model 4 (4ga or 4p)
gp_get_trs80_model:
  in a,($00ff)  ; read OUTMOD latches
  ld b,a        ; save original settings
  ld c,$60
  xor c         ; invert CPU Fast, DISWAIT
  out ($00ec),a ; set latches
  in a,($00ff)  ; read latches
  xor c         ; flip to original value
  xor b         ; compare against original
  ld c,$ec
  out (c),b     ; restore original settings
  rlca
  rlca
  jr nc,_is_m4  ; CPU Fast unchanged, must be Model 4
  rlca
  ld a,3
  ret nc        ; DISWAIT same, Model III
  ld a,1        ; otherwise, it's a Model I
  ret
_is_m4:
  ld a,4
  ret

endif ; INCLUDE_GP_GET_TRS80_MODEL
