$fa = 1;
$fs = 0.5;
$fn = 50;

module block() {
  rotate([90,0,0]) cylinder(h=5, r=4, center=true);
}

module support() {
  rotate([90,0,0]) cylinder(h=4.12, r=3, center=true);
}

difference() {
  union() {
    import("FD502_bottom.stl");
    translate([60,0.6,66]) cube([10,2,10]);
  }
  translate([59.5,5,63]) cube([12,10,15]);
  // fix db25 end
  translate([85,-10,0]) cube([50,50,130]);
  
  x_rs=102;
  translate([x_rs,8.56,26]) block();
  translate([x_rs,8.56,115]) block();
  
  x_sk=30;
  translate([x_sk,8.56,26]) block();
  translate([x_sk,8.56,115]) block();
}


// covered end
translate([85,0.5,19.2]) cube([2,22,102.4]);

translate([80,4,25.8]) support();
translate([80,4,114.5]) support();
