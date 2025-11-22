;*******************************************************************************
; Program:      welcome.asm
; Author:       Gemini
; Description:  An 8080 assembly program for CP/M 2.2 that prints a welcome
;               message to the console.
;
; CP/M programs typically start at address 100h.
; The program uses BDOS (Basic Disk Operating System) calls to perform I/O.
; The BDOS function code is placed in the C register, and the address of data
; is placed in the DE register. The call is made to address 0005h.
;*******************************************************************************

            ORG     100H
BDOS        EQU     5    ; CP/M BDOS entry point
PSTRING     EQU     9    ; BDOS print string
; Main program
            LXI     D,WELCOME
            MVI     C,PSTRING
            CALL    BDOS

            RET
; Data section
WELCOME:    DB      'Welcome to Tandy Assembly 2025',13,10,'$'
            END