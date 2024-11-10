$fa = 1;
$fs = 0.5;
$fn = 200;

difference() {
  union() {
    cylinder(h=6, r=3.5);
    translate([-3.5,0,0]) cube([7,6,6]);
  }
  // bottom and top slice
  rotate([12,0,0]) translate([-5,0,-5]) cube([10,10,5]);
  translate([-5,0,6]) rotate([-12,0,0]) cube([10,10,5]);
  // right and left slice
  translate([-8.5,1.03,0]) rotate(a=-12,v=[0,0,1]) cube([5,10,10]);
  translate([3.5,0,0]) rotate(a=12,v=[0,0,1]) cube([5,10,10]);
  // post hole
  translate([-3.5/2,-3.7,(6-1.5)/2]) cube([3.5,5.7,1.5]);
}