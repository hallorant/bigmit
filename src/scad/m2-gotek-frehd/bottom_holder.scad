$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Bottom screw hole (is 2.5mm in disk plate)
bscrew_radius = 2.4;

difference() {
  union() {
  cube([16, 75, tw*2 + 1]);
  translate([8, 3 + bscrew_radius, -6])
    cylinder(h=7, r=bscrew_radius);
  }
  translate([8, 3 + bscrew_radius + 35, 1])
    cylinder(h=tw*3, r=5);
}