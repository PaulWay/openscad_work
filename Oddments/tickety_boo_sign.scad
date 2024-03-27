module rail(x1, x2, y, z) {
    // a rail, trapezoidal in cross-section, with bottom being x1 wide and
    // top being x1 wide, and the whole thing being y long and z high.
    centre=max(x1, x2) / 2;
    x1l = (centre - x1/2); x1r = centre + x1/2;
    x2l = (centre - x2/2); x2r = centre + x2/2;
    translate([0, y, 0]) rotate([90, 0, 0]) linear_extrude(y) polygon([
        [x1l, 0], [x2l, z], [x2r, z], [x1r, 0]
    ]);
}

union() {
    color("blue") difference() {
        cube([80, 45, 3]);
        translate([-0.01, 17, 1]) rotate([0, 0, -90]) rail(4.2, 2.2, 80.02, 2.02);
    }
    color("yellow") linear_extrude(5) {
        translate([40, 32, 0]) text("Everything is", halign="center");
        translate([40, 20, 0]) text("tickety-boo", halign="center");
        translate([20, 5, 0]) text("yes", halign="center");
        translate([60, 5, 0]) text("no", halign="center");
    }
}

translate([0, 50, 0]) union() {
    // upside-down so it prints on the flat bit to start
    cube([22, 15, 1]);  // the cover
    translate([0, 13, 1]) cube([22, 2, 2]);  // the text offset
    translate([0, 16, 3]) rotate([0, 0, -90]) rail(2, 4, 22, 2);  // the rail
}