$fa = 1;
$fs = 0.5;
$fn = 50;

module support() {
  translate([0,0,0]) rotate([90,0,0]) linear_extrude(13) polygon([[0,2],[5,100],[10,100],[10,2]]);
  translate([0,2,0]) rotate([90,0,0]) linear_extrude(2) polygon([[0,2],[5,100],[13,100],[13,2]]);
  translate([0,-13,0]) rotate([90,0,0]) linear_extrude(2) polygon([[0,2],[5,100],[13,100],[13,2]]);
}
  

translate([-10,-25-5/2,0]) cube([220,55,2]);
translate([-10,-8,0]) support();
translate([210,-21,0]) rotate([0,0,180]) support();
translate([0,-23,2]) cube([200,2,2]);
translate([0,-8,2]) cube([200,2,2]);

translate([0,0,-10]) difference() {
  translate([-10,-25-5/2,0]) rotate([10,0,0]) cube([220,55,15]);
  translate([-11,-35,10]) cube([222,80,20]);
}