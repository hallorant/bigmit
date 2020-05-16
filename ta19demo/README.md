# Tandy Assembly 2019 VBLANK Modification Exhibit with George Phillips

This directory contains all the z80 assembly code from my Tandy Assembly 2019
VBLANK Modification Exhibit Raycaster demo. As well as some pictures of
conference.

I exhibited at [Tandy Assembly 2019](http://www.tandyassembly.com/2019/) with
George Phillips the *Model I no-chip VBLANK Modification*.  This was a
demonstration of a no-chip hardware modification to the TRS-80 Model 1 which
allows visibility to the start or end of VBLANK. VBLANK detection allows for
graphics without interference or tear as well as up to 192 pixel vertical
resolution. The Model I could have shipped with this at absolutely no extra
manufacturing cost. The Modification was created by me (Tim Halloran) from
ideas by George Phillips. With a special thanks for the motivation to Trash
Talk episode 21.

George thought this mod up in an email thread where I asked him about Trash
Talk episode 21 where using VBLANK was discussed on a Model 1. I figured out
how to implement it on the hardware without adding any chips. George modified
his [Bouncing Ball demo](http://48k.ca/ball.html) to work on a Model 1 with
this modification and sent me cassette files to try on the real hardware. He
also updated the [trs80gp](http://48k.ca/trs80gp.html) with the `-m1_vblank`
flag to emulate this modification. I wrote a primitive raycasting demo. I
barely got my demo running prior to the conference. George helped me a lot and
dug into my code during the conference to speed it up 4x. I made the rookie
mistake of using a lot of 16-bit mathematics on the Model 1 (sloooowwwww).

If you want to run the actual demos on `trs80gp` you can try them out. A real
Model 1 requires the modification to work.

* [Model 1 VBLANK Bouncing Ball](bin/ball1.500.cas?raw=true) Download and run
  using `trs80gp -m1 -m1_vblank m1ball.500.cas`

* [Model 1 VBLANK Raycaster](bin/raycaster.500.cas?raw=true) Download and run
  using `trs80gp -m1 -m1_vblank raycaster.500.cas`

If you want to build the code in this directory use

```zmac --zmac raycaster.asm```

then run it with

```trs80gp -m1 -m1_vblank zout/raycaster.500.cas```

The (few) tests in the [tests](./tests) subdirectory are not
[x80unit](https://github.com/hallorant/bigmit/tree/master/z80unit) this work
predated and, in fact, motivated x80unit development.

# Pictures of the exhibit table

![The Tandy Assembly 2019 Exhibit](bin/ta19_exhibit.jpg?raw=true "The Tandy Assembly 2019 Exhibit")

![Tim's Raycaster](bin/ta19_exhibit_raycaster.jpg?raw=true "Tim's Raycaster")

![George's Bouncing Ball](bin/ta19_exhibit_bouncing_ball.jpg?raw=true "George's Bouncing Ball")

# Tandy Assembly 2019 venue and hotel

A picture of the conference building you can see the hotel in the background.
Tandy Assembly 2019 had been kicked out of the hotel at the last minute and got
to go to the historical building across the street. Also a picture of the hotel
the night before the conference with Mav and Jay.

![The conference building](bin/ta19_venue.jpg?raw=true "The conference building")

![The hotel](bin/ta19_hotel.jpg?raw=true "The hotel")

