$fa = 1;
$fs = 0.5;
$fn = 50;

post_h = 32;
post_r = 1.25;

difference() {
    cube([35,84,4]);
    // together side posts
    translate([7, 5, -1]) cylinder(h=post_h, r=post_r);
    translate([29, 5, -1]) cylinder(h=post_h, r=post_r);
    // not together side posts
    translate([7, 78.55, -1]) cylinder(h=post_h, r=post_r);
    translate([29, 58, -1]) cylinder(h=post_h, r=post_r);
}