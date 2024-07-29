$fa = 1;
$fs = 0.5;
$fn = 50;

post_h = 32;

difference() {
  union() {
    cube([35,84,6]);
    // together side posts
    translate([7, 5, 1]) cylinder(h=post_h, r=1);
    translate([29, 5, 1]) cylinder(h=post_h, r=1);
    // not together side posts
    translate([7, 78.55, 1]) cylinder(h=post_h, r=1);
    translate([29, 58, 1]) cylinder(h=post_h, r=1);
  }
  // magnetic holes
  translate([17.45, 15, 1]) cylinder(h=10, r=5.1);
  translate([17.45, 84-15, 1]) cylinder(h=10, r=5.1);
}