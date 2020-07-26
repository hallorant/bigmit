# CoCoUSB - Running your COCO from a USB powerstrip

This modification can be useful if your power supply is bad. However, my
primary motivation was how hot my CoCo 2 ran. This modification changes your
CoCo from running on AC power to operating on DC power.

The permanent modification requires some hardware skill to accomplish.
Removing the transformer (easy) and the Q1 power transistor (much harder).
However, you can try this out with a simple clip-on cable attached to your CoCo
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
screws. Double check that you do not have the power cable plugged into AC
power. Plug the USB plug into a USB power strip and your CoCo should come on.

This setup has a few limitations.

* The power switch doesn't work (reset does work).
  On/off is accomplished by plugging in (on) and unplugging (off) the USB
  connection.
* The serial connection (bit banger) doesn't work.
* The cassette input doesn't work (output does).

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

!["CoCo 2 Rev B Permanent Modification Diagram"](../etc/images/coco2_rev_b_permanent_usb_diagram.jpg?raw=true "CoCo 2 Rev B Permanent Modification Diagram")
