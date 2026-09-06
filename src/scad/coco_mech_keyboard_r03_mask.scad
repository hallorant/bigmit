$fa = 1;
$fs = 0.5;
$fn = 50;

///////////////////////////////////
// CoCo Mech CUTOUT MASK (Rev 3) //
///////////////////////////////////
width = 293;
height = 120;
depth = 1; // original is 11mm
co_depth = depth + 2;
screw_radius = 2.9/2;

module mask() {
  difference() {
    union() {
      difference() {
        // MAIN SHAPE
        cube([width,height,depth]);
        // CUTOUT CUBES
        translate([0,0,-1]) { // nudge below
          // main cutout
          translate([18,10,0]) cube([266,97,co_depth]);
          // left-hand-side extra cutouts
          translate([8,66.5,0]) cube([25,21,co_depth]);
          translate([13,48,0]) cube([20,25,co_depth]);
          // connector small cutout (on back)
          translate([135,height-17,0]) cube([23,10,4]);
        }
      }
      // ADD-BACK CUBES
      // (bottom)
      translate([0,0,0]) cube([77.5,29,depth]);
      translate([196,0,0]) cube([47,29,depth]);
      // (right-side)
      translate([width-18,31,0]) cube([18,17,depth]);
      translate([width-18,69,0]) cube([18,17,depth]);
      // (top)
      translate([width-29.5-17,height-32,0]) cube([17,32,depth]);
    }
    // CUTOUT SCREW HOLES
    translate([0,0,4]) {
      // from-back-right-side-bottom-to-top
      translate([3,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([3,30.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([3,58,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([3,85.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([3,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      // from-back-bottom-right-to-middle (first is above)
      translate([39,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([74.5,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([110.5,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([146.5,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      // from-back-top-right-to-middle (first is above)
      translate([39,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([75,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([110.5,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      // from-back odd screw up a bit at right
      translate([65,23,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      
      // from-back-left-side-bottom-to-top
      translate([width-3,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-3,31,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-3,58.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-3,85.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-3,113,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      // from-back-bottom-left-to-middle (first is above, middle is above)
      translate([width-39,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-75,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-111,3.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      // from-back-top-right-to-middle (first is above)
      translate([width-39,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-75,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      translate([width-111,112.5,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
      // from-back odd screw up a bit at left
      translate([width-75,23,0]) #cylinder(h=10, r1=screw_radius, r2=screw_radius, center=true);
    }
  }
}

difference() {
  mask();
  //translate([-1,-1,-1]) #cube([90,140,5]);
  //translate([-1+90,-1,-1]) #cube([1150,140,5]);
}