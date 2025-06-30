$fa = 1;
$fs = 0.5;
$fn = 50;

module hole() {
  rotate([-90,0,0]) cylinder(h=16,r=2);
  translate([0,3+3.5,0]) rotate([-90,0,0]) cylinder(h=10,r=3.5);
}

difference() {
  translate([0,0,-5]) linear_extrude(10) {
    polygon(points=[[-4,0],[4,0],[5,6],
      [40,6],[41,0],[49,0],
      [48,10],[-3,10]]);
  }
  translate([0,-3,0]) hole();
  translate([45,-3,0]) hole();
}