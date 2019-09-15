; These all set graphics dots on a. The bits are added, i.e., the whole
; register is not replaced.

; -------------------------------------------
; Vertical dots
; There are two vertical postions per column.
; -------------------------------------------
add_all_ldot	macro
		or      $95
		endm
add_all_rdot	macro
		or      $aa
		endm
add_mid_ldot	macro
		or      $84
		endm
add_mid_rdot	macro
		or      $88
		endm
add_top_ldot	macro
		or      $81
		endm
add_top_rdot	macro
		or      $82
		endm
add_bot_ldot	macro
		or      $90
		endm
add_bot_rdot	macro
		or      $a0
		endm
; -------------------------------------------
