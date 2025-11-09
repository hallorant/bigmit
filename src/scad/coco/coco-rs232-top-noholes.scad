$fa = 1;
$fs = 0.5;
$fn = 50;

difference() {
  difference() {
    union() {
      import("FD502_top.stl");
      translate([75,0,12.8]) cube([25,3,102.4]);
    }
    for (zp=[20:4:105]) { // grill to see leds
      translate([83,-1,zp]) cube([8.7,6,1]);
    }
  }
  translate([59.5,4,56]) cube([12,15,15]);
  // fix db25 end
  translate([107.5,-10,0]) cube([50,50,130]);
}