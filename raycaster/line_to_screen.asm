import '../lib/phillips_14byte_move.asm'

; Fast move of 56-byte src to dst  using George Phillip's fast 16 byte move.
line_to_screen	macro	src, dst
		phillips_14byte_move src, dst
		phillips_14byte_move src+14, dst+14
		phillips_14byte_move src+28, dst+28
		phillips_14byte_move src+42, dst+42
		endm

