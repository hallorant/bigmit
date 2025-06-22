$fa = 1;
$fs = 0.5;
$fn = 50;

space = 33;

module prism(l, w, h) {
    polyhedron(// pt      0        1        2        3        4        5
               points=[[0,0,0], [0,w,h], [l,w,h], [l,0,0], [0,w,0], [l,w,0]],
               // top sloping face (A)
               faces=[[0,1,2,3],
               // vertical rectangular face (B)
               [2,1,4,5],
               // bottom face (C)
               [0,3,5,4],
               // rear triangular face (D)
               [0,4,1],
               // front triangular face (E)
               [3,2,5]]
               );}

translate([0,-10,0])
difference() {
  union() {           
    translate([0,0,2]) prism(60, 10, 70);
    translate([60,10+10+space,2]) rotate([0,0,180]) prism(60, 10, 70);
    cube([60,53,2]);
  }
  translate([-5,0,60]) cube([70,53,20]);
}