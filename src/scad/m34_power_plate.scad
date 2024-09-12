$fa = 1;
$fs = 0.5;
$fn = 50;

module screw_oval() {
  height=4;
  diameter=4;
  rotate([90,0,0])
  union() {
    translate([0,diameter/2,0]) cylinder(h=height, r=diameter/2);
    cube([10,diameter,4]);
    translate([10,diameter/2,0]) cylinder(h=height, r=diameter/2);
  }
}

module screw_hole() {
  height=4;
  diameter=4;
  rotate([90,0,0])
  translate([0,diameter/2,0]) cylinder(h=height, r=diameter/2);
}

module cassette_hole() {
  height=4;
  diameter=16.3;
  union() {
    translate([0,diameter/2,-16]) cylinder(h=20, r=diameter/2);
    translate([-9.25,diameter/2-3,0]) cube([18.5,6,height]);
    //translate([0,8,-19]) *cylinder(h=height, r=13);
    translate([-13,diameter/2-3,-19]) cube([30,6,20]);
  }
}

module plug_hole() {
  depth=20;
  translate([0,0,-(depth-3)])
  union() {
    difference() {
      cube([27,19,depth]);
      linear_extrude(depth) polygon(points=[[0,0],[5,0],[0,5]]);
      translate([27,0,0]) linear_extrude(depth) polygon(points=[[-5,0],[0,0],[0,5]]);
    }
    diameter=4;
    translate([-6.5,10,0]) cylinder(h=depth, r=diameter/2);
    translate([33.5,10,0]) cylinder(h=depth, r=diameter/2);
  }
}

module front_panel() {
  difference() {
    union() {
      translate([0,0,-0.5]) cube([95,39.5,1.5]);
      translate ([6,0,-14]) cube([95-12,39.5,14]);
      translate ([3.5,3,0]) linear_extrude(1.5) text("CASSETTE", font="Ariel:style=Bold", size=4);
    }
    translate([18.25,9.5,-1]) cassette_hole();
    translate([50,9.5,-1]) plug_hole();
  }
}

module top_flap() {
    difference() {
    cube([95,1.5,20]);
    translate([-6,2,8]) screw_oval();
    translate([91,2,8]) screw_oval();
    translate([28.5,2,8]) screw_hole();
  }
}

module bottom_flap() {
  difference() {
    cube([95,1.5,14]);
    translate([-6,2,5]) screw_oval();
    translate([91,2,5]) screw_oval();
  }
}

difference() {
  union() {
    front_panel();
    translate([0,38.5,0]) top_flap();
    translate([0,0,-14]) bottom_flap();
  }

}