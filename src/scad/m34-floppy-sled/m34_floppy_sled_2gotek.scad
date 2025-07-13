$fa = 1;
$fs = 0.5;
$fn = 50;

// GOTEK //

tw = 1.5; // thickness of walls
gotek_height = 38;
gotek_width = 73;
gotek_depth = 85;
gotek_rail_depth = 60;

module gotek(drive_num="") {
  gotek_faceplate(drive_num);
  translate([(gotek_width-70)/2-tw,0,0])          gotek_side(); // left from front
  translate([gotek_width-(gotek_width-70)/2,0,0]) gotek_side(); // right from front
  translate([(gotek_width-70)/2,0, gotek_height]) gotek_floor(); // top
  translate([(gotek_width-70)/2,0,0])             gotek_floor(); // bottom
}


module gotek_faceplate(drive_num) {
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
      translate ([18,0.75,11.5]) rotate([90, 0, 0]) linear_extrude(2*tw) text(drive_num, size=7);
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

// GOTEK //

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
      cube([thk*2,30,shelf_dp-22]);
      rotate([0,90,0]) linear_extrude(thk*2) polygon(points=[[0,0],[-70,0],[0,front_ht]]);
    }
    translate([-1,22,53]) rotate([0,90,0]) cylinder(h=4*thk,r=2);
    translate([-1,22,132]) rotate([0,90,0]) cylinder(h=4*thk,r=2);
    // Screwdriver hole
    translate([-1,18,22]) rotate([0,90,0]) cylinder(h=4*thk,r=5);
  }
}

union() {
  // FRONT PLATE
  difference() {
    cube([front_wd,front_ht,thk]); // front
    translate([40,6,-1]) cube([65,38*2,thk+2]);
  }
  gotek_height = front_ht/2-38;
  translate([gotek_width/2+front_wd/2,gotek_height,0]) rotate([90,0,180])
    gotek(drive_num="0");
    translate([gotek_width/2+front_wd/2,gotek_height+38,0]) rotate([90,0,180])
    gotek(drive_num="1");
  translate([38.5,1,1]) cube([tw,10,40]);
  translate([38.5+gotek_width-tw,1,1]) cube([tw,10,40]);
  
  translate([0,front_ht-2*thk,0]) cube([front_wd,2*thk,2*thk]); // top strengther
  translate([0,0,0]) cube([2*thk,front_ht,2*thk]); // side strengther
  translate([front_wd-2*thk,0,0]) cube([2*thk,front_ht,2*thk]); // side strengther
  // SHELF
  translate([shelf_inset,0,0]) cube([shelf_wd,thk,shelf_dp-22]); // bottom
  translate([shelf_inset,0,0]) side(); // side
  translate([front_wd-thk*2-shelf_inset,0,0]) side(); // side
}