$fa = 1;
$fs = 0.5;
$fn = 50;

include <threads.scad>

baseSq=10;
backSq=6.8;
baseCr=3.4;

difference() {
  union() {
    translate([-(baseSq/2),-(baseSq/2),0]) cube([baseSq,baseSq,3]);
    translate([-(backSq/2),-(backSq/2),0]) cube([backSq,backSq,4]);
    cylinder(h=10, r=baseCr);
    
  }
  translate([0,0,3]) ScrewThread(4.4, 12);
}

translate([10,10,0]) MetricBolt(4,4.5);

translate([20,0,0]) {
  difference() {
    cylinder(h=6,r=5);
    translate([0,0,-0.5]) cylinder(h=7, r=baseCr+0.3);
  }
}