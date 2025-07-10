$fa = 1;
$fs = 0.5;
$fn = 50;

width = 69.7;
small_magnet_hole_radius = 4.05;
difference() {
  union() {
    translate([0,-2.6,-2.6]) cube([width,2.6,7.6]);
    cube([width,14.2,5]);
  }
  // Room for dip connector
  translate([11,0,-1]) cube([5,20,10]);
  // Room for usb
  translate([52,11,-1]) cube([30,20,10]);
  // Label back of OLED holder
  translate ([50,9,3.5]) rotate([0, 0, 180]) linear_extrude(2) text("oled (back)", size=5);
  
  // Rail holes
  rail_size = 2.5;
  rail_down = 4;
  translate([-(3-rail_size),rail_down,-1])  cube([3,rail_size,7]);
  translate([width-rail_size,rail_down,-1]) cube([3,rail_size,7]);
}
