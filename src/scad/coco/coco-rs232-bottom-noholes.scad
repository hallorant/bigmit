$fa = 1;
$fs = 0.5;
$fn = 50;

module block() {
  rotate([90,0,0]) cylinder(h=5, r=4, center=true);
}

difference() {
  union() {
    import("FD502_bottom.stl");
    translate([60,0.6,66]) cube([10,2,10]);
  }
  translate([59.5,5,63]) cube([12,10,15]);
  // fix db25 end
  translate([107.5,-10,0]) cube([50,50,130]);
  
  x_rs=102;
  translate([x_rs,8.56,26]) block();
  translate([x_rs,8.56,115]) block();
  
  x_sk=30;
  translate([x_sk,8.56,26]) block();
  translate([x_sk,8.56,115]) block();
}
// db25 end fix
translate([107.5,0.5,16.4]) cube([2,6,108]);
// sides
ht_sides=22;
translate([107.5,0.5,16.4]) cube([2,ht_sides,27]);
translate([107.5,0.5,16.4+108-27]) cube([2,ht_sides,27]);