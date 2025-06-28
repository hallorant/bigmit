$fa = 1;
$fs = 0.5;
$fn = 50;

thk=1.5;

// Front plate sizes
front_wd=150;
front_ht=87;
// Shelf sizes
shelf_wd=146;
shelf_dp=160;
shelf_inset=(front_wd-shelf_wd)/2;

module side() {
  difference() {
    union() {
      cube([thk*2,30,shelf_dp]);
      rotate([0,90,0]) linear_extrude(thk*2) polygon(points=[[0,0],[-60,0],[0,front_ht]]);
    }
    translate([-1,22,53]) rotate([0,90,0]) cylinder(h=4*thk,r=2);
    translate([-1,22,132]) rotate([0,90,0]) cylinder(h=4*thk,r=2);
  }
}

union() {
  // FRONT PLATE
  cube([front_wd,front_ht,thk]); // front
  
  translate([0,front_ht-2*thk,0]) cube([front_wd,2*thk,2*thk]); // top strengther
  translate([0,0,0]) cube([2*thk,front_ht,2*thk]); // side strengther
  translate([front_wd-2*thk,0,0]) cube([2*thk,front_ht,2*thk]); // side strengther
  // SHELF
  translate([shelf_inset,0,0]) cube([shelf_wd,thk,shelf_dp]); // bottom
  translate([shelf_inset,0,0]) side(); // side
  translate([front_wd-thk*2-shelf_inset,0,0]) side(); // side
}