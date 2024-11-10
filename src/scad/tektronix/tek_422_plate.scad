$fa = 1;
$fs = 0.5;
$fn = 200;

difference() {
  cube([90,77,10]);
  translate([90/2,77/2,-0.1])
    linear_extrude(height=12,convexity=10,scale=0.92)
      square([90-2,77-6],center=true);
}