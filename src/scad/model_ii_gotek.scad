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
abase_depth = 20; // down -- to support
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

///////////////////////////////
// Disk drive hole faceplate //
///////////////////////////////

difference() {
  translate([-dhole_center_x_offset, 0, 0])
    cube([dhole_total_width, tw, dhole_total_height]);
  for (xpos=[1:3:87]) {
    translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 38.5 + xpos, -1, 30])
      cube([1,2*tw,60]);
    translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 38.5 + xpos, -1, 110])
      cube([1,2*tw,90]);
  }
  translate([-dhole_center_x_offset - 5 + (dhole_total_width/2) - 38.5, 1, 95])
    rotate([90, 0, 0])
    linear_extrude(tw) text("Drive:0", size=5);
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
                 bscrew_back_from_dhole + bscrew_radius + 15, -1])
        cylinder(h=tw*3, r=5);
    }

  translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole,
             0, -abase_depth])
    cube([tw, abase_height, abase_depth]); 

  translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole + abase_total_width - tw,
             0, -abase_depth])
    cube([tw, abase_height, abase_depth]); 
}

translate([-dhole_center_x_offset, 0, 0])
  cube([tw, 10, dhole_total_height]);
translate([dhole_center_x_offset - tw, 0, 0])
  cube([tw, 10, dhole_total_height]);
translate([dhole_center_x_offset - tw-abase_x_offset_to_dhole, 0, 0])
  cube([abase_x_offset_to_dhole, 10, tw]);

translate([-dhole_center_x_offset + tw, 0, 0])
rotate([0, -90, 0])
linear_extrude(tw) 
  polygon(points=[[0, 0],[80, 0],[0, 60]]);;

translate([-dhole_center_x_offset + dhole_pad_left - abase_total_x_offset_to_dhole + abase_total_width, 0, 0])
rotate([0, -90, 0])
linear_extrude(tw) 
  polygon(points=[[0, 0],[30, 0],[0, 60]]);

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
      cylinder(h=tw*3,r=5);
  }
