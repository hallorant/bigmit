$fa = 1;
$fs = 0.5;
$fn = 50;

thk=1.5;

module frehd() {
  tw = 1.5; // thickness of any walls
  total_width = 105;
  total_depth = 70;


  difference() {
    // Faceplate
   cube([total_width, tw, 35]);

    // FreHD
    translate([14 + tw, -1, 8 + tw]) {
      // sd card hole
      translate([-1,0,0.5]) cube([30,10,3.5]);
    }
    for (xpos=[36:2:80]) { // grill to see leds
      translate([- 5 + (total_width/2) - 36.5 + xpos, -1, 9.5])
        cube([1,2*tw,18]);
    }
  }

  // Top
  translate([0, 0, 35]) cube([total_width, total_depth, tw]);

  // Bottom
  cube([total_width, total_depth, tw]);

  // Side supports
  module side() {
    difference() {
      translate([0,0,0]) cube([tw,total_depth,36.5]);
      // FreHD4Eight screw holes
      translate ([-1,tw+0.1+15,2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
      translate ([-1,tw+0.1+55,2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    }
  }
  translate([0, 0, 0]) side();
  translate([total_width, 0, 0]) side();
}

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
    // Screwdriver hole
    translate([-1,39,17]) rotate([0,90,0]) cylinder(h=4*thk,r=5);
  }
}

union() {
  // FRONT PLATE
  difference() {
    union() {
      cube([front_wd,front_ht,thk]); // front plate
      translate([33,59,thk-0.4]) cube([15,17,thk]); // SWITCH support
    }
    translate([25,23,-1]) cube([100,35,2*thk]); // cutout for frehd plate
    // SWITCH cutout
    translate([33+7.5,60+7.5,-1]) {
      cylinder(h=10,r=3.1);
      translate([-1.1,0,2.3]) cube([2.2,8,2]);
    }
  }
  translate([front_wd-22,23,0]) rotate([90,0,180]) frehd();
  translate([25,1,0]) cube([thk,23,60]);
  translate([123,1,0]) cube([thk,23,60]);
  
  translate([0,front_ht-2*thk,0]) cube([front_wd,2*thk,2*thk]); // top strengther
  translate([0,0,0]) cube([2*thk,front_ht,2*thk]); // side strengther
  translate([front_wd-2*thk,0,0]) cube([2*thk,front_ht,2*thk]); // side strengther
  // SHELF
  translate([shelf_inset,0,0]) cube([shelf_wd,thk,shelf_dp]); // bottom
  translate([shelf_inset,0,0]) side(); // side
  translate([front_wd-thk*2-shelf_inset,0,0]) side(); // side
}