include <roundedcube.scad>

$fa = 1;
$fs = 0.5;
$fn = 50;

difference() {
    roundedcube([7,7,3], true, 0.1);
    translate([0,0,-0.5]) cube([6,6,2.5], center=true);
}


difference() {
    union() {
        translate([0,0,-0.04]) cube([6.9,0.5,2.9], center=true);
        translate([0,0,-0.04]) cube([0.5,6.9,2.9], center=true);
        translate([0,0,-0.04]) rotate(45) cube([9,0.5,2.9], center=true);
        translate([0,0,-0.04]) rotate(-45) cube([9,0.5,2.9], center=true);
    }
    cylinder(h=5,r=2.1, center=true);
}