$fa = 1;
$fs = 0.5;
$fn = 50;

module smaller() {
rotate([90,0,0])
  difference() {
    cylinder(h=5, r=4, center=true);
    cylinder(h=5, r=1.5, center=true);
  }
}

difference() {
  union() {
    import("FD502_bottom.stl");
    translate([60,0.6,66]) cube([10,2,10]);
    // fix small slot on bottom
    translate([105,0.5,35]) cube([4,2.7,70]);
  }
  translate([59.5,5,63]) cube([12,10,15]);
  // fix db25 end
  translate([107.5,-10,0]) cube([50,50,130]);
  
  translate([102,8.56,26]) smaller();
  translate([102,8.56,115]) smaller();
}
// db25 end fix
translate([107.5,0.5,16.4]) cube([2,6,108]);
// sides
ht_sides=22;
translate([107.5,0.5,16.4]) cube([2,ht_sides,27]);
translate([107.5,0.5,16.4+108-27]) cube([2,ht_sides,27]);