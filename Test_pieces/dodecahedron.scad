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

rotate([90/4, 0, 0]) polyhedron(points=[
    [phi, 1, 0], [phi, -1, 0], [-phi, -1, 0], [-phi, 1, 0],
    [1, 0, phi], [-1, 0, phi], [-1, 0, -phi], [1, 0, -phi],
    [0, phi, 1], [0, phi, -1], [0, -phi, -1], [0, -phi, 1]
], faces = [
    [0, 4, 8], [0, 1, 4], [0, 7, 1], [0, 9, 7], [0, 8, 9],  // one end
    [2, 3, 5], [2, 5, 11], [2, 11, 10], [2, 10, 6], [2, 6, 3],  // the other end
    [11, 5, 4], [1, 11, 4], [10, 11, 1], [7, 10, 1], [6, 7, 10],  // half the middle band
    [6, 7, 9], [6, 9, 3], [3, 9, 8], [8, 5, 3], [5, 8, 4],
], convexity=1);
