$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Disk drive hole (DHOLE)
dhole_width = 87;
dhole_height = 213;
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
abase_depth = 20; // down -- to support
abase_x_offset_to_dhole = 27;

abase_total_width = abase_width + tw + tw;
abase_total_x_offset_to_dhole = 27 + tw;

// Bottom screw hole
bscrew_radius = 2.5;
bscrew_back_from_dhole = 25.5;
bscrew_x_offset_from_abase_left_edge = abase_total_width - 30;

// Top screw hole
tscrew_radius = 2.5;
tscrew_x_offset_from_left_dhole = 30;
tscrew_back_from_dhole =  21;

///////////////////////////////
// Disk drive hole faceplate //
///////////////////////////////
//translate([-dhole_center_x_offset, 0, 0]) cube([dhole_total_width, tw, //dhole_total_height]);

oled_screen_width = 25;
oled_screen_left_offset = 6;
oled_screen_height = 10;
oled_screen_top_offset = 1;

oled_width = 39;
oled_height = 13;
oled_holder_width = oled_width + tw + tw;
oled_holder_height = oled_height + tw;
oled_holder_depth = 5;

union() {
  difference() {
    cube([oled_holder_width, oled_holder_depth, oled_holder_height]);
      translate([tw, tw, tw])
        cube([oled_width, oled_holder_depth, oled_height +1]);
      translate([tw + oled_screen_left_offset, -1, oled_holder_height - oled_screen_height - oled_screen_top_offset])
        cube([oled_screen_width, 30, oled_screen_height]);
  }
  translate([oled_holder_width - 4*tw, oled_holder_depth - tw, 0])
    cube([4*tw, tw, oled_holder_height]);
  translate([5 + tw, oled_holder_depth - tw, 0])
    cube([5 ,tw, 3*tw]);
}

