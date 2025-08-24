$fa = 1;
$fs = 0.5;
$fn = 50;

difference() {
  union() {
    difference() {
      cube([53,12.5,13]);
      translate([(53-42)/2,(12.5-11)/2,-1]) cube([42,11,6]); // lower
      translate([(53-37)/2,(12.5-7)/2,4]) cube([37,7,8]); // upper
      translate([-5,-0.25,0]) rotate([0,8,0]) cube([5,14,25]);
      translate([53,-0.25,0]) rotate([0,-8,0]) cube([5,14,25]);
      translate([3,12.5/2,3]) cylinder(h=7, r=1.55, center = true);
      translate([53-3,12.5/2,3]) cylinder(h=7, r=1.55, center = true);
      
      translate([0,-5,5]) rotate([-15,0,0]) cube([53,5,15]);
      translate([0,12.5,5]) rotate([15,0,0]) cube([53,5,15]);
      
      for(x=[11:5:42])
        translate([x,13,7])
          rotate([90,0,0])
            linear_extrude(height=15)
              union() {
                circle(d=3);
                translate([0,1.5,0]) square([3,3.5],center=true);
                translate([0,3,0]) circle(d=3);
              }
      
    }
    translate([(52-33)/2,0,12]) cube([33,12.5,1]);
  }
  translate([3,4.7,13-0.3]) linear_extrude(3) text("Serial DB25 Loopback",size=3.4,font="Crystal Radio Kit:style=Regular");
}