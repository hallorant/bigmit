$fa = 1;
$fs = 0.5;
$fn = 50;

///////////////////////////////////
// CoCo Mech CUTOUT MASK (Rev 3) //
///////////////////////////////////
width = 294;
height = 120;
depth = 11; // original is 11mm
co_depth = depth + 2;
screw_radius = 2.9/2;
h_skip = 36;
v_skip= 27.5;

module mask() {
  difference() {
    union() {
      difference() {
        // MAIN SHAPE
        cube([width,height,depth]);
        // CUTOUT CUBES
        translate([0,0,-1]) { // nudge below
          // main cutout
          translate([18,10,0]) cube([width-18-8.5,height-10-13,co_depth]);
          // left-hand-side extra cutouts
          translate([8,68,0]) cube([25,21,co_depth]);
          translate([13,48,0]) cube([20,25,co_depth]);
          // connector small cutout (on back)
          translate([135.5,height-17,0]) cube([23,10,4]);
        }
      }
      // ADD-BACK CUBES
      // (bottom)
      translate([0,0,0]) cube([77.5,29,depth]);
      translate([width-95,0,0]) cube([47,29,depth]);
      // (right-side)
      translate([width-18,31.5,0]) cube([18,17,depth]);
      translate([width-18,69.5,0]) cube([18,17,depth]);
      // (top)
      translate([width-29-17,height-31.5,0]) cube([17,31.5,depth]);
    }
    // CUTOUT SCREW HOLES
    translate([0,0,4]) {
      // Bottom row screw holes
      for (x = [3:h_skip:293]) {
        translate([x,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      }
      // Left column screw holes (top and bottom are in rows)
      for (y = [3.5+v_skip:v_skip:height-v_skip]) {
        translate([3,y,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      }
      // Top row screw holes (middle is skipped)
      for (x = [3:h_skip:293]) {
        if (x!=3+4*h_skip) translate([x,3.5+4*v_skip,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      }
      // Right column screw holes (top and bottom are in rows)
      for (y = [3.5+v_skip:v_skip:height-v_skip]) {
        translate([3+8*h_skip,y,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      }
      
      // from-back odd screw up a bit at right
      translate([65,23.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      
      // from-back odd screw up a bit at left
      translate([3+6*h_skip,23.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
    }
  }
}

difference() {
  rotate([180,0,0])
    mask();
  //translate([0,-100,-15]) #cube([300,115,50]);
  //translate([50,-130,-15]) #cube([300,115,50]);
  //translate([-1,30,-1]) #cube([300,115,5]);
  //translate([-1,-1,-1]) #cube([240,140,5]);
  //translate([-1+23,-1,-1]) #cube([1150,140,5]);
}