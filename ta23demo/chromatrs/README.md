# ChromaTRS Exhibit at Tandy Assembly 2023 

This demonstrated the modern ChromaTRS on a Model III. I used two Goteks and
two disk images. All the files are in the chromatrs subdirectory.

* Boot disk: `TRSDOS v13.hfe` this is just stock TRSDOS 1.3
* Data disk: `ChromaTRS TRSDOS v13.hfe` is the ChromaTRS software (disk is formatted for TRSDOS 1.3) 

All of the demos described below assume you have the boot disk in drive 0 and
the data disk in drive 1 and that you have booted TRSDOS 1.3.  I'm going to
assume you have a 48K Model III machine (adjust to use the COL32/CMD or
C32DISK/CMD drivers for basic if not)

## Robert French (author)

Robert French has permitted making the ChromaTRS sofware he wrote freely
downloadable with the following copyright notice: This material is licensed
under Attribution-ShareAlike 4.0 International ([CC BY-SA
4.0](https://creativecommons.org/licenses/by-sa/4.0/))

Robert wrote all of the software except `TA23/BAS` (but that uses Robert's
Chroma BASIC).

## MOUTHMAN/CMD (a PacMan-like game)

Run `MOUTHMAN/CMD` from TRSDOS.

## DEMO/BAS

Note in my testing you cannot run `DEMO/BAS` in Chroma BASIC, i.e., using
`C48DISC/CMD`, you have to use the `COL48/CMD` driver for this demo as
presented in this section.

To run this demo follow the steps below.

1. Run `COL48/CMD` at the TRSDOS prompt.
1. Run `BASIC` at the TRSDOS prompt.
1. For `HOW MANY FILES?` just press ENTER
1. For `MEMORY SIZE?` enter 52100 (36100 if 32K)
1. At the BASIC `>` prompt enter `LOAD"DEMO/BAS"`
1. At the BASIC `>` prompt enter `RUN` to start the demo
1. Follow the demo's menu to operate the demo

## Chroma BASIC

To get Chroma BASIC going follow the steps below.

1. Run `BASIC` at the TRSDOS prompt.
1. For `HOW MANY FILES?` just press ENTER
1. For `MEMORY SIZE?` enter 52100 (36100 if 32K)
1. At the BASIC `>` prompt enter `CMD"I","C48DISK/CMD"`
1. Do Chroma BASIC programming


# MLOGO/BAS and MLOGO/DMO

Follow the instructions above to load Chroma BASIC.

1. At the BASIC `>` prompt enter `LOAD"MLOGO/BAS"`
1. At the BASIC `>` prompt enter `RUN` to start MLogo
1. Use the MLogo menu to recall `MLOGO/DMO` and run it

# UFO/BAS

Follow the instructions above to load Chroma BASIC.

1. At the BASIC `>` prompt enter `LOAD"UFO/BAS"`
1. At the BASIC `>` prompt enter `RUN` to start the game

# TA23/BAS

Follow the instructions above to load Chroma BASIC.

1. At the BASIC `>` prompt enter `LOAD"TA23/BAS"`
1. At the BASIC `>` prompt enter `RUN` to start the demo
1. It runs forever so use `BREAK` to stop the demo
