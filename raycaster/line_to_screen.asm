;  _      _              _______    
; | |    (_)            |__   __|   
; | |     _ _ __   ___     | | ___  
; | |    | | '_ \ / _ \    | |/ _ \ 
; | |____| | | | |  __/    | | (_) |
; |______|_|_| |_|\___|    |_|\___/ 
;  / ____|                          
; | (___   ___ _ __ ___  ___ _ __   
;  \___ \ / __| '__/ _ \/ _ \ '_ \  
;  ____) | (__| | |  __/  __/ | | | 
; |_____/ \___|_|  \___|\___|_| |_|
;
; Author: Tim Halloran (with lots of help from George Phillips)
; From the tutorial at https://lodev.org/cgtutor/raycasting.html

import '../lib/phillips_14byte_move.asm'

; Fast move of 56-byte src to dst  using George Phillip's fast 16 byte move.
; This is what allows our back buffer to exist. We are using this code to
; move the back buffer to the screen.
line_to_screen	macro	src, dst
		phillips_14byte_move src, dst
		phillips_14byte_move src+14, dst+14
		phillips_14byte_move src+28, dst+28
		phillips_14byte_move src+42, dst+42
		endm

