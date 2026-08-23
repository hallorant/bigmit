# Tandy Assembly 2026

I did a tech talk entitled *Getting Started with Color Computer (6809) Assembly
Language*.  You can see [here](https://www.youtube.com/@tandyassembly). The
slides are
[here](https://docs.google.com/presentation/d/1N5codp10Ogxy7Pqj6jjTuDs5W2HU8_vKQxmkUmJPxrg/edit?usp=sharing).

I showed off using the following tools

* Tandy's [EDTASM+](./EDTASM+.ccc) a cassette-based editor, assembler and
  debugger (ZBUG). Its [manual](./EDTASM+_manual.pdf) is pretty good, however,
  it is the tool used by William Barden, Jr. in [TRS-80 Color Computer Assembly Language
  Programming](https://os9projects.com/CD_Archive/TUTORIAL/COCO/COCOASSEMBLY/CoCoAssemblyLang_Color.pdf)
  which is highly recommended. You can usually find a copy of the Barden book
  or the EDTASM+ cartridge on eBay.

# Emulators

I used two emulators to prepare for my tech talk. These were $trs80gp$ and
$XRoar$.  XRoar is very well known in the CoCo community and accurate. However,
I do a lot with z80 TRS-80 machines and I'm familiar with trs80gp so tended to
use trs80gp a lot and found it to work well.

## Using trs80gp

You can get and install trs80gp [here](https://48k.ca/trs80gp.html) at George
Phillip's site.

To run EDTASM+ on trs80gp:

```
trs80gp -mc EDTASM+.ccc
```

To run SDS80 on trs80gp:

```
trs80gp -mc SDS80C.ccc
```
## Using XRoar

I installed XRoar with [Homebrew](https://brew.sh/) on my MacBook and it went
smoothly with ``brew install xroar``.

To run EDTASM+ on XRoar:

```
xroar -m coco -cart EDTASM+.ccc
```

To run SDS80 on XRoar:

```
xroar -m coco -cart SDS80C.ccc
```

