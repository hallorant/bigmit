# FMG Corporation CP/M version 1.5 for the Model 1

This is a remapped version of CP/M that runs on a stock Model 1 with disks.
The disk images are setup for a TRS-80 Model 1 with a Gotek or with
[trs80gp](http://48k.ca/trs80gp.html).

##
	trs80gp -m1 -d0 m1_fmg_cpm.hfe

## Keyboard remapping

* FMG CP/M uses Shift-↓ for the Ctrl key. So to press Ctrl-Z you would
  hold down the Shift and ↓ keys and then press Z. This is much easier to do on
  a real Model 1 keyboard than an emulator using a modern keyboard.
* PIP uses <> instead of [].

## Serial support

FMG appears to support the RS-232-C serial board. I noted this in the Ad in 80
Micro, so I experimented. FMG is set to 9600 baud 8 bits; 2 stop bits; no
parity on boot. I'm unaware how to change this. There is a ```RSINIT``` program
but I've no idea what it does.

To map the printer or LST device to the serial use

##
	STAT LST:=CRT:

To map the console (to type and see on a terminal use

##
	STAT CON:=CRT:

To put the console back from the terminal use
##
	STAT CON:=TTY:

This is all via experiment, I am unaware of documentation on the CP/M version.

## Files

| File | Description |
|------|-------------|
| FMG_ad.png | Ad from 80 Microcomputing Apr 1980 for FMG CP/M. |
| m1_fmg_cpm.hfe | CP/M version 1.5 |
