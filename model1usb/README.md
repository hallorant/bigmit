# TRS-80 Model 1 USB-A Power Mod (5V DC conversion)

This modification can be useful if your Radio Shack power brick is bad or
noticeably hums. You might not have one at all.  The modification lets your
Model 1 run significantly cooler inside.  I've tested this modification on two
Model 1 keyboards (one with the Rosser 64k-in-keyboard modification) and run them for
multiple days.

I strongly suggest you do not do this modification on your only working Model 1
unless you are quite skilled with electronics work. The modification is pretty
simple but does require one trace cut and the removal of several components
from the motherboard.  Several wires are then soldered in place. Finally, a
5-pin DIN to USB-A cable is constructed.

The image below shows the resulting system.

!["A running USB-powered Model 1 keyboard"](../etc/images/m1usb_running.jpg?raw=true "A running USB-powered Model 1 keyboard")

Key features of this modification are

* The outside of the computer is unmodified and is indistinguishable from a
  stock Model 1. As you will see below, I use a sticker and orange paint on the
  5-pin DIN socket to distinguish my prototype units so I use the right power
  cable.

* It won't work, but is safe, to connect a real Radio Shack model 1 power brick.
  It is very easy to make this mistake. I have several times.

* Power still comes in via the 5-pin DIN connector.

* The power switch still works (so does the reset).

## A word of caution

I strongly suggest starting with a working Model 1. Do not do this modification
unless you are comfortable working inside a Model 1. If you have never opened
one up odds are you will destroy your computer. I can almost guarantee that the
flimsy stock keyboard connector will be damaged. Consider removing the original
keyboard connector and installing headers or another more robust solution of
your choice. You'll see my "quick connect" approach in the pictures.

This modification is harder than installing a lowercase modification but easier
than doing the Rosser 64k in-the-keyboard modification.

## What you need

Here's the list of parts you'll need

* One male 5-pin DIN solder connector

* One male USB-A solder connector

* Wire at least 22 gauge (to carry DC power). Silicone is recommended. For the
  cable I use parallel red-black wire. Inside the computer it doesn't matter.
  Do not use wire-wrap guage wire for this modification!

* Eight MCM4517P15 (16K) or MCM6665BP20 (64K used as 16K) memory chips. Search
  AliExpress or eBay for deals (or reach out to sellers like Mav). Note the mod
  can be done with the original 4116 memory but it is far more complex and needs
  a boost-buck transformer like my CoCo2 mod used. I have not fully documented
  keeping the 4116 memory in the computer, but I do sketch how to do it below
  (not recommended).  Memory is socketed (thank goodness) so this is easy to
  install. Ensure what you buy is in a 16-pin DIP package. Also if you upgraded a
  CoCo 2 from 16K to 64K, the 16K memory you took out is 4517 memory (and will
  work).

* (optional) 2 14-pin DIP sockets and a 14-pin DIP 7 position switch. I'll show
  this below, however, you can just use a short wire.

*NOTE:* If you have done the Rosser 64k-in-the-keyboard modification to your
Model 1 this conversion is greatly simplified. The 6555 memory you used is
fine. One could consider doing Rosser's modification prior to this one.  I have
found Rosser's modification to be very helpful to keep an expansion interface
(which you pull the memory out of once you do Rosser's modification) stable.  I
did this with one of my prototype machines, the other used 4517 (16K) memory.

What tools do you need

* A good desoldering tool that you are comfortable using. I use a Hakko 301.

* A good soldering iron. I use an (older) Weller WES51.

* Tools to take the Model 1 apart. I assume you can take apart a Model 1. (If
  not please see YouTube as there are lots of videos showing this.)

# Building the power cable

Below is a picture of the cable you need to construct.  I might have one,
please reach out to me on Facebook or Discord and I'll try to send you a cable.
Constructing the cable is a difficult task to accomplish (DIN connectors are a
pain to solder).

!["USB power cable for the Model 1"](../etc/images/m1usb_cable.jpg?raw=true "USB power cable for the Model 1")

## Caution

Do not cut and "reuse" a USB-A cable to save time. This is a bad idea. We want
to use 22 gauge wire (or larger) to ensure good current flow. The Model 1
keyboard uses ~0.9 amps. A lot of commercial cables are intended for data and
use very thin wire. Soldering a USB-A plug is easy, it's soldering the DIN that
is difficult.

## Some background and theory behind our cable

To understand this cable, we need to look at what we are doing and why the
Model 1 is somewhat complex to convert to DC power. The image below shows the
pinout of the Model 1 power connector from the *TRS-80 micro computer technical
reference handbook*.

!["Model 1 power connector pinout"](../etc/images/m1usb_power_pinout.jpg?raw=true "Model 1 power connector pinout")

This image explains why it is not easy to just create a replacement power brick
and plug it in. AC and DC power is sent into the keyboard. Pins 1 and 3 send in
15-17V AC (I measured this at 15V into the bridge rectifier CR8 on my machine).
~20V DC comes in on pin 2 with Ground on pin 4. So 15V AC and 20V DC come into
the computer.

What the computer actually needs to operate (inside) is three DC voltages: 5V,
-5V, and 12V.  However only the 4116 memory uses all three voltages. The
remainder of the motherboard only uses 5V.

This modification keeps ground unchanged on pin 4. We'll send 5V DC in on the
unused pin 5.

## Solder the 5-pin DIN first

Take apart the DIN and solder the black wire to pin 4 and the red wire to pin
5. Place a small piece of heat shrink on the wire to slide down after
soldering. You should get something like the below picture.

!["DIN soldering"](../etc/images/m1usb_din_soldering.jpg?raw=true "DIN soldering")

One suggestion is to tape the DIN (pins down) to the edge of the table and
bring the wire down while soldering to the back. I do not recommend that you
clamp a pin to an alligator clip holder and solder, I've found that this
approach often melts the plastic holding the pins. Resulting in a bent pin.

Ensure you give the connections a good tug. If they pull apart you did a bad
solder job and need to try again.

Next put the entire DIN connector together. We started with this connector
because you have to slide the cover over the wire. This is easier before the
USB-A connector is attached.

## Solder the USB-A connector second

Ensure the entire 5-pin DIN is soldered and put back together. Half the cable
is done. The male USB-A connector gets soldered as shown in the image below.

!["USB soldering"](../etc/images/m1usb_usb_soldering.jpg?raw=true "USB soldering")

Note in the image above red is 5V and green is ground. This is a connector I
keep around to check which side is which. Your cable will probably use black
for ground.

Ensure you give the connections a good tug. If they pull apart you did a bad
solder job and need to try again.

You then snap the USB plug casing around the metal. I tend to use some CA glue
and clamp the two sides together to ensure the casing doesn't come apart over
time. This glue is not required, but I suggest you keep it in mind if plug
casing keeps coming apart as you use it.

Your cable is complete. It is a good idea to test it with the continuity tester
on your multimeter.

# Modifying the Model 1 computer

TODO

## Some background and theory behind our changes

Changing a Model 1 to use DC (even batteries) has been done in the past.  If
you really know the computer anyone can do this. It is more complex to keep the
modification simple. My first prototype was a tangle of wires and cuts. Its
gotten better.

What we want to do is bypass the power regulation circuits on the motherboard.
By changing out the memory we have a 5V DC motherboard and an external 5V DC
power supply. The trick is to channel the power around the power circuits. Also
we do not want to remove the big transisters (this was required in the CoCo but
is not in the Model 1).

Clean power also matters a bit more to the Model 1 than in my experience with
CoCo. Not all USB power supplies will work well with a Model 1. I'll also
discuss how to use a Meanwell linear power supply (about a $6 part) to get very
clean power.
