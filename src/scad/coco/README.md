# TRS-80 Color Computer (CoCo) 3d-printed Cases

This directory contains [OpenSCAD](https://openscad.org/) designs for
3d-printed cartridges for Ian Mavrick's modern replacements. This includes the
CoCo Diagnostic cartridge, the CoCo RS-232 cartridge, and the FD-501 CoCo
floppy disk controller cartridge.

These are all remixes for [fiscap](https://www.thingiverse.com/fiscap) which
was called the [TRS-80 Color Computer RE-FD-502
Case](https://www.thingiverse.com/thing:5470278).

In some ways mine are actually worse than what fiscap did for the FD-501. The
fiscap design is really nice but I found it hard to 3d-print. the changes I've
made are

* I made the top and bottom flat (removing the indent) so it would print with
  better quality. Simply lay the tops and bottoms on the printer deck, with the
  sides going up. This should print well even on cheap printers.
* For the FD-510 the floppy opening was pretty tight I made it larger (should
  fit most cables now).
* Added a design for Ian's RS-232 pack.
* Added a design for Ian's Diagnostics cartridge.

Note: to use these you need to open OpenSCAD and load the source files and then
render to export STL for your 3d-printer.

## Files

| File | Description |
|------|-------------|
| FD502_bottom.stl | fiscap's STL case bottom. |
| FD502_top.stl | fiscap's STL case top. |
| coco-diag-bottom.scad | Diagnostic cartridge bottom. |
| coco-diag-top.scad | Diagnostic cartridge top. |
| coco-fd501-bottom.scad | FD-510 Floppy controller cartridge bottom. |
| coco-fd501-top.scad | FD-510 Floppy controller cartridge top. |
| coco-rs232-bottom.scad | RS-232 Pack cartridge bottom. |
| coco-rs232-bottom-noholes.scad | RS-232 Pack cartridge bottom. Useful for the older version of the cartridge that didn't have four mounting holes |
| coco-rs232-top.scad | RS-232 Pack cartridge top. |
