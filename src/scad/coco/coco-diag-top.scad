$fa = 1;
$fs = 0.5;
$fn = 50;

module support() {
  rotate([90,0,0]) cylinder(h=14, r=3, center=true);
}

difference() {
  difference() {
    union() {
      import("FD502_top.stl");
      translate([75,0,12.8]) cube([25,3,102.4]);
    }
  }
  translate([59.5,4,56]) cube([12,15,15]);
  // fix db25 end
  translate([85,-10,0]) cube([50,50,130]);
}
translate([80,8,20]) support();
translate([80,8,108.5]) support();


