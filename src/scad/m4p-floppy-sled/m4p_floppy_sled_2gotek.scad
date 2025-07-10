$fa = 1;
$fs = 0.5;
$fn = 50;

thk=1.5;

///// GOTEK /////



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

///// GOTEK /////


face_wd = 82;
face_ht = 146;

gotek_hole_wd = 73;
gotek_hole_ht = 77;

sled_depth = 135;
dhole_depth = 95;

module face_plate() {
  difference() {
    translate([-3,0,0]) cube([face_wd+6,face_ht,thk]);
    translate([(face_wd-gotek_hole_wd)/2,(face_ht-gotek_hole_ht)/2,-1])
      cube([gotek_hole_wd,gotek_hole_ht,thk*2]);
  }
}

module side_plate() {
  cube([2*thk,face_ht,7]);
}

module sled_support() {
  cube([thk,35,dhole_depth/2]);
  translate([0,face_ht-38,0]) cube([thk,36,dhole_depth/2]);
}

module sled_holes_one_drive() {
  translate([11.5,thk,48]) rotate([90,0,0]) cylinder(h=4*thk,r=2,center=true);
  translate([11.5,thk,127.5]) rotate([90,0,0]) cylinder(h=4*thk,r=2,center=true);
}

module sled_holes() {
  sled_holes_one_drive();
  translate([41.5,0,0]) sled_holes_one_drive();
}
  

module top() {
  difference() {
    cube([face_wd,2*thk,sled_depth]);
    sled_holes();
  }
}

module bottom() {
  difference() {
    cube([face_wd,2*thk,dhole_depth]);
    translate([-1,0,0])sled_holes();
  }
}
  

union() {
  face_plate();
  gotek_off_y = 34.25;
  translate([77.5,gotek_off_y,0]) rotate([-90,180,0]) gotek("0");
  translate([77.5,gotek_off_y+38,0]) rotate([-90,180,0]) gotek("1");
  // top and bottom
  bottom();
  translate([0,face_ht-2*thk,0]) top();
  // side support
  side_plate();
  translate([face_wd-2*thk,0,0]) side_plate();
  // sled support attaches sled to top and bottom
  translate([4.5,0,0]) sled_support();
  translate([face_wd-4.5-thk,0,0]) sled_support();
}