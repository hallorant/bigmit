# CoCo USB Power Mod - Running your COCO from a USB powerstrip

This modification can be useful if your power supply is bad. However, my
primary motivation was how hot my CoCo 2 ran. This modification changes your
CoCo from running on AC power to operating on DC power.

The permanent modification requires some hardware skill to accomplish.
Removing the transformer (easy) and the Q1 power transistor (much harder) take
a bit of skill as well as soldering connections to the motherboard.  However,
you can try this out with a simple clip-on cable attached to your CoCo
motherboard. The tryout setup has some limitations, but can let you see if you
really want to proceed with a permanent modification.

## CoCo 2 Rev B motherboard

### Identification (So many CoCo 2s &mdash; Is mine a Rev B?)

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
image below has the USB mod installed, but it circles the AC side of the bridge
rectifier. If any mod to your CoCo is attached here the USB mod is incompatible
with it.

!["CoCo 2 Rev B Finding Incompatible Mods"](../etc/images/coco2_rev_b_incompatible_mods.jpg?raw=true "CoCo 2 Rev B Finding Incompatible Mods")

The only incompatible mod I am aware of for the Rev B CoCo 2 is a composite
video modification. It attaches to the bottom of CR3 or CR4. Beware, there may
be others! So please check your Coco.

### Trying out the USB mod with the "tryout cable"

This is a simple way to try running your CoCo 2 on USB power. First, unplug
your CoCo2 from the wall socket (or power strip). Do not plug in the USB plug
yet. Attach the tryout cable clips to the top (red) and bottom (black) of C28.

!["CoCo 2 Rev B Tryout Diagram"](../etc/images/coco2_rev_b_tryout_diagram.jpg?raw=true "CoCo 2 Rev B Tryout Diagram")

This is what the attachment of the tryout cable looks like inside the computer.

!["CoCo 2 Rev B Tryout Attachments"](../etc/images/coco2_rev_b_tryout_attach.jpg?raw=true "CoCo 2 Rev B Tryout Attachments")

Next string the cable out the back (anywhere) and put the top on without
screws. Double check that you __do not__ have the power cable plugged into AC
power. Plug the USB plug into a USB power strip and your CoCo should come on.

This setup has several limitations (solved by the permanent mod).

* The power switch doesn't work (reset does work).
  On/off is accomplished by plugging in (on) and unplugging (off) the USB
  connection.
* The serial connection (bit banger) doesn't work. Can't use drivewire.
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
  Why? This is because the transfomer is always on, even when the computer is
  powered off. If you noted that the left-hand-side of the CoCo is slightly
  warm even after the CoCo is off for a long time, this is why that occurs.
* If you have a quality USB power strip the 5V DC power is probably better than
  the power system in the CoCo can provide. Most USB power strips provide
  5V DC at 2.4 amps but a CoCo only uses 1 amp (or less).

### Permanent USB power modification

The permanent USB power modification overcomes all the shortcomings of the
tryout cable. Except for where you plug in the CoCo its operation is
indistinguishable from the original plug.

* The computer runs cool.
* You can leave it pluged into the USB power strip. The CoCo's power switch
  cuts off use of DC power.
* An (optional) case mod allows you to unplug your power cable. No more
  dangling cable.

The permanent mod has a cable that plugs into USB and the CoCo and a cable that
is soldered onto points on the CoCo motherboard.  A diagram of what you are
going to do is below.

!["CoCo 2 Rev B Permanent Modification Diagram"](../etc/images/coco2_rev_b_permanent_usb_diagram.jpg?raw=true "CoCo 2 Rev B Permanent Modification Diagram")

Put the USB cable away for a bit. We need to install the internal cable.

#### Remove the transformer

Make sure your CoCo is unplugged. Pull loose the three connectors for the
transformer. Unscrew it (two screws) and remove it from the CoCo. You'll want
to be careful undoing the power cord from the "snake" strain relief. Remove
this from the machine (and put it in a bag to save). Below is a picture of the
transformer out of the machine.

!["CoCo 2 Rev B Removed Transformer"](../etc/images/coco2_rev_b_transformer.jpg?raw=true "CoCo 2 Rev B Removed Transformer")

#### Remove the Q1 transistor, a.k.a, Heat Mizer

This is the hardest part of this mod. Q1 is part of the creation of 5V DC power
and generates more heat than anything in the CoCo. To partially power the SALT
and get the cassette port and bit banger working we need to power the SALT
except for the creation of 5V DC power.  There are several ways to do this but
after consulting Terry Trappe (who is working on a SALT replacement) I choose
to remove Q1. We describe the options and our rationale below.

* (NOPE) Bend up pins on the SALT. I dismissed this immediately despite this
  option being simple to do (the SALT is socketed in my CoCo). The SALT is not
  a replaceable chip.
* (NOPE) Trace cut the connections to Q1. This would be fine but is harder to
  undo. But is a reasonable approach.

* (CHOSEN) Desolder and remove the Q1 transistor from the CoCo. This stops the
  SALT from creating 5V DC power but allows all its other functions to work.
  Why this option? The SALT and the motherboard are not replaceable but Q1 is
  a 2N6569 transistor (Parts list says SJ5812) which you can get a new one
  for a few bucks. It is easily to replace, further, removing it is unlikely
  to actually damage it.

Start by removing the motherboard and its backing. Q1 has a heat sync around
it. Part of this is bent in to not touch and melt the keyboard plastic.
Carefully hand bend this straight. Use needlenose pliers or a driver to loosen
the bolts and carefully remove them.

Desolder the two connections (between the screws) on the underside of the
motherboard and remove Q1. I used a solder sucker and sort of gently pulled at
it with the neadlenose pliers to get it free. The white stuff conducts heat
from the transistor to the heat sync and can stick a little. I did some minor
damage to the traces (right near the transistor attachment) but this would be
much easier to fix than a trace cut.

Once you have the transistor out. I suggest you put the bolts back on. You
could even tape the transistor into the cage to save it inside the CoCo (make
sure you cover the pins with electrical tape). Below is a picture of this out
of the machine and the bolts back in. This is, by far, the hardest part of this
modification so take your time and get help if you need it.

!["CoCo 2 Rev B Q1 Transistor Removed"](../etc/images/coco2_rev_b_q1.jpg?raw=true "CoCo 2 Rev B Q1 Transistor Removed")

#### Case mod for the 1/8" jack

I recommend doing this case mod. I found the USB cable annoying when hanging
out like the original power cord. But it can safely be skipped.

__No case mod:__ Plug in the 1/8" mono jack and run the USB cable out the
destraining pegs just like the original power cord ran. I recommend you use
electrical tape to tape around the mono jack and plug (avoids a short).

__Case mod:__ Drill a hole in the lower case such that the 1/8" jack plug
connector fits through the hole. This may be anywhere on the case but I show
where I put it in the picture below (circled in green). Use care and ensure the
jack fits behind the plastic (about half way up seems to work okay). I also
recommend drilling a little small hole then the bigger one.

!["CoCo 2 Rev B Case Mod"](../etc/images/coco2_rev_b_case_mod.jpg?raw=true "CoCo 2 Rev B Case Mod")

I selected the 1/8" mono plug because it is much easier to do a case mod that
is circular with a drill. Actually adding a USB plug would be very hard to cut
into the case. I also like to put these mods on the lower half of the case
because when you remove the top you do not need to detatch them or risk
damaging the wire connections. You can see I put the CoCoVGA sound mod over to
the left. That mod is another 1/8" mono plug that I don't need to remove
everytime I take the top shell off my CoCo.

#### Attach the DC-DC Step-up Boost Converter Dual Output Power Supply

Attach the little board to the back screw hole of the original power supply. Do
not crank this down, just snug it. The screw is insolated so it doesn't short
out the little board. The image below shows what this looks like (when the mod
is complete). Reminder, do not crank the screw, just snug it so the board
doesn't flop around.

!["CoCo 2 Rev B Attach DC to DC board"](../etc/images/coco2_rev_b_dc_to_dc.jpg?raw=true "CoCo 2 Rev B Attach DC to DC board")

This little board is how the SALT is powered. Experiments have shown that ±9V
works fine rather than the unregulated ±12V the machine gets out of the bridge
rectifier. The initial mods use ±9V. The current (amps) is extremely low
because this is only used for the bit banger (serial) and cassette input
zero-volt-crossing detection capabilties on the motherboard.

#### Attach the ground plug

Take on the black wire plug and push it onto the ground attachment, E1, used by
the transformer. E1 is a single little post toward the front-left of the
machine on the motherboard as shown in the picture below.

!["CoCo 2 Rev B Attach the Ground Plug"](../etc/images/coco2_rev_b_ground.jpg?raw=true "CoCo 2 Rev B Attach the Ground Plug")

Now all you have to do is solder several attachments to the motherboard. The
diagram at the top of this section is useful to reference what we are doing.

####  Solder the 5V DC wires

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

####  Solder the ±9V DC wires to the DC side of the bridge rectifier

* Solder the blue wire (-9V DC) to the side of CR1 or CR2 toward the front of
  the machine.
* Solder the yellow wire (9V DC) to the side of CR3 or CR4 toward the back of
  the machine

These connections are shown in the image below. A closeup of the 5V DC
connection to C28 is also shown.

!["CoCo 2 Rev B Solder SALT Power"](../etc/images/coco2_rev_b_salt_power.jpg?raw=true "CoCo 2 Rev B Solder SALT Power")

The permanent mod is complete.

### Finishing up

Its a good idea to pull at all the solder connections to be sure they are solid
and test connections with a multimeter (beep test). Before you screw on the
top, power up the machine and make sure everything works okay. The heat sink Q1
was inside of won't heat up so if your keyboard fits you don't need to bend it
back like it was (just hand bend it so your keyboard fits in okay).
