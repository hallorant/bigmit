$fa = 1;
$fs = 0.5;
$fn = 50;

sheight = 34;
swidth = 3.5;

module slide(height, width) {
  translate([0,-5,0]) cube([10,width,height]);
  difference() {
    cylinder(height, 5, 5);
    translate([0,0,-1]) {
      cylinder(height+2, 1.5, 1.5);
      translate([0,-8,0]) cube([8,16,height+2]);
      translate([-5,0,0]) cube([8,8,height+2]);
      rotate([0,0,95]) cube([20,16,height+2]);
    }
  }
  rotate([0,0,95]) translate([0,1.5,0]) cube([1.5,width,height]);
}

module slidecut(height, width) {
  translate([0,-5,0]) cube([9.5,width,height]);
  difference() {
    cylinder(height, 5, 5);
    translate([0,0,-1]) {
      cylinder(height+2, 4.5, 4.5);
      translate([0,-8,0]) cube([8,16,height+2]);
      translate([-5,0,0]) cube([8,8,height+2]);
      rotate([0,0,95]) cube([20,16,height+2]);
    }
  }
  rotate([0,-0.01,95]) translate([0,swidth+1,0]) cube([1,width,height]);
}

module guide() {
  difference() {
    cube([6,2.3,9.5]);
    // Wing cuttouts
    translate([6/2-2.5/2,0,9.5-1.6]) cube([2.5,2.6,2.1]);
    translate([6/2-2.5/2,0,-0.5]) cube([2.5,2.6,2.1]);
  }
}

difference() {
  union() {
    difference() {
     slide(sheight,swidth);
     for(pos = [0.5:2:sheight-0.5])
     translate([-0.1,-0.01,pos]) slidecut(1, 0.5);
    }
    translate([4-1.5,-2,(sheight/2)-(9.5/2)]) guide();
  }
  // screw mount hole (needs to be through entire slider)
  r=1.5;
  translate([4-1.5,-2,(sheight/2)-(8/2)])
  rotate([90,0,0]) translate([3,9.5/2-r/2,-2.6]) cylinder(3.6,r,r);
}
