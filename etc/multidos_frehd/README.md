# MULTIDOS for the FreHD

I worked in late 2021 and 2022 with Vernon Hester, George Phillips, and Ian
Mavrick to get MULTIDOS support on the FreHD. Vernon did the heavy lifting as
the OS author and maintainer. George helped with trs80gp support and autoboot
help.  Ian helped us fix FreHDs and sent parts to us as we broke thinks.

## Details

* [frehd_utils](./frehd_utils) &ndash; This is the FreHD utilies: export2,
  import2, and vhdutil. Ported by me to Vernon's MULTIDOS. You use the
  Makefile_multidos to build the utilties that are included on the hard disk
  images. I never got fupdate to work (so beware and perhaps use LDOS for this
  or pull the PIC and use a ROM burner). Note this directory captures the
  source code used, it is not really needed for MULTIDOS FreHD. The working
  utilities already on the FreHD disk images. I've captured all the assembly
  from [Fredric Vecoven's github](https://github.com/veco/FreHDv1/tree/main/sw/z80/utils)
  site in late 2021. If you work on this code please note the patch file for
  changes to some of the non-MULTIDOS files. There were bugs in the utilties
  on Fred's side that I fixed.
