H6309   set 0
OS9.D   set 0
Level   set 2
        include os9.d
        MOD     Length,Name,Prgrm+Objct,ReEnt+1,CodeStart,DataEnd
Name:
        fcs     "hios9"
Stack   rmb     $100
DataEnd equ     .
Welcome:
        fcc "!! Welcome to Tandy Assembly 2026 !!"
        fcb $0D ; OS-9 newline
Enjoy:
        FCC "Enjoy your weekend from NitrOS-9 EOU"
        fcb $0D ; OS-9 newline
CodeStart:
        LDA     #1       ; To terminal (stdout)
        LEAX    Welcome,PCR
        LDY     #80      ; Safe maximum line limit
        OS9     I$WritLn ; Stops on $0D and drops line cleanly
        LEAX    Enjoy,PCR
        LDY     #80
        OS9     I$WritLn
        CLRB             ; No error
        OS9     F$Exit
        EMOD
Length  EQU     *
