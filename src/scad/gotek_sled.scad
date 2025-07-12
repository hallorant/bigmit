$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 3; // thickness of any walls
sled_length = 95;
sled_width = 60;
mount_radius = 4;
mount_height = 7;
screw_radius = 1.5;
pin_radius = 1.45;
rhs_offset = 5.5;
lhs_offset = 55.5;
nb = 0.6;
sled_mount_hole_height = 10;

difference() {
  union() {
    cube([sled_length, sled_width, tw]);
    translate([0,-5,0]) cube([sled_length, 5, 13]);
    translate([0,sled_width,0]) cube([sled_length, 5, 13]);
    // right side
    translate([17+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([67+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([88+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([88+nb, rhs_offset, 0]) cylinder(h=mount_height+2, r=pin_radius);
    // left side
    translate([67+nb, lhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([88+nb, lhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([88+nb, lhs_offset, 0]) cylinder(h=mount_height+2, r=pin_radius);
  }
  // right side screw holes
  translate([17+nb, rhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  translate([67+nb, rhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  // left side screw holes
  translate([67+nb, lhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  // sled right side mounting holes
  translate([20,1,sled_mount_hole_height])
    rotate([90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  translate([75,1,sled_mount_hole_height])
    rotate([90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  // sled left side mounting holes
  translate([20,sled_width-1,sled_mount_hole_height])
    rotate([-90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  translate([75,sled_width-1,sled_mount_hole_height])
    rotate([-90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  // lightners
  translate([7.5,12.5,-1]) cube([80,35,tw+2]);
}
