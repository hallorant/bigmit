; Moves 14 bytes from src to dst at 12.5 cycles/byte.
; The fastest code known for copying memory from a specific location
; to another is this macro.
; src = source addr of copy
; dst = destination addr of copy
;
; Author: George Phillips
phillips_14byte_move	macro src, dst
			ld sp,src     ; 10
			pop af        ; 10
			pop bc        ; 10
			pop de        ; 10
			pop hl        ; 10
			exx           ; 4
			pop bc        ; 10
			pop de        ; 10
			pop hl        ; 10
			ld sp,dst+14  ; 10
			push hl       ; 11
			push de       ; 11
			push bc       ; 11
			exx           ; 4
			push hl       ; 11
			push de       ; 11
			push bc       ; 11
			push af       ; 11
			endm
