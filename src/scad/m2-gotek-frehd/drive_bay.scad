$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Disk drive hole (DHOLE)
dhole_width = 87;
dhole_height = 214;
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

gotek_start_height = 18;
gotek_0_height = 0;
gotek_button_radius = 2;
gotek_led_radius = 1.7;

///////////////////////////////
// Disk drive hole faceplate //
///////////////////////////////

difference() {
  union() {
    translate([-dhole_center_x_offset, 0, 0])
      cube([dhole_total_width, tw, dhole_total_height]);
    // gotek 0 oled internal frame
    translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_start_height + gotek_0_height]) {
      translate([27-6,0,17]) cube([39,4,tw]);
      translate([27-6,0,17+12.5+tw]) cube([39,4,tw]);
      translate([27-6-tw,0,17]) cube([tw,4,12.5+2*tw]);
      translate([27-6+39,0,17]) cube([tw,4,12.5+2*tw]);
    }
  }
  for (xpos=[1:4:82]) {
    translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 36.5 + xpos, -1, 10])
      cube([1,2*tw,6]);
  }
  
  // gotek 0
  translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_start_height + gotek_0_height]) {
    translate ([10,tw+1,12]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([18,tw+1,12]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_button_radius);
    translate ([10,tw+1,17]) rotate([90,0,0]) cylinder(h=tw*2,r=gotek_led_radius);
    translate ([27,-1,9]) cube([15,tw*2,8]); // usb slot
    translate ([27,-1,20]) cube([25,tw*2,10]); // oled slot
    translate ([12,2,24.8]) rotate([90,0,0]) cylinder(h=tw,r=4.1);
    translate ([43,1.4,11]) rotate([90, 0, 0]) linear_extrude(2*tw) text("Disk :0", size=4.5);
    translate([0,-1,7]) cube([70,tw,1]);
    translate([0,-1,31]) cube([70,tw,1]);
  }
  
  // empty space
  translate([-dhole_center_x_offset + 15,-1,70]) cube([abase_width-20,tw*2,130]);
}

///////////////////
// 4 Gotek sleds //
///////////////////
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2 - tw, 0, gotek_start_height + gotek_0_height])
  difference() {
    cube([tw,95,40]);
    // gotek 0 screw holes
    translate ([-1,20,10]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,75,10]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
translate([-dhole_center_x_offset + dhole_total_width - (dhole_total_width - 70)/2, 0, gotek_start_height + gotek_0_height])
  difference() {
    cube([tw,95,40]);
    // gotek 0 screw holes
    translate ([-1,20,10]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
    translate ([-1,75,10]) rotate([0,90,0]) cylinder(h=tw*2,r=1.6);
  }
// gotek 0 sled bottom
translate([-dhole_center_x_offset + (dhole_total_width - 70)/2, 0, gotek_start_height + gotek_0_height])
  cube([70,95,tw]);

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
                 bscrew_back_from_dhole + bscrew_radius + 15, -1])
        cylinder(h=tw*3, r=5.25);
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
  cube([tw,50,gotek_start_height]);
translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole + abase_total_width - 55, 0, 0])
  cube([tw,50,gotek_start_height]);

/////////////////////////
// Fits on top support //
/////////////////////////
translate([-dhole_center_x_offset, 0, dhole_total_height - tw]) 
  difference() {
    cube([dhole_total_width, 60, tw*2]);
    translate([dhole_total_width -tscrew_radius - dhole_pad_left - tscrew_x_offset_from_left_dhole,
               tscrew_back_from_dhole + tscrew_radius, -1])
      cylinder(h=tw*3,r=tscrew_radius);
        translate([dhole_total_width -tscrew_radius - dhole_pad_left - tscrew_x_offset_from_left_dhole,
               tscrew_back_from_dhole + tscrew_radius - 15, -1])
      cylinder(h=tw*3,r=5.25);
  }
// sled guide
translate([dhole_center_x_offset-43, 0, dhole_total_height])
  rotate([0, -90, 0])
  linear_extrude(tw) polygon(points=[[0, 0],[10, 20],[10, 60],[0, 60]]);
translate([dhole_center_x_offset-84, 18, dhole_total_height])
  rotate([0, -90, 0])
  linear_extrude(tw) polygon(points=[[0, 0],[10, 20],[10, 43],[0, 43]]);
// angle supports
translate([dhole_center_x_offset-tw, 0, dhole_total_height])
  rotate([0, 90, 0])
  linear_extrude(tw) 
    polygon(points=[[0, 0],[80, 0],[0, 60]]);
translate([dhole_center_x_offset - dhole_total_width, 0, dhole_total_height])
  rotate([0, 90, 0])
  linear_extrude(tw) 
    polygon(points=[[0, 0],[80, 0],[0, 60]]);
