; ------------------- ;
; TANDY ASSEMBLY 2026 ;
;    Hello Program    ;
; ------------------- ;
      org $3f00
;
; Clear the CoCo screen
;
START lda #SPACE
      ldx #$400
CLS   sta ,X+
      cmpx #$600
      bne CLS
;
; Write to the screen at the
; start of the 7th line
;
       ldx #$400+32*6
       ldy #MSG
PRTMSG lda ,Y+
       beq DONE
       ora #$40
       sta ,X+
       bra PRTMSG
DONE   rts
;
; Definitions and values
;
SPACE equ $60
MSG   fcc "HELLO TA'26"
      fcb 0
      end START
