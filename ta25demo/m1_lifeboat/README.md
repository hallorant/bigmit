# Lifeboat CP/M version 1.41 for the Model 1

This is a remapped version of CP/M that runs on a stock Model 1 with disks.
The disk images are setup for a TRS-80 Model 1 with a Gotek or with
[trs80gp](http://48k.ca/trs80gp.html).

```trs80gp -m1 -d0 m1_lifeboat_cpm.hfe```

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

## Files

| File | Description |
|------|-------------|
| LifeboatCPMv1.41UserNotes.pdf | Notes on use and setup of Lifeboat CP/M. |
| m1_lifeboat_cpm.hfe |
| m1_lifeboat_mbasic_5_11.hfe | Microsoft Basic v 5.11 |
| m1_lifeboat_mbasic_5_22.hfe | Microsoft Basic v 5.22 and ELIZA.BAS |
| m1_lifeboat_tools.hfe | Squeezer and other tools |
| m1_lifeboat_bdsc.hfe | BD Software C compiler and linker |
