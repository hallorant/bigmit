$fa = 1;
$fs = 0.5;
$fn = 50;

difference() {
  union() {
    difference() {
      // main slab
      cube([13,26,2]);
      // Slight cutaway by screwhole
      translate([-0.01,16.01,-0.1]) cube([10,10,0.5]);
    }
    translate([4,15.5,2]) {
      translate([0,0,-0.5]) cube([2,0.5,1.8]);
      translate([0,9,-0.5]) cube([2,0.5,1.8]);
    }
    translate([8-2,17-1,-4]) {
      difference() {
        translate([0.25,0,0.5]) cube([4.5,10,4.5]);
        // Screw cutout
        translate([-1,4.5,-1]) cylinder(8,3,3);
      }
    }
  }
  // snap leg
  translate([-0.5,2.5,1]) cube([14,12.5,2]);
  rotate([37,0,0]) translate([-0.5,0,0.4]) cube([14,12.5,5]);
  // screw hole
  translate([5,20.5,-2]) cylinder(6,1.5,1.5);
  // Skirt for flush screw
  translate([5,20.5,0.3]) cylinder(2,3,1.5);
}