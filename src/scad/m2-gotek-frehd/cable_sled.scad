$fa = 1;
$fs = 0.5;
$fn = 50;

////////////////////////////////
// All measurements are in mm //
////////////////////////////////

tw = 1.5; // thickness of any walls

// Metal angled Base (ABASE)
abase_width = 97;
abase_height = 50; // back -- to support
abase_depth = 15; // down -- to support
abase_x_offset_to_dhole = 27;

abase_total_width = abase_width + tw + tw;
abase_total_x_offset_to_dhole = 27 + tw;

// Bottom screw hole
bscrew_radius = 2.5;
bscrew_back_from_dhole = 5;
bscrew_x_offset_from_abase_left_edge = abase_total_width - 32;

post_h = 32;
post_r = 1.25;

hex_h = 2 + 2;
hex_r = 2.1;

///////////////////////////////
// Fits on metal angled base //
///////////////////////////////
union () {
  difference() {
    union() {
      cube([abase_total_width, abase_height, 5]);
    }
    translate([bscrew_x_offset_from_abase_left_edge - bscrew_radius,
               bscrew_back_from_dhole + bscrew_radius, -1])
      cylinder(h=10, r=bscrew_radius);
    rotate([0,0,-90]) {
      translate([-50,8,3]) {
        // together side posts
        translate([7, 5, -5]) {
          cylinder(h=post_h, r=post_r);
          cylinder(h=hex_h, r=hex_r, $fn=6);
        }
        translate([29, 5, -5]) {
          cylinder(h=post_h, r=post_r);
          cylinder(h=hex_h, r=hex_r, $fn=6);
        }
        // not together side posts
        translate([7, 78.55, -5]) {
          cylinder(h=post_h, r=post_r);
          cylinder(h=hex_h, r=hex_r, $fn=6);
        }
        translate([29, 58, -5]) {
          cylinder(h=post_h, r=post_r);
          cylinder(h=hex_h, r=hex_r, $fn=6);
        }
      }
    }
    translate ([60,7,4]) rotate([0, 0, 180]) linear_extrude(6) text("5.25\" to 8\" floppy (front)", size=4);
  }
  translate([0, 0, -abase_depth])
    cube([tw, abase_height, abase_depth]); 
  translate([abase_total_width - tw,
             0, -abase_depth])
    cube([tw, abase_height, abase_depth]);
}



