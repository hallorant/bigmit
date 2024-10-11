$fa = 1;
$fs = 0.5;
$fn = 50;

// Holder (suggested clear)
// Use 'adj' to adjust fit of button (less is looser).
difference() {
  adj=0.2;
  union() {
    translate([-2,-2,0]) cube([18,18,0.75]);
    translate([0.75,0.75,0]) cube([12.5,12.5,7]);
  }
  translate([1.75+(adj/2),1.75+(adj/2),-0.5]) cube([10.5-adj,10.5-adj,8]);
  
  translate([6,0.74,-1]) cube([2,2,7]);
  translate([6,11.26,-1]) cube([2,2,7]);
  
  translate([0.74,6,-1]) cube([2,2,7]);
  translate([11.26,6,-1]) cube([2,2,7]);
}

// Button (suggested orange)
translate([40,1.75,0]) {
  
  difference() {
    cs=1.7;
    union() {
      cube([10,10,7]);
      translate([1-cs,5-cs/2,5]) cube([cs,cs,2]);
      translate([9,5-cs/2,5]) cube([cs,cs,2]);
      translate([5-cs/2,1-cs,5]) cube([cs,cs,,2]);
      translate([5-cs/2,9,5]) cube([cs,cs,2]);
    }
    translate([1,1,3]) cube([8,8,5]);
  }
}