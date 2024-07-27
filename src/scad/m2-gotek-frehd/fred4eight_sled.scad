$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 3; // thickness of any walls
sled_length = 80;
sled_width = 97;
mount_height = 7;
mount_radius = 4;
screw_radius = 1.5;
pin_radius = 1.45;
rhs_offset = 4;
lhs_offset = sled_width - rhs_offset;
nb = 0.1;
sled_mount_hole_height = 10;

difference() {
  union() {
    cube([sled_length, sled_width, tw]);
    translate([0,-tw,0]) cube([sled_length, tw, 13]);
    translate([0,sled_width,0]) cube([sled_length, tw, 13]);
    // right side
    translate([5+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([73.5+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    // left side
    translate([5+nb, lhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([73.5+nb, lhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
  }
  // right side screw holes
  translate([5+nb, rhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  translate([73.5+nb, rhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  // left side screw holes
  translate([5+nb, lhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  translate([73.5+nb, lhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  // sled right side mounting holes
  translate([20,1,sled_mount_hole_height])
    rotate([90, 0, 0]) cylinder(h=7, r=screw_radius);
  translate([75,1,sled_mount_hole_height])
    rotate([90, 0, 0]) cylinder(h=7, r=screw_radius);
  // sled left side mounting holes
  translate([20,sled_width-1,sled_mount_hole_height])
    rotate([-90, 0, 0]) cylinder(h=7, r=screw_radius);
  translate([75,sled_width-1,sled_mount_hole_height])
    rotate([-90, 0, 0]) cylinder(h=7, r=screw_radius);
  // lightners
  translate([10,15,-1]) cube([60,sled_width-30,tw+2]);
}