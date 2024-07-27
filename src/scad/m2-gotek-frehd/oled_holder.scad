$fa = 1;
$fs = 0.5;
$fn = 50;
difference() {
  union() {
  translate([0,-2,-5]) cube([70,2,10]);
    cube([70,17,5]);
  }
  // Room for dip connector
  translate([14,0,-1]) cube([5,20,10]);
  // Room for usb
  translate([50,10,-1]) cube([30,20,10]);
  // magnet holes
  translate([6,4,1.8]) rotate([0,0,0]) cylinder(h=5,r=4);
  translate([55,4,1.8]) rotate([0,0,0]) cylinder(h=5,r=4);
  
}