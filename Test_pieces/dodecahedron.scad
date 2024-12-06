phi = (1+sqrt(5))/2;  phi2 = phi*2;

* hull() {
    rotate([0, 0, 0]) cube([phi2, 2, 0.01], center=true);
    rotate([0, 90, 90]) cube([phi2, 2, 0.01], center=true);
    rotate([90, 0, 90]) cube([phi2, 2, 0.01], center=true);
}

* union() {
    translate([phi, 1, 0]) linear_extrude(0.1) text("0", size=0.4);
    translate([phi, -1, 0]) linear_extrude(0.1) text("1", size=0.4);
    translate([-phi, -1, 0]) linear_extrude(0.1) text("2", size=0.4);
    translate([-phi, 1, 0]) linear_extrude(0.1) text("3", size=0.4);
    translate([1, 0, phi]) linear_extrude(0.1) text("4", size=0.4);
    translate([-1, 0, phi]) linear_extrude(0.1) text("5", size=0.4);
    translate([-1, 0, -phi]) linear_extrude(0.1) text("6", size=0.4);
    translate([1, 0, -phi]) linear_extrude(0.1) text("7", size=0.4);
    translate([0, phi, 1]) linear_extrude(0.1) text("8", size=0.4);
    translate([0, phi, -1]) linear_extrude(0.1) text("9", size=0.4);
    translate([0, -phi, -1]) linear_extrude(0.1) text("10", size=0.4);
    translate([0, -phi, 1]) linear_extrude(0.1) text("11", size=0.4);
}

module icosahedron() {
    // An icosahedron of side length 2, centred on the origin.
    // Edge to edge it is phi*2 tall; face to face it is 3 high.
    // The construction method means that it is balanced on one edge
    // - i.e. neither face nor point is on the Z axis.
    polyhedron(points=[
        [phi, 1, 0], [phi, -1, 0], [-phi, -1, 0], [-phi, 1, 0],
        [1, 0, phi], [-1, 0, phi], [-1, 0, -phi], [1, 0, -phi],
        [0, phi, 1], [0, phi, -1], [0, -phi, -1], [0, -phi, 1]
    ], faces = [
        [0, 4, 8], [0, 1, 4], [0, 7, 1], [0, 9, 7], [0, 8, 9],  // one end
        [2, 3, 5], [2, 5, 11], [2, 11, 10], [2, 10, 6], [2, 6, 3],  // the other end
        [11, 5, 4], [1, 11, 4], [10, 11, 1], [7, 10, 1], [6, 7, 10],  // half the middle band
        [6, 7, 9], [6, 9, 3], [3, 9, 8], [8, 5, 3], [5, 8, 4],
    ], convexity=1);
};

function circle_pts(r, h, z_rot=0, points=5) = [
    for(i=[0:points-1])
        [r*cos(360*i/points+z_rot), r*sin(360*i/points+z_rot), h]
];

module dodecahedron(r=1) {
    // A dodecahedron of height 2, with top and bottom faces parallel
    // to the XY plane.
    let(or=r*tan(43), mr=r*tan(50.97), h=1, mh=0.3333)
    polyhedron(points=[
        each circle_pts(or, -h, 0, 5),
        each circle_pts(mr, -mh, 0, 5),
        each circle_pts(mr, +mh, 36, 5),
        each circle_pts(or, +h, 36, 5),
    ], faces=[
        [0, 1, 2, 3, 4],
        [0, 1, 6, 10, 5], [1, 2, 7, 11, 6], [2, 3, 8, 12, 7],
          [3, 4, 9, 13, 8], [4, 0, 5, 14, 9],
        [15, 16, 11, 6, 10], [16, 17, 12, 7, 11], [17, 18, 13, 8, 12],
          [18, 19, 14, 9, 13], [19, 15, 10, 5, 14],
        [15, 16, 17, 18, 19]
    ], convexity=1);
}

$fn=10;
* for(pt=[
        each circle_pts(10*tan(36), -10, 0, 5),
        each circle_pts(10*tan(36), -5, 36, 5),
        each circle_pts(10*tan(36), +5, 0, 5),
        each circle_pts(10*tan(36), +10, 36, 5),
    ]) translate(pt) sphere(1);
scale(10) dodecahedron();

// translate([0, 0, phi]) 
* translate([2, 0, 1.5]) rotate([90/4, 0, ]) 
icosahedron();