module hex_triangle(depth) {
    // An isoceles triangle along the X axis with the third point going
    // 'depth' into the Y and having an internal angle of 120 degrees.
    width = depth * tan(60) * 2;
    polygon([[0, 0], [width, 0], [width/2, depth]]);
}

difference() {
    linear_extrude(50) offset(5) offset(-10) offset(5) hex_triangle(50);
    translate([0, -5, 5]) linear_extrude(40) hex_triangle(50);
}