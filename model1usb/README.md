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

## MEAN WELL power supply is recomended

The modification creates the ability to use USB power, but I recommend you
setup a [MEAN WELL RS-15-5 AC to DC power
supply](https://www.amazon.com/gp/product/B005T6UJBU). This has very low ripple
and noise (on par with the original power brick). It also works on AC power
worldwide. One of these can power a keyboard and an expansion interface in my
tests.

My experience leads to this rule of thumb. If you changed the memory and have a
5V only keyboard a USB charger tends to work fine as power. If you want to use
an expansion interface, or you kept the 4116 memory (using a DC-to-DC
converter) then you need to use the MEAN WELL.

## Two modification options

There are two options, one I consider GOOD and the other BAD:

**(OPTION GOOD)** This replaces the 4116 memory with either 4517 (16K) or 6665
(64K used as 16K). This simplifies the modification and allows the entire
computer to run off 5V DC power. I've had far less trouble with this
modification.

**(OPTION BAD)** keeps the 4116 memory in the computer but requires a small
DC-to-DC converter. I've found this is less successful, and more trouble.
It seems to only work with the MEAN WELL linear power supply (where you have
clean power and can dial in the voltage to about 5.1V. This also tends to bring
out weaknesses in the video sync logic. Be prepared to swap out Z5, Z6, and Z57
with new chips.

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
  Do not use wire-wrap guage wire for any part of this modification!

* **(OPTION GOOD)** Eight MCM4517P15 (16K) or MCM6665BP20 (64K used as 16K)
  memory chips. Search AliExpress or eBay for deals (or reach out to sellers like
  Mav). Memory is socketed (thank goodness) so this is easy to install. Ensure
  what you buy is in a 16-pin DIP package. Also if you upgraded a CoCo 2 from 16K
  to 64K, the 16K memory you took out is 4517 memory (and will work). Further, if
  you have done the Rosser 64K memory-in-the-keyboard you are all set. Rosser's
  modification already converted your memory to 6665 chips which only require 5V.

* **(OPTION GOOD)** A 14-pin DIP socket and a 14-pin DIP 7 position switch. I'll show
  this below, however, you can just use a short wire if you wish.

* **(OPTION BAD)** A DC to DC converter 12V/-12V. I used [this
  one](https://www.ebay.com/itm/124193492824), pick +-12V no pins.

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

In this section I'll describe how to modify your Model 1 motherboard. We'll
start by explaining what we are doing and then go into the step-by-step.

## Some background and theory behind our changes

Changing a Model 1 to use DC (even batteries) has been done in the past.  One
instance that I'm aware of is dicussed in [TRS-80 Trash Talk Episode
18](https://www.trs80trashtalk.com/2017/10/these-are-show-notes-for-episode-18-of.html).
Mike Yetsko created a battery powered TRS80. In this episode Mike describes
using batteries to supply all three voltages 5V, -5V, and 12V. If you really
know the computer anyone can do this. It is more complex to keep the
modification simple. My first prototype was a tangle of wires and cuts. Its
gotten better.

What we want to do is bypass the power regulation circuits on the motherboard.
The trick is to channel the power around the active power regulation circuits
(that create the heat in a stock Model 1).  Also we do not want to remove the
big transisters (this was required in the CoCo but is not in the Model 1). What
we want is a clean path to the DC power out to the voltage rails.  My pencil
marks give some insight into earlier attempts and can be ignored. The red-X's
show where we will remove components and the green show the clear path out of
the power regulation circuits to the motherboard logic.

!["Motherboard schematic changes"](../etc/images/m1usb_schematic.jpg?raw=true "Motherboard schematic")

**(OPTION BAD) KEEP 4116 MEMORY:** To use the original 4116 memory we have to
supply each power path with the volatge that it needs. However, there is a
subtile shortcut that we can do for the -5V. DC-to-DC transformers are cheap,
however we will get 12V and -12V not 12V and -5V. What can we do? The bottom
path of the schematic above is a circuit to regulate -13.3V (my measurement
yours will vary) out of the bridge rectivier (CR8) to -5V. What we will do is
connect our -12V DC to the *(Neg Pt)* (the negative or right side of C1) to use
part of the Model 1's power regulation to get us -5V. This works very well in
practice and does not generate excessive heat because the regulation here is
not active, its just a diode (CR2). In fact, CR2 is a 5% 5.1V Zener diode.
Perfect.

Given the DC-to-DC converter the rest is easy. 5V is hooked up to Z1 pin 3 and
12V is hooked up to Z2 pin 3. This makes all the power rails exactly like the
original machine.

To summarize this option we

* Connect 5V DC power into the 5V power grid (the left hand side of R4 as
  presented below) and into the input of the DC-to-DC converter.

* Connect -12V out of the DC-to-DC converter to *(Neg Pt)* to get -5V.

* Connect 12V to Z2 pin 3.

The drawback of this approach is we have to include the DC-to-DC converter.
I've also noted it brings out problems in the video sync circuit.  The benefit
is that we do not need to replace the memory chips.

**(OPTION GOOD) USE 4517 OR 6665 MEMORY:** If we swap out the memory we can make a
5V only system. This removes the need for the DC-to-DC converter, however,
there is snag. If you look at the memory chip pinouts for the 4517 (16K) and
the 6665 (64K using 16K) in the diagram below, in both cases, we have to get 5V
on the lines where prevously there was 12V. We can safely ignore the -5V lines.

!["Memory pinouts"](../etc/images/m1usb_memory_pinouts.jpg?raw=true "Memory pinouts")

To get 5V where the stock computer had 12V is easy. Simply connect Z1 pin 3 to
Z1 pin 12 (connected to Z2 pin 3).  This will channel 5V over to the (old) 12V
lines and make them 5V as well.

To summarize this option we

* Change all the memory chips (Z13 through Z20) from 4116 to either 4517 (16K)
  and the 6665 (64K using 16K).

* Ignore the -5V path (bottom of the diagram above) it will not be used.

* Connect 5V DC power into the 5V power grid (the left hand side of R4 as presented below).

* Bridge Z1 pin 3 to Z1 pin 12 (connected to Z2 pin 3) to change the 12V path to 5V.

*Note:* If you already did the Rosser 64k-in-the-keyboard mod some of the above
is not need. That modification disconnected the 12V lines and bridged them to
5V. So this change will be easier as we discuss below.

## Remove the DRAM chips

Start off by removing the socketed Z13-Z20 memory chips. Regardless of option
we want to test power before we put memory chips back into the machine.

## Removing components

We'll start by removing several components. Required for both options.

* Remove two DIP chips: Z1 and Z2

* Remove resistors: R4, R7, R8, R13, and R18

* Remove capacitor C8 entirely.

* Unsolder and disconnect only the + side of C9 (near the power switch).

Below is a picture of what this should look like.

!["Components to remove"](../etc/images/m1usb_removals.jpg?raw=true "Components to remove")

## Setup the power switch

Flip the computer over to the back and focus near the power connector and power
switch.  We need to do a trace cut and solder a wire from pin 5 of the power
connector to the right position on the switch. None of this is labeled so use
the image below to guide you.

!["Setup the power switch"](../etc/images/m1usb_setup_power_switch.jpg?raw=true "Setup the power switch")

Use the continuity tester on your multimeter to ensure this is all correct.
Check that the connection on pin 4 of the power connector is not shorted to the
pin close to it. Also be sure your trace cut is not conducting. I used a Dremel
tool to do the trace cut (just to be sure) but great care is required (practice
this a few times if you try it).

The trace cut isolates the power switch lead we will use to connect power to
the motherboard. To do this turn the board around to show the chips.  You need
to position the positive lead of C9 to reach the third connection back on the
left hand side of the power switch. Add a bit of shrink wrap to ensure the C9
lead doesnt connect with any other power switch terminals. We'll also insert a
wire of about 4 inches that will connect to the motherboard. The picture below
shows what this should look like prior to soldering.

!["Power on connections"](../etc/images/m1usb_power_to_motherboard.jpg?raw=true "Power on connections")

I suggest you look over the leads on the switch. I've had to use some sandpaper
to clean some of these off. If it looks black or dirty do this. We want a good
solder connection. Then solder the two wires to the power switch.

At this point the procedure differs depending on which option you choose.

## Completing (OPTION GOOD) Using 4517 or 6665 Memory

Trim and solder the wire connected to the power switch to the R4 hole closest
to the power switch. This should look like the image below.

!["5V to motherboard"](../etc/images/m1usb_5v_motherboard.jpg?raw=true "5V to motherboard")

Finally, we need to bridge the old 12V grid to the old 5V grid so everything is
5V DC. You can do this one of two ways. The first option is to simply put a
short wire between Z1 pin 3 and Z1 pin 12 (straight across). This is shown in
the image below.

!["Wire option to bridge 12V to 5V"](../etc/images/m1usb_bridge_12V_5V_wire.jpg?raw=true "Wire option to bridge 12V to 5V")

The second option is to solder sockets into Z1 (and optionally Z2) and use a 7
switch DIP. This is shown in the image below. Be sure to turn off all the
switches except 3 (which is on).

!["Switch option to bridge 12V to 5V"](../etc/images/m1usb_bridge_12V_5V_switch.jpg?raw=true "Switch option to bridge 12V to 5V")

It really doesn't matter which you choose (I used the second when I was
testing). The modification is complete.

## Completing (OPTION BAD) Keep 4116 Memory

[Plug adapter](https://www.amazon.com/gp/product/B081VJ22G4)
