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

### Identification (so many CoCo 2s is mine a Rev B?)
Outside, this has the tall tuner with the channel selector above the video
output connection. But you want to open up your CoCo 2 and look at the left
side of the motherboard (just below the transformer). If you have a Rev B
you'll see an identification as shown in the picture below.

!["CoCo 2 Rev B Motherboard Identification](../etc/images/coco2_rev_b_board_id.jpg?raw=true "CoCo 2 Rev B Motherboard Identification")

### How to spot an incompatible modification

Your whole CoCo will run under DC power, however modifications exist that use
AC power. Especially the (unregulated) 12VAC entering the bridge rectifier.
This is easy to spot, however, and you can decide to continue or not based on
your need for the AC-using modification.

Look for any wires attached to the AC side of the bridge rectifier. If we
consider "top" as toward the back of the machine. Look for any wire attached to
the top of CR1 or CR2 or any wire attached to the bottom of CR3 or CR4. The
image below has the USB mod installed, but it circles the AC side of the bridge
rectifier. If any mod to your CoCo is attached here the USB mod is incompatible
with it.

!["CoCo 2 Rev B Incompatible Mods](../etc/images/coco2_rev_b_incompatible_mods.jpg?raw=true "CoCo 2 Rev B Incompatible Mods")

The only incompatible mod I am aware of for the Rev B CoCo 2 is a composite
video modification. It attaches to the bottom of CR3 or CR4. Beware, there may
be others! Check your Coco.

### Trying out the USB mod with the tryout cable
