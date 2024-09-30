$fa = 1;
$fs = 0.5;
$fn = 50;

keyangle=9;
screwr=1.7;

module post() {
  difference() {
    translate([0,0,-2])cylinder(h=22, r=4.3);
    translate([0,0,-2.5]) cylinder(h=21, r=screwr);
    translate([0,0,15]) cylinder(h=6, r=3.5);
  }
}

union() {
  difference() {
    post();
    translate([-6,-6,-5]) rotate([keyangle,0,0]) cube([12,12,5]);
    translate([-5,-5,17]) rotate([keyangle,0,0]) cube([10,10,5]);
  }
  difference() {
    translate([-6,-9,-1]) rotate([keyangle,0,0]) cube([12,19,2]);
    translate([0,0,-2.5]) cylinder(h=21, r=screwr);
  }
}