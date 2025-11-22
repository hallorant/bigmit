$fa = 1;
$fs = 0.5;
$fn = 50;

module smaller() {
rotate([90,0,0])
  difference() {
    cylinder(h=5, r=4, center=true);
    cylinder(h=5, r=1.5, center=true);
  }
}

difference() {
  union() {
    import("FD502_bottom.stl");
    translate([60,0.6,66]) cube([10,2,10]);
    // bottom cover
    #translate([105,0.5,35]) cube([10,2.7,70]);
  }
  translate([65.25,18.1,70.5]) rotate([90,0,0]) difference() {
    cylinder(15,7,7);
    translate([0,0,-1]) cylinder(16,4,4);
  }
  translate([108,0,42]) cube([17,10,57]);
  translate([119.5,4.5,41]) rotate([0,90,0])
    linear_extrude(height = 1) text("1", size=5);
}