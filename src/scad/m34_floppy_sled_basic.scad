$fa = 1;
$fs = 0.5;
$fn = 50;

thk=1.5;

module side() {
  difference() {
    union() {
      cube([thk,30,160]);
      rotate([0,90,0]) linear_extrude(thk) polygon(points=[[0,0],[-60,0],[0,84]]);;
    }
    translate([-1,22,53]) rotate([0,90,0]) cylinder(h=2*thk,r=2);
    translate([-1,22,132]) rotate([0,90,0]) cylinder(h=2*thk,r=2);
  }
}

union() {
  cube([150,85,thk]); // front
  cube([150,thk,160]); // bottom
  side(); translate([150-thk,0,0]) side(); // sides
}