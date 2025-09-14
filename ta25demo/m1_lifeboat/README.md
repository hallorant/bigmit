# Lifeboat CP/M version 1.41 for the Model 1

This is a remapped version of CP/M that runs on a stock Model 1 with disks.
The disk images are setup for a TRS-80 Model 1 with a Gotek or with
[trs80gp](http://48k.ca/trs80gp.html).

##
	trs80gp -m1 -d0 m1_lifeboat_cpm.hfe

## Keyboard remapping

* Lifeboat CP/M uses Shift-↓ for the Ctrl key. So to press Ctrl-Z you would
  hold down the Shift and ↓ keys and then press Z. This is much easier to do on
  a real Model 1 keyboard than an emulator using a modern keyboard.
* PIP uses <> instead of [].

## Format and backup of disks

* To format a floppy you use FORMAT under Lifeboat CP/M.
* To backup a CP/M disk in A: to a new disk in B:
  * Run ```FORMAT``` and select drive B
  * Run ```SYSGEN``` and select A for the source and B for the destination
  * Run ```PIP B:=A:*.*<OV>```

## Model 1 serial support

If you read ```LifeboatCPMv1.41UserNotes.pdf``` you will note that the Model 1
serial support relies on changing the switches on the serial board in the
expansion interface. With original hardware this means to change settings you
need to open up the expansion interace. Mav's reproduction *RS232C Serial board
kit for the Tandy Radio Shack TRS-80 Model I* does not setting switches. I have
this reproduction in my Model 1. I wanted to improve the flexibility of
Lifeboat CP/M for serial use.

I've created the ```R32BAUD``` utility. It will change the baud rate to any of
110, 300, 600, 1200, or 2400 using 8 bits, no parity, and 1 stop bit. The
assembly source is include on ```m1_lifeboat_cpm.hfe``` as well as
[here](./asm/r32baud.asm).

##
	48K TRS-80 CP/M  V 1.41  COPYRIGHT (C) 1979
	LIFEBOAT ASSOCIATES - SMALL SYSTEM SOFTWARE
	A>R32BAUD
	USAGE: R32BAUD 110, 300, 600, 1200, OR 2400
	A>R32BAUD 1200
	R32: DEVICE SET TO 1200 BAUD
	     (8 DATA BITS, 1 STOP BIT, NO PARITY)
	A>_

This utility is designed to be build under CP/M. Just run ```ASM R32BAUD``` to
get an Intel HEX file then ```LOAD R32BAUD``` to get a COM executable.

## Files

| File | Description |
|------|-------------|
| LifeboatCPMv1.41UserNotes.pdf | Notes on use and setup of Lifeboat CP/M. |
| m1_lifeboat_cpm.hfe |
| m1_lifeboat_mbasic_5_11.hfe | Microsoft Basic v 5.11 |
| m1_lifeboat_mbasic_5_22.hfe | Microsoft Basic v 5.22 and ELIZA.BAS |
| m1_lifeboat_tools.hfe | Squeezer and other tools |
| m1_lifeboat_bdsc.hfe | BD Software C compiler and linker |
