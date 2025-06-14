$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Disk drive hole (DHOLE)
dhole_width = 73;
dhole_height = 78;
dhole_depth = 130;

dhole_total_width = dhole_width;
dhole_total_height = dhole_height;
dhole_center_x_offset = dhole_total_width/2;

gotek_0_height = 18;
gotek_1_height = 38 + gotek_0_height;
gotek_button_radius = 2.25;
gotek_led_radius = 1.8;
small_magnet_hole_radius = 4.05;

///////////////////////////////
// Disk drive hole faceplate //
///////////////////////////////

difference() {
  union() {
    translate([-dhole_center_x_offset, 0, gotek_0_height])
      cube([dhole_total_width, tw, dhole_total_height]);

    // gotek 0 oled internal frame
    translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_0_height]) {
      translate([18-6,0,20]) cube([39,5,tw]);
      translate([18-6,0,20+12.5+tw]) cube([39,5,1]);
      translate([18-6-tw-11,0,20]) difference() {
        cube([tw+11,5,12+2*tw]);
        translate([6,6,8]) rotate([90,0,0]) cylinder(h=5,r=small_magnet_hole_radius);
      }
      translate([18-6+39,0,20]) difference() {
        union() {
          translate([-0.6,0,0]) cube([tw,5,12+2*tw]);
          translate([0,0,4]) cube([20,5,11]);
        }
        translate([6,6,8]) rotate([90,0,0]) cylinder(h=5,r=small_magnet_hole_radius);
      }
    }
    // gotek 1 oled internal frame
    translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_1_height]) {
      translate([18-6,0,20]) cube([39,5,tw]);
      translate([18-6,0,20+12.5+tw]) cube([39,5,1]);
      translate([18-6-tw-11,0,20]) difference() {
        cube([tw+11,5,12+2*tw]);
        translate([6,6,8]) rotate([90,0,0]) cylinder(h=5,r=small_magnet_hole_radius);
      }
      translate([18-6+39,0,20]) difference() {
        union() {
          translate([-0.6,0,0]) cube([tw,5,12+2*tw]);
          translate([0,0,4]) cube([20,5,11]);
        }
        translate([6,6,8]) rotate([90,0,0]) cylinder(h=5,r=small_magnet_hole_radius);
      }
    }
  }
  
  // gotek 0
  translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_0_height]) {
    translate ([59.5,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([51.5,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([59.5,tw+1,21]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_led_radius);
    translate ([26.5,-1,9.5]) cube([16,tw*2,9]);  // usb slot
    translate ([18,-1,23.5]) cube([25,tw*2,9.5]); // oled slot
    translate ([18,0.75,11.5]) rotate([90, 0, 0]) linear_extrude(2*tw) text("0", size=7);
  }
  // gotek 1
  translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_1_height]) {
    translate ([59.5,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([51.5,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([59.5,tw+1,21]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_led_radius);
    translate ([26.5,-1,9.5]) cube([16,tw*2,9]);  // usb slot
    translate ([18,-1,23.5]) cube([25,tw*2,9.5]); // oled slot
    translate ([18,0.75,11.5]) rotate([90, 0, 0]) linear_extrude(2*tw) text("1", size=7);
  }
}

///////////////////
// 4 Gotek sleds //
///////////////////

translate([-dhole_center_x_offset + (dhole_total_width - 70)/2 - tw, 0, 0])
  difference() {
    translate([0,0,gotek_0_height]) cube([tw, dhole_depth, dhole_height + tw]);
    // gotek 0 screw holes
    translate([0,0,gotek_0_height]) {
      translate ([-1,22,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
      translate ([-1,76.6,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    }
    // gotek 1 screw holes
    translate([0,0,gotek_1_height]) {
      translate ([-1,22,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
      translate ([-1,76.6,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    }
  }
translate([-dhole_center_x_offset + dhole_total_width - (dhole_total_width - 70)/2, 0, 0])
  difference() {
    translate([0,0,gotek_0_height]) cube([tw, dhole_depth, dhole_height + tw]);
    // gotek 0 screw holes
    translate([0,0,gotek_0_height]) {
      translate ([-1,22,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
      translate ([-1,76.6,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    }
    // gotek 1 screw holes
    translate([0,0,gotek_1_height]) {
      translate ([-1,22,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
      translate ([-1,76.6,10.5+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    }
  }
// gotek bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_0_height]) {
  difference() {
   cube([70,dhole_depth,tw]);
   translate([10,10,-1]) cylinder(h=tw,r=5);
   translate([60,10,-1]) cylinder(h=tw,r=5);
   translate([10,dhole_depth-10,-1]) cylinder(h=tw,r=5);
   translate([60,dhole_depth-10,-1]) cylinder(h=tw,r=5);
  }
}
// gotek 1 sled bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_1_height])
  difference() {
    cube([70,95,tw]);
    translate([10,5,-1]) cube([50,95,2*tw]);
  }
// gotek top
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, dhole_height + gotek_0_height]) {
  cube([70,dhole_depth,tw]);
}


