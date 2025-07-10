// A template of a single Gotek drive slot -- include in other designs.
$fa = 1;
$fs = 0.5;
$fn = 50;

tw = 1.5; // thickness of walls
gotek_height = 38;
gotek_width = 73;
gotek_depth = 85;
gotek_rail_depth = 60;

module gotek() {
  gotek_faceplate();
  translate([(gotek_width-70)/2-tw,0,0])          gotek_side(); // left from front
  translate([gotek_width-(gotek_width-70)/2,0,0]) gotek_side(); // right from front
  translate([(gotek_width-70)/2,0, gotek_height]) gotek_floor(); // top
  translate([(gotek_width-70)/2,0,0])             gotek_floor(); // bottom
}


module gotek_faceplate() {
  gotek_button_radius = 2.25;
  magnet_hole_radius = 4.05;
  led_radius = 1.8;
  rail_height = 33-4.25;
  difference() {
    union() {
      // faceplate
      cube([gotek_width,tw,gotek_height]);
      translate([(gotek_width-70)/2,0,0]) {
        translate([18-6,0,20]) cube([39,5.5,tw]);
        translate([18-6,0,20+12.5+tw]) cube([39,5.5,1]);
        translate([0,0,rail_height]) cube([2,gotek_rail_depth,2]);
        translate([0,5+6,rail_height-3]) rotate([0,0,6]) cube([.5,4,8]);
        translate([18-6-tw-11,0,20]) cube([tw+11,5.5,12+2*tw]);
        translate([gotek_width-3*tw,0,rail_height]) cube([2,gotek_rail_depth,2]);
        translate([gotek_width-2*tw-0.5,5+6,rail_height-3]) rotate([0,0,-6]) cube([.5,4,8]);
        translate([18-6+39,0,20]) union() {
            translate([-0.6,0,0]) cube([tw,5.5,12+2*tw]);
            translate([0,0,4]) cube([20,5.5,11]);
          }
      }
    }
    // cutouts
    translate([(gotek_width - 70)/2, 0, 0]) {
      translate ([59.5,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
      translate ([51.5,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
      translate ([59.5,tw+1,21]) rotate([90,0,0])   cylinder(h=tw*2,r=led_radius);
      translate ([26.5,-1,9.5]) cube([16,tw*2,9]);  // usb slot
      translate ([18,-1,23.5]) cube([25,tw*2,9.5]); // oled slot
      translate ([18,0.75,11.5]) rotate([90, 0, 0]) linear_extrude(2*tw) text("#", size=7);
    }
  }
}

module gotek_side() {
    difference() {
    cube([tw,gotek_depth,gotek_height+tw]);
    // screw holes
    translate ([-1,22,10.5+tw]) rotate([0,90,0])   cylinder(h=tw*2,r=1.6);
    translate ([-1,76.6,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
}

module gotek_floor() {
  difference() {
    cube([70,gotek_depth,tw]);
    translate([10,5,-1]) cube([50,95,2*tw]);
  }
}





gotek();
