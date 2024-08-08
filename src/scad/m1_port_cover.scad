$fa = 1;
$fs = 0.5;
$fn = 50;

module support_holder() {
  cube([4,1,7]);
  translate([-0.25,0,1]) linear_extrude(6) 
      polygon(points=[[1.5,-1],[3,-1],[3,2],[3.5,5],[1,5],[1.5,2]]);
}

module dinn_hole(x,y=4) {
  din_radius=8.5;
  translate([x+din_radius,y+din_radius,-1]) cylinder(h=5, r=din_radius);
}

difference() {
  union() {
    cube([100,25,1]);
    // Frame
    cube([98,1,4]);
    cube([1,23,4]);
    translate([98,0,0]) cube([1,23,4]);
    // side supports (from back)
    // right
    translate([1,22,0]) cube([2,1,7]);
    // middle right
    translate([40,22,0]) support_holder();
    // middle left
    translate([68,22,0]) support_holder();
    // left
    translate([96,22,0])
      difference() {
        cube([2,1,7]);
        translate([1.5,-0.5,5]) cube([1,2,2]);
      }
    // cross support
    translate([39.5,0,1]) cube([5,23,1]);
    translate([67.5,0,1]) cube([5,23,4.5]);
    translate([95,0,1]) cube([3,23,1]);
    translate([0,0,1]) cube([15,23,1]);
  }
  // Power switch hole
  translate([9,25-8,-1]) cylinder(h=5, r=5);
  // din power hole
  dinn_hole(19);
  // din power hole
  dinn_hole(47);
  // din power hole
  dinn_hole(75);
  
  // ROM switch hole
  translate([68,7.5,-1]) union() {
    cube([4,10,5]);
    translate([1.5,0,0]) cube([1,10,10]);
  }
  
  // text
  translate([12,8,0.5]) rotate([180,0,180]) linear_extrude(2) text("ON", size=3);
  translate([35.5,0.7,0.5]) rotate([180,0,180]) linear_extrude(2) text("POWER", size=3);
  translate([61.5,0.7,0.5]) rotate([180,0,180]) linear_extrude(2) text("VIDEO", size=3);
  translate([89,0.7,0.5]) rotate([180,0,180]) linear_extrude(2) text("TAPE", size=3);
  
  translate([73,3,0.5]) rotate([180,0,180]) linear_extrude(2) text("R/S", size=3);
  translate([75,19,0.5]) rotate([180,0,180]) linear_extrude(2) text("FreHD", size=3);
}