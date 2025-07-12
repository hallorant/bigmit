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
nb = 0;
sled_mount_hole_height = 14;
front_back=4.3;
back_back=73.9;

difference() {
  union() {
    cube([sled_length, sled_width, tw]);
    translate([0,-tw,0]) cube([sled_length, tw, 18]);
    translate([0,sled_width,0]) cube([sled_length, tw, 18]);
    // right side
    translate([front_back+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([back_back+nb, rhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    // left side
    translate([front_back+nb, lhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
    translate([back_back+nb, lhs_offset, 0]) cylinder(h=mount_height, r=mount_radius);
  }
  // right side screw holes
  translate([front_back+nb, rhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  translate([back_back+nb, rhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  // left side screw holes
  translate([front_back+nb, lhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  translate([back_back+nb, lhs_offset, -1]) cylinder(h=mount_height+2, r=screw_radius);
  // sled right side mounting holes
  translate([15,1,sled_mount_hole_height])
    rotate([90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  translate([55,1,sled_mount_hole_height])
    rotate([90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  // sled left side mounting holes
  translate([15,sled_width-1,sled_mount_hole_height])
    rotate([-90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  translate([55,sled_width-1,sled_mount_hole_height])
    rotate([-90, 0, 0]) cylinder(h=7, r=screw_radius-0.2);
  // lightners
  translate([10,15,-1]) cube([60,sled_width-30,tw+2]);
  translate ([6,34,2]) rotate([0, 0, 90]) linear_extrude(2*tw) text("FreHD (front)", size=4);
}
