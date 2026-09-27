; ------------------- ;
; TANDY ASSEMBLY 2026 ;
; Hello BASIC Program ;
; ------------------- ;
      org $3f00
;
; Write to the screen at the
; current position using CHROUT
; ROM routine.
; - Set $6f to 0 for screen (DEVNO)
; - Set character in A register
; - Indirect call to $a002 to print
;
START  clra
       sta $6f     ; Set DEVNO to 0 (screen)
       ldy #MSG
PRTMSG lda ,Y+     ; Set character to print
       beq DONE
       pshs Y .    ; (Save Y we need it!)
       jsr [$a002] ; CHROUT
       puls Y
       bra PRTMSG
DONE   rts         ; Back to BASIC
;
; Definitions and values
;
MSG   fcc "Hello Tandy Assembly 2026"
      fcb 0
      end START
