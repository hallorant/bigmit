# Color Computer 2 USB Power Mod - Running your Color Computer 2 from a USB powerstrip

This modification can be useful if your power supply is bad. However, my
primary motivation was how hot my CoCo 2 ran. This modification changes your
CoCo from running on AC power to operating on DC power.

The permanent modification requires some hardware skill to accomplish.
Removing the transformer (easy) and the Q1 power transistor (harder) take a bit
of skill as well as soldering connections to the motherboard.  However, you can
try this out with a simple clip-on cable attached to your CoCo motherboard. The
tryout setup has some limitations, but can let you see if you really want to
proceed with a permanent modification.

## Tandy Assembly 2021 Talk

I did a talk at Tandy Assembly 2021. You can find the slides
[here](https://docs.google.com/presentation/d/19PG-rJjY0_h8iO4LEgI_-lZHJsW6ekmSQ-hHDLxJ2CU/edit?usp=sharing).
Please beware as the content might be out of date.

# Trying out the USB mod with the "tryout cable"

This is a simple way to try running your CoCo 2 on USB power. This should work
with any CoCo 2. First, unplug your CoCo 2 from the wall socket (or power
strip). Do not plug in the USB plug yet. Attach the tryout cable clips to the
wires running from the motherboard to the cartridge slot: red clip goes to pin
9 (+5V) the black clip goes to pin 33 (GND).

!["CoCo 2 Tryout Diagram"](../etc/images/coco2_tryout_diagram.jpg?raw=true "CoCo 2 Tryout Diagram")

This is what the attachment of the tryout cable looks like inside the computer.
Note that the wires to the cartridge outside are odd and the inside are even.
If we consider "top" as toward the back of the machine.  The red wire is
attached to the 5th from the top, the black to the 4th from the bottom. The
image below is from a Korean-made CoCo 2 but all CoCo 2s should attach the same.

!["CoCo 2 Tryout Attachments"](../etc/images/coco2_tryout_attach.jpg?raw=true "CoCo 2 Tryout Attachments")

Next string the cable out the back (anywhere) and put the top on without
screws. Double check that you __do not__ have the power cable plugged into AC
power. Plug the USB plug into a USB power strip and your CoCo should come on.

This setup has several limitations (solved by the permanent mod).

* The power switch doesn't work (reset does work).
  On/off is accomplished by plugging in (on) and unplugging (off) the USB
  connection.
* The serial connection (bit banger) doesn't work. You can't use drivewire (but
  CoCo SDC will work fine).
* The cassette input, e.g., CLOAD or CLOADM, doesn't work (output does).

To overcome these limtations you have to do the permanent USB power
modification. However, we recommend using the machine this way for a bit to see
how you like it before deciding to do the permanent mod. A few benefits to
note.

* Computer runs cool. Feel the left-hand-side of the CoCo after it has been
  running for a while. It is cool. You are not engaging the transformer nor the
  Q1 power transistor which are two very large heat sources inside a CoCo.
* The CoCo transformer is not always on. On any CoCo it is a good idea to use a
  power strip and turn the power strip off when the computer is not in use.
  Why? This is because the transformer is always on, even when the computer is
  powered off. If you noted that the left-hand-side of the CoCo is slightly
  warm even after the CoCo is off for a long time, this is why that occurs.
* If you have a quality USB power strip the 5V DC power is probably better than
  the power system in the CoCo can provide. Most USB power strips provide
  5V DC at 2.4 amps but a CoCo only uses 1 amp (or less).

It is safe to switch back and forth between using the tryout-cable-USB power
and wall-plug power. Say you need to use the cassette for a bit. The only rule
is __use one or the other__. Don't plug them both in at once! I ran this setup
for several months.

## How to make your own "tryout cable"

You can contact me to get a tryout cable, however it is easy to make one. The
image below shows how to solder one up.

!["CoCo 2 Tryout Cable"](../etc/images/coco2_tryout_cable.jpg?raw=true "CoCo 2 Tryout Cable")

A few words of caution.

* Before you hook this up to your CoCo 2, please check with your multimeter
  that red to black is +5V. In particular, ensure it is not -5V, which
  indicates you wired power and ground backwards.
* Don't reuse a USB-A data cable. You want the wire guage to be thick enough to
  let power flow. I'm using AWG 22. A USB-A power cable capable of 2.5A should
  be fine to reuse. In general, if you reuse a USB cable and the wires are
  really thin then the tryout cable will not work or be unreliable.

# Identifying compatible systems for the permanent USB power modification

CoCo 2 computers that I own that work are

* Color Computer 2 with a Rev B Motherboard
* Korean-made Color Computer 2

Other CoCo 2's should work, please reach out to me if you have one that is odd.
Perhaps it can be supported.

## CoCo 2 Rev B motherboard

### Identification (Is my CoCo 2 a Rev B?)

Outside, this has the tall tuner with the channel selector above the video
output connection. But you want to open up your CoCo 2 and look at the left
side of the motherboard (just below the transformer). If you have a Rev B
you'll see an identification as shown in the picture below.

!["CoCo 2 Rev B Motherboard Identification"](../etc/images/coco2_rev_b_board_id.jpg?raw=true "CoCo 2 Rev B Motherboard Identification")

### How to spot an incompatible modification

With this mod installed your whole CoCo will run via DC power, however
modifications exist that use AC power. Especially the (unregulated) 12VAC
entering the bridge rectifier.  This is easy to spot, however, and you can
decide to continue or not based on your need for the AC-using modification.

Look for any wires attached to the AC side of the bridge rectifier. If we
consider "top" as toward the back of the machine. Look for any wire attached to
the top of CR1 or CR2 or any wire attached to the bottom of CR3 or CR4. The
image below has the USB mod installed, but it boxes the AC side of the bridge
rectifier. If any mod to your CoCo is attached to the AC/boxed side of the
bridge rectifier then the USB mod is incompatible with it.

!["CoCo 2 Rev B Finding Incompatible Mods"](../etc/images/coco2_rev_b_incompatible_mods.jpg?raw=true "CoCo 2 Rev B Finding Incompatible Mods")

The only incompatible mod I am aware of for the Rev B CoCo 2 is a composite
video modification. It attaches to the bottom of CR3 or CR4. Beware, there may
be others! So please check your Coco.

## Korean-made CoCo 2 Identification

### Identification (Is my CoCo 2 Korean-made?)

A Korean-made CoCo 2 can be identified from the outside by the channel select
switch beside the TV output and a horizontally mounted modulator (metal box)
which can be seen through the top grille, to the left of center. It likely says
"Product of KOREA" on the bottom.

!["CoCo 2 Korean-made Identification"](../etc/images/coco2_korean_board_id.jpg?raw=true "CoCo 2 Korean-made Identification")

### How to spot an incompatible modification

With this mod installed your whole CoCo will run via DC power, however
modifications exist that use AC power. Especially the (unregulated) 12VAC
entering the bridge rectifier.  This is easy to spot, however, and you can
decide to continue or not based on your need for the AC-using modification.

Look for any wires attached to the AC side of the bridge rectifier. If we
consider "top" as toward the back of the machine. Look for any wire attached to
the top of D8, D9, D10, or D11. The image below boxes the AC side of the bridge
rectifier. If any mod to your CoCo is attached to the AC/boxed side of the
bridge rectifier then the USB mod is incompatible with it.

!["CoCo 2 Korean-made Finding Incompatible Mods"](../etc/images/coco2_korean_incompatible_mods.jpg?raw=true "CoCo 2 Korean-made Finding Incompatible Mods")

# Permanent USB power modification

The permanent USB power modification overcomes all the shortcomings of the
tryout cable. Except for how you plug in the CoCo (a USB cable) its operation
is indistinguishable from the original plug.

* The computer runs cool.
* You can leave it pluged into the USB power strip. The CoCo's power switch
  cuts off use of DC power.
* An (optional) case mod allows you to unplug your power cable. No more
  dangling cable.

The permanent mod has a cable that plugs into USB and the CoCo and a cable that
is soldered onto points on the CoCo motherboard.

## Supported CoCo 2s

CoCo 2 computers that I own that work are

* Color Computer 2 with a Rev B Motherboard
* Korean-made Color Computer 2

Other CoCo 2's should work, please reach out to me if you have one that is odd.
Perhaps it can be supported.

## Making your own permanent USB power modification kit

You can make your own modification. What you need is listed below.

* Wire that can carry power in a few colors.  Don't use too thin of wire. I use
  [22AWG silicone wire](https://www.amazon.com/gp/product/B01LH1FR6M)
* I suggest a [barrel jack](https://www.amazon.com/dp/B091PS6XQ4) because you
  can buy [commercial USB power cables](https://www.amazon.com/dp/B01MZ0FWSK).
* A DC step-up boost converter at ±9V. I used [this
  one](https://www.ebay.com/itm/124193492824?var=425041936660). Ensure ground
  in is the same as ground out.

You can use all the pictures below to create one. The yellow wire is +9V and
the blue wire is -9V in my kits. The black wires are GND and the red wires are
+5V.

Be sure that you tin all the wire tips you are going to attach to the
motherboard.

You need a good soldering iron and a multimeter. Before putting your cable in a
CoCo, ensure you plug it in and test voltages. Connect the two red cables (with
alligator clips) as if the power switch is on. Check that you see 5V, 9V, and
-9V on the correct wires. If not, double check what you did and fix the problem
before moving on to put the kit into a CoCo 2.

# CoCo 2 Rev B motherboard permanent USB power modification

A diagram of what you are going to do is below. This is the older kit that used
a 1/8 audio jack (newer ones use a barrel jack).

!["CoCo 2 Rev B Permanent Modification Diagram"](../etc/images/coco2_rev_b_permanent_usb_diagram.jpg?raw=true "CoCo 2 Rev B Permanent Modification Diagram")

A few notes

* You can connect to the bottom of CR1 or CR2, it doesn't matter which.
* You can connect to the top of CR3 or CR4, it doesn't matter which.
* The GND pin is E1 (it is down near Q1 below the transformer).
* It doesn't matter which side of the power switch you solder too, but be
  consistent. Both connections must be on the right or the left.
* In the picture above I put two wires onto the power switch. Check your power
  switch. On some of them there is plenty of room to do this. But on others
  there is very little space. If yours has limited space then splice together 3
  red wires so that only a single wire needs to be attached to the power switch
  rail.
* In the picture above I have a quick release for the GND connection. You can
  also just solder this connection.

## Remove the transformer

Make sure your CoCo is unplugged. Pull loose the three connectors for the
transformer. Unscrew it (two screws) and remove it from the CoCo. You'll want
to be careful undoing the power cord from the "snake" strain relief. Remove
this from the machine (and put it in a bag to save). Below is a picture of the
transformer out of the machine.

!["CoCo 2 Rev B Removed Transformer"](../etc/images/coco2_rev_b_transformer.jpg?raw=true "CoCo 2 Rev B Removed Transformer")

## Remove the Q1 transistor, a.k.a, Heat Mizer

This is the hardest part of this mod. Q1 is part of the creation of 5V DC power
and generates more heat than anything in the CoCo. To partially power the SALT
and get the cassette port and bit banger working we need to power the SALT
except for the creation of 5V DC power.

To desolder and remove the Q1 transistor from the CoCo.  Start by removing the
motherboard and its backing. Q1 has a heat sync around it. Part of this heat
sync is bent in so it does not touch and melt the keyboard plastic. Carefully
hand bend this straight. Use needlenose pliers or a driver to loosen the bolts
and carefully remove them.

Desolder the two connections (between the screws) on the underside of the
motherboard and remove Q1. I used a solder sucker (with 1.4mm hole) and sort of
gently pulled at it with the neadlenose pliers to get it free. The white stuff
conducts heat from the transistor to the heat sync and can stick a little. I
did some minor damage to the traces (right near the transistor attachment).

Once you have the transistor out. I suggest you put the heat sink and bolts
back on. You could even tape the transistor into the cage to save it inside the
CoCo (make sure you cover the pins with electrical tape). Below is a picture of
this out of the machine and the bolts back in. This is, by far, the hardest
part of this modification so take your time and get help if you need it.

!["CoCo 2 Rev B Q1 Transistor Removed"](../etc/images/coco2_rev_b_q1.jpg?raw=true "CoCo 2 Rev B Q1 Transistor Removed")

You could alternatively cut the traces to Q1. This is easier but not
reversible.

## Attach the DC-DC Step-up Boost Converter Dual Output Power Supply

I suggest you use double-sided tape to tape the boost converter into the old
transformer location. In early kits (and the picture below) I used a screw but
this depends upon extra board space on the boost converter which most do not
have.

!["CoCo 2 Rev B Attach DC to DC board"](../etc/images/coco2_rev_b_dc_to_dc.jpg?raw=true "CoCo 2 Rev B Attach DC to DC board")

This little board is how the SALT is powered. Experiments have shown that ±9V
works fine rather than the unregulated ±12V the machine gets out of the bridge
rectifier. The initial mods use ±9V. The current (amps) is extremely low
because this is only used for the bit banger (serial) and cassette input
zero-volt-crossing detection capabilties on the motherboard.

## Attach the ground plug

Take the black wire plug and push it onto the ground attachment, E1, used by
the transformer. E1 is a single little post toward the front-left of the
machine on the motherboard as shown in the picture below.

!["CoCo 2 Rev B Attach the Ground Plug"](../etc/images/coco2_rev_b_ground.jpg?raw=true "CoCo 2 Rev B Attach the Ground Plug")

Now all you have to do is solder several attachments to the motherboard. The
diagram at the top of this section is useful to reference what we are doing.

##  Solder the 5V DC wires

* Solder the red wire from the 1/8" jack to a middle peg (right or left)
  on the power switch.
* Solder the middle of the long red red wire from the DC to DC step-up boost
  converter to the front peg (choose same the same side as above) on the
  power switch.
* Solder the end of the red wire to the side C28 toward the back of the
  machine.

These connections are shown in the image below. The C28 connection is the same
place we attached the tryout cable. But we don't need the ground side because
of the ground plug attached above.

!["CoCo 2 Rev B Solder 5V DC Wires"](../etc/images/coco2_rev_b_5v.jpg?raw=true "CoCo 2 Rev B Solder 5V DC Wires")

##  Solder the ±9V DC wires to the DC side of the bridge rectifier

* Solder the blue wire (-9V DC) to the side of CR1 or CR2 toward the front of
  the machine.
* Solder the yellow wire (9V DC) to the side of CR3 or CR4 toward the back of
  the machine

These connections are shown in the image below. A closeup of the 5V DC
connection to C28 is also shown.

!["CoCo 2 Rev B Solder SALT Power"](../etc/images/coco2_rev_b_salt_power.jpg?raw=true "CoCo 2 Rev B Solder SALT Power")

The permanent mod is complete.

## Finishing up

Its a good idea to pull at all the solder connections to be sure they are solid
and test connections with a multimeter (beep test). Before you screw on the
top, power up the machine and make sure everything works okay. The heat sink Q1
was inside of won't heat up so if your keyboard fits you don't need to bend it
back like it was (just hand bend it so your keyboard fits in okay).

# Korean-made CoCo 2 permanent USB power modification

A diagram of what you are going to do is below. This is the newer kit that uses
a barrel jack (and a commercial USB power cord).

!["CoCo 2 Korean-made Permanent Modification Diagram"](../etc/images/coco2_korean_permanent_usb_diagram.jpg?raw=true "CoCo 2 Korean-made Permanent Modification Diagram")

A few notes

* You can connect to the bottom of D8 or D9, it doesn't matter which.
* You can connect to the bottom of D10 or D11, it doesn't matter which.
* The GND pin is A3 (it is the bottom pin to the right of the transformer).
* It doesn't matter which side of the power switch you solder too, but be
  consistent. Both connections must be on the right or the left.

## Attach the ground plug

Take on the black wire plug and solder it onto the ground attachment pin, A3, used by
the transformer. The position of A3 is shown in the image below.

!["Korean-made CoCo 2 Attach the Ground Plug"](../etc/images/coco2_korean_ground.jpg?raw=true "Korean-made CoCo 2 Attach the Ground Plug")

##  Solder the 5V DC wires

* Solder the red wire from the 1/8" jack to a middle peg (right or left)
  on the power switch.
* Solder the middle of the long red red wire from the DC to DC step-up boost
  converter to the front peg (choose same the same side as above) on the
  power switch.
* Solder the end of the red wire to the right side C9 (marked with a +) toward
  the back of the machine.

The switch connections are exactly the same as the Rev B motherboard so please
refer to that image above.  The last connection, C9 (+), is shown in the image
below. We don't need the ground side because of the ground plug attached above.

!["Korean-made CoCo 2 Solder 5V DC Wire"](../etc/images/coco2_korean_5v.jpg?raw=true "Korean-made CoCo 2 Solder 5V DC Wire")

Note that if I sent you a kit, hopefully the red wire reaches. If it is too
short splice on more wire to make the connection.

##  Solder the ±9V DC wires to the DC side of the bridge rectifier

* Solder the blue wire (-9V DC) to the side of D8 or D9 toward the front of
  the machine.
* Solder the yellow wire (9V DC) to the side of D10 or D11 toward the front of
  the machine

These connections are shown in the image below.

!["Korean-made CoCo 2 Solder SALT Power"](../etc/images/coco2_korean_salt_power.jpg?raw=true "Korean-made CoCo 2 Solder SALT Power")

Use some double-sided tape to attach the DC boost converter to the bottom of
the old transformer location.

The permanent mod is complete.

# Optional case modification

There are two options

* Use a mono 1/8" (3.5mm) jack.
* Use a 5.5mm x 2.1mm barrel jack.

The [barrel jack](https://www.amazon.com/dp/B091PS6XQ4) is harder to install
but you can buy [commercial cables](https://www.amazon.com/dp/B01MZ0FWSK) that
work with it.  The concern with the mono 3.5mm jack is that it can short (if
you plug it in to USB power and it is not plugged-in to a CoCo).

I recommend doing one of these case mods. I found the USB cable annoying when
hanging out like the original power cord. But it can safely be skipped.

## What to do if you don't want to mod your case

If you do not do a case mod, plug in whatever jack you have and wrap it with
tape (so it doesn't short anything). Tape it (e.g., with electrical tape) into
the empty transformer location with the DC boost transformer. If you are
building the kit yourself.

## Case mod for the mono 1/8" (3.5mm) jack

Drill a hole in the lower case such that the 1/8" jack plug
connector fits through the hole. This may be anywhere on the case but I show
where I put it in the picture below (circled in green). Use care and ensure the
jack fits behind the plastic (about half way up seems to work okay). I also
recommend drilling a little hole then using that to guide the bigger one.

!["CoCo 2 Mono Jack Case Mod"](../etc/images/mono_jack_case_mod.jpg?raw=true "CoCo 2 Mono Jack Case Mod")

## Case mod for the 5.5mm x 2.1mm barrel jack

This is probably the better option but it is harder to add to the computer.
The image below shows this in my CoCo 2.

!["CoCo 2 Barrel Jack Case Mod"](../etc/images/barrel_jack_case_mod.jpg?raw=true "CoCo 2 Barrel Jack Case Mod")

Depending on your CoCo it might be possible to put the barrel jack in the lower
part of the case. The one above is a Rev 2 motherboard. I found this very
difficult to do. I had to glue the case and then dremel out plastic in the
bottom of the case to fit the nut to attach the jack. If you get this to work
it is very nice if you often work on the insides of the CoCo 2 (which I do). If
you do not, I strongly suggest placement in the upper shell.

To place the jack barrel in the upper shell. Be sure you have room to put in
the nut and that the jack barrel will clear the plastic that holds the
transformer.

Start with a small hole (e.g., 1/8") then do the larger drill hole. I did 3/8"
and used sandpaper on a screwdriver barrel to expand the opening to the proper
size to fit the barrel.

On these kits I add quick connects to the barrel. So that if you need to take
off the top you can disconnect the parts of the power setup in the upper shell
from those in the lower shell.
