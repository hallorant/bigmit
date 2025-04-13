# CP/M 2.2 Source Code for the TRS-80 Model 1

# BDOS and CCP

I started with `bdos.asm` and `ccp.asm` from the [CP/M 2.2 Github
repository](https://github.com/brouhaha/cpm22/).  Eric Smith and Tom Everett
took the original source code and worked to make it assemble with a wider set
of assemblers than the ASM80 assembler by Digital Research. ASM80 used some odd
conventions, such as `!` separating multiple instructions on the same line.
Eric and Tom worked to ensure the binary matched actual CP/M 2.2 disks.  They
also noted "It is likely that with only minor changes, the source code could be
assembled using other assemblers (native or cross)." I found this to be true.

I used [zmac](http://48k.ca/zmac.html) to assemble BDOS and CCP. The zmac I
used is enhanced and maintained by George Phillips for the TRS-80. George is
focused on the z80, however, zmac supports the 8080 instruction format. Only a
one line change to each file was required to assemble `bdos.asm` and `ccp.asm`.

```
   .cpu   8080
```

was changed to

```
   .8080
```

The change is the assembler pseudo-op to accept 8080 mnemonics preferentially
(as opposed to z80 mnemonics).

To keep a record of where I started the files `bdos.asm_orig` and
`ccp.asm_orig` are the original copies from the [CP/M 2.2 Github
repository](https://github.com/brouhaha/cpm22/). This allows diffs of the
changes I made for the TRS-80 Model 1 and also diffs from the  [CP/M 2.2 Github
repository](https://github.com/brouhaha/cpm22/) should it be updated.

# BIOS

I developed the BIOS for the TRS-80 Model 1 based on the outline given by Andy
Johnson-Laird in *The Programmer's CP/M Handbook* (Osborne McGraw-Hill, 1983).

# License information

Please see
[LICENSE.txt](https://github.com/brouhaha/cpm22/blob/main/LICENSE.txt) at the
CP/M 2.2 Github repository. This license covers `bdos.asm` and `ccp.asm`.

Any other code is z80 code I wrote for the Model 1 TRS-80 and you may freely
modify it or copy it as you see fit.
