; Zero Page IX Macros
;
; Programmer convenience isn't nearly as compelling as small and fast programs
; but it is important. There's a lot of code to write where speed and size are
; minor concerns but it is complicated enough that juggling registers becomes
; difficult.  These macros allow you to set up 256 byte region in memory of very
; convenient 8 bit variables. You can pull the variables into any register and
; even use them as loop counters.
;
; Example use
;
; step  defb 1
; varbase:
; count defb 0
; pos   defb 0
;   ld ix,varbase
;   ...
;   ldv A,count
;   ADD a,5
;   addv step
;   stv a,count
; lp: ...
;   decv count
;   jr nz,lp
;   ld hl,count
;   ded (hl)

ldv macro reg,var
  ld reg,(ix+var-varbase)
  endm

stv macro reg,var
  ld (ix+var-varbase),reg
  endm

 decv macro var
   dec (ix+var-varbase)
   endm

 addv macro var
   add a,(ix+var-varbase)
   endm

