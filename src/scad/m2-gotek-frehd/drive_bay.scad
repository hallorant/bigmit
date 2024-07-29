$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Disk drive hole (DHOLE)
dhole_width = 87;
dhole_height = 213.5;
dhole_pad_top = 1.5;
dhole_pad_bottom = 1.5;
dhole_pad_right = 10;
dhole_pad_left = 10;

dhole_total_width = dhole_width + dhole_pad_right + dhole_pad_left;
dhole_total_height = dhole_height + dhole_pad_top + dhole_pad_bottom;
dhole_center_x_offset = dhole_total_width/2;

// Metal angled Base (ABASE)
abase_width = 97;
abase_height = 100; // back -- to support
abase_depth = 15; // down -- to support
abase_x_offset_to_dhole = 27;

abase_total_width = abase_width + tw + tw;
abase_total_x_offset_to_dhole = 27 + tw;

// Bottom screw hole
bscrew_radius = 2.5;
bscrew_back_from_dhole = 25.5;
bscrew_x_offset_from_abase_left_edge = abase_total_width - 32;

// Top screw hole
tscrew_radius = 2.5;
tscrew_x_offset_from_left_dhole = 54;
tscrew_back_from_dhole =  49;

gotek_0_height = 18;
gotek_1_height = 39 + gotek_0_height;
gotek_2_height = 39 + gotek_1_height;
gotek_3_height = 39 + gotek_2_height;
gotek_total_height = 39 + gotek_3_height;
gotek_button_radius = 2;
gotek_led_radius = 1.7;
gotek_sled_sides_height = 39*4-10;

frehd4eight_height = 170;

///////////////////////////////
// Disk drive hole faceplate //
///////////////////////////////

difference() {  // TODO REMOVE TEST ONLY
union() {       // TODO REMOVE TEST ONLY
difference() {
  union() {
    translate([-dhole_center_x_offset, 0, 0])
      cube([dhole_total_width, tw, dhole_total_height]);

    // gotek 0 oled internal frame
    translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_0_height]) {
      translate([18-6,0,20]) cube([39,5,tw]);
      translate([18-6,0,20+12.5+tw]) cube([39,5,1]);
      translate([18-6-tw-11,0,20]) difference() {
        cube([tw+11,5,12+2*tw]);
        translate([6,6,8]) rotate([90,0,0]) cylinder(h=5,r=4.1);
      }
      translate([18-6+39,0,20]) difference() {
        union() {
          cube([tw,5,12+2*tw]);
          translate([0,0,3]) cube([20,5,12]);
        }
        translate([6,6,8]) rotate([90,0,0]) cylinder(h=5,r=4.1);
      }
    }
  }
  for (xpos=[1:4:82]) {
    translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 36.5 + xpos, -1, 10])
      cube([1,2*tw,6]);
    translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 36.5 + xpos, -1, dhole_total_height-12])
      cube([1,2*tw,6]);
  }
  
  // gotek 0
  translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_0_height]) {
    translate ([60,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([52,tw+1,14.5]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([60,tw+1,21]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_led_radius);
    translate ([27.,-1,9.5]) cube([16,tw*2,9]); // usb slot
    translate ([18,-1,23.5]) cube([25,tw*2,9.5]); // oled slot
    translate ([-2,0.75,14]) rotate([90, 0, 0]) linear_extrude(2*tw) text(":0", size=14);
  }
  
  // FreHD4Eight
  translate([-dhole_center_x_offset + 14 + tw, -1, frehd4eight_height + 8 + tw]) {
    // sd card hole
    translate([-1,0,0.5]) cube([30,10,3.8]);
    // label
    translate ([0,1.5,9]) rotate([90, 0, 0]) linear_extrude(2*tw) text("FreHD", size=7);
    // switch hole
    translate ([68,3,10]) rotate([90, 0, 0]) cylinder(h=tw*3, r=7.5);
    translate ([68-(5.5/2),-3,2]) cube([5.5,10,16]);
    translate ([67.5,-3,9]) cube([9,10,2]);
  }
  translate([-dhole_center_x_offset, -1,frehd4eight_height-5]) cube([dhole_total_width,4,1]); // line
  for (xpos=[36:2:60]) { // grill to see leds
    translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 36.5 + xpos, -1, frehd4eight_height + 9.5])
      cube([1,2*tw,10]);
  }
}

///////////////////
// 4 Gotek sleds //
///////////////////

translate([-dhole_center_x_offset + (dhole_total_width - 70)/2 - tw, 0, gotek_0_height])
  difference() {
    cube([tw,95,gotek_sled_sides_height]);
    // gotek 0 screw holes
    translate ([-1,23,10+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,78,10+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
translate([-dhole_center_x_offset + dhole_total_width - (dhole_total_width - 70)/2, 0, gotek_0_height])
  difference() {
    cube([tw,95,gotek_sled_sides_height]);
    // gotek 0 screw holes
    translate ([-1,23,10+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,78,10+tw]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
// gotek 0 sled bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_0_height])
  difference() {
    cube([70,95,tw]);
    translate([10,5,-1]) cube([50,95,2*tw]);
  }
// gotek 1 sled bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_1_height])
  difference() {
    cube([70,95,tw]);
    translate([10,5,-1]) cube([50,95,2*tw]);
  }
// gotek 2 sled bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_2_height])
  difference() {
    cube([70,95,tw]);
    translate([10,5,-1]) cube([50,95,2*tw]);
  }
// gotek 3 sled bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_3_height])
  difference() {
    cube([70,95,tw]);
    translate([10,5,-1]) cube([50,95,2*tw]);
  }
// FreHD4Eight sled bottom
translate([-dhole_center_x_offset, 0, frehd4eight_height]) 
  difference() {
    cube([dhole_total_width, 65, tw]);
    translate([10,5,-1]) cube([dhole_total_width-20,95,2*tw]);
  }
// FreHD4Eight switch reinforcement
difference() {
  translate([-dhole_center_x_offset, 0, frehd4eight_height]) {
    union() {
      translate([0,1,20]) cube([dhole_total_width, 5, 5]);
      translate([dhole_total_width-31,1,13]) cube([31, 5, 18]);
    }
  }
  translate([-dhole_center_x_offset + 14 + tw, -1, frehd4eight_height + 8 + tw]) {
    translate ([68,10,10]) rotate([90, 0, 0]) cylinder(h=10, r=9);
    translate ([85,10,2]) rotate([90, 0, 0]) cube([10,10,10]);
  }
}

///////////////////////////////
// Fits on metal angled base //
///////////////////////////////
union () {
  translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole, 0, 0])
    difference() {
      cube([abase_total_width, abase_height, tw*2]);
      translate([bscrew_x_offset_from_abase_left_edge - bscrew_radius,
                 bscrew_back_from_dhole + bscrew_radius, -1])
        cylinder(h=tw*3, r=bscrew_radius);
      translate([bscrew_x_offset_from_abase_left_edge - bscrew_radius,
                 bscrew_back_from_dhole + bscrew_radius + 60, -1])
        cylinder(h=tw*3, r=5.2);
    }
  translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole,
             0, -abase_depth])
    cube([tw, abase_height, abase_depth]); 
  translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole + abase_total_width - tw,
             0, -abase_depth])
    cube([tw, abase_height, abase_depth]); 
}

translate([-dhole_center_x_offset, 0, 0])
  cube([tw, 15, dhole_total_height]);
translate([dhole_center_x_offset - tw, 0, 0])
  cube([tw, 15, dhole_total_height]);
translate([dhole_center_x_offset - tw-abase_x_offset_to_dhole, 0, 0])
  cube([abase_x_offset_to_dhole, 15, tw]);

translate([-dhole_center_x_offset + tw, 0, 0])
rotate([0, -90, 0])
linear_extrude(tw) polygon(points=[[0, 0],[30, 0],[0, 60]]);;

// gotek sled support
translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole + abase_total_width - 3, 0, 0])
  cube([tw,50,gotek_0_height]);
translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole + abase_total_width - 55, 0, 0])
  cube([tw,50,gotek_0_height]);

/////////////////////////
// Fits on top support //
/////////////////////////
top_screw_nudge = 0.8;
translate([-dhole_center_x_offset, 0, dhole_total_height - tw]) 
  difference() {
    cube([dhole_total_width, 65, tw*2]);
    translate([dhole_total_width -tscrew_radius - dhole_pad_left - tscrew_x_offset_from_left_dhole - top_screw_nudge,
               tscrew_back_from_dhole + tscrew_radius, -1])
      cylinder(h=tw*3,r=tscrew_radius);
        translate([dhole_total_width -tscrew_radius - dhole_pad_left - tscrew_x_offset_from_left_dhole - top_screw_nudge,
               tscrew_back_from_dhole + tscrew_radius - 15, -1])
      cylinder(h=tw*3,r=5.2);
  }
// sled guide
translate([dhole_center_x_offset-43, 0, dhole_total_height])
  rotate([0, -90, 0])
  linear_extrude(tw) polygon(points=[[0, 0],[10, 10],[10, 60],[0, 60]]);
translate([dhole_center_x_offset-84, 18, dhole_total_height])
  rotate([0, -90, 0])
  linear_extrude(tw) polygon(points=[[0, 0],[10, 10],[10, 43],[0, 43]]);
// angle supports
translate([dhole_center_x_offset-tw, 0, dhole_total_height])
  difference() {
    rotate([0, 90, 0])
    linear_extrude(tw) 
      polygon(points=[[0, 0],[80, 0],[50,65],[0, 65]]);
    // FreHD4Eight screw holes
    translate ([-1,tw+0.1+15,-(dhole_total_height-frehd4eight_height)+2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,tw+0.1+55,-(dhole_total_height-frehd4eight_height)+2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
translate([dhole_center_x_offset - dhole_total_width, 0, dhole_total_height])
  difference() {
    rotate([0, 90, 0])
    linear_extrude(tw) 
      polygon(points=[[0, 0],[80, 0],[50,65],[0, 65]]);
    // FreHD4Eight screw holes
    translate ([-1,tw+0.1+15,-(dhole_total_height-frehd4eight_height)+2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,tw+0.1+55,-(dhole_total_height-frehd4eight_height)+2*tw+12.6]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
} // TODO REMOVE TEST ONLY
// just gotek
//translate([-dhole_center_x_offset-20,-3,-50]) cube([/*width*/200,170,/*height*/68]);
//translate([-dhole_center_x_offset-20,-3,60]) cube([/*width*/200,170,/*height*/500]);
//Just FreHD
//translate([-dhole_center_x_offset-20,-3,-60]) cube([/*width*/200,170,/*height*/220]);
//translate([-dhole_center_x_offset+10,10,-60]) cube([/*width*/90,160,/*height*/230]);
//translate([-dhole_center_x_offset-20,20,60]) cube([/*width*/550,70,/*height*/500]);
} // TODO REMOVE TEST ONLY
