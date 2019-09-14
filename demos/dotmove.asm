		org 0x4a00
start:		ld hl,0x3c00+32	; Screen start pos
		ld de,64	; Increment (one line)
		ld a,16		; Number of lines
		ld bc,0		; Delay count
loop1:		ld (hl),0xbf	; Block graphical char
loop2:		dec b
		jr nz,loop2
		dec c
		jr nz,loop2
		ld (hl),0x80	; Blank graphical char
		add hl,de	; To next line
		dec a		; #lines - 1
		jr nz,loop1
		jr start
		end start
