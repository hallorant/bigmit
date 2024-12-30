$fa = 1;
$fs = 0.5;
$fn = 200;
difference() {
  union() {
    cylinder(28, 12, 10);
    translate([0,0,-3.5]) cylinder(5,4,4);
  }
  translate([0,0,-5]) cylinder(50,2.2,2.2);
  translate([0,0,10]) cylinder(50,4.5,4.5);
}