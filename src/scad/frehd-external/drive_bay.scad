$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls
total_width = 105;


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
translate([0, 0, 35]) cube([total_width, 90, tw]);

// Bottom
difference() {
  cube([total_width, 90, tw]);
  translate([8,10,-1]) cylinder(h=tw,r=5);
  translate([98,10,-1]) cylinder(h=tw,r=5);
  translate([8,80,-1]) cylinder(h=tw,r=5);
  translate([98,80,-1]) cylinder(h=tw,r=5);
}

// Side supports
module side() {
  difference() {
    translate([0,0,0]) cube([tw,90,36.5]);
    // FreHD4Eight screw holes
    translate ([-1,tw+0.1+15,2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,tw+0.1+55,2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
}
translate([0, 0, 0]) side();
translate([total_width, 0, 0]) side();
