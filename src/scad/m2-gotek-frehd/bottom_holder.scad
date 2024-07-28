$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Bottom screw hole (is 2.5mm in disk plate)
bscrew_radius = 2.3;

difference() {
  union() {
  cube([16, 75, tw*2 + 1]);
  translate([8, 3 + bscrew_radius, -9]) cylinder(h=10, r=bscrew_radius);
  }
  translate([8, 3 + bscrew_radius + 35, 1]) cylinder(h=tw*3, r=5.1);
  translate ([10,3,3]) rotate([0, 0, 90]) linear_extrude(2*tw) text("←front", size=5);
  translate ([10,60,3]) rotate([0, 0, 90]) linear_extrude(2*tw) text("top", size=5);
}