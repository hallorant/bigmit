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
add_top2_ldot	macro
		or      $85
		endm
add_top2_rdot	macro
		or      $8a
		endm
add_bot2_ldot	macro
		or      $94
		endm
add_bot2_rdot	macro
		or      $a8
		endm
add_top_ldot	macro
		or      $81
		endm
add_top_rdot	macro
		or      $82
		endm
add_mid_ldot	macro
		or      $84
		endm
add_mid_rdot	macro
		or      $88
		endm
add_bot_ldot	macro
		or      $90
		endm
add_bot_rdot	macro
		or      $a0
		endm
add_topbot_ldot	macro
		or      $91
		endm
add_topbot_rdot	macro
		or      $a2
		endm
; -------------------------------------------
