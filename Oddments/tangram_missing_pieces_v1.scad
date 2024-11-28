epsilon = 0.01;
module rounded_box(length, width, height, outer_r) {
    // A simple solid box with rounded bottom and side edges.
    // Essentially this is a box with spherical corners and cylindrical
    // edges on the outside.  You can then subtract whatever object you want
    // from it to make it hollow if you like.
    // Parameters are: the external length, width and height,
    // the radius of the corners and edges.
    outer_d = outer_r*2;
    translate([outer_r, outer_r, outer_r]) difference() {
        // outer rounded rectangle
        minkowski() {
            cube([length-outer_d, width-outer_d, height-outer_r]);
            sphere(r=outer_r);
        };
        // top face
        translate([-outer_r, -outer_r, height-outer_r+epsilon]) 
          cube([length+2*outer_r, width+2*outer_r, outer_r]);
    }
}

module v_cut(x1, y1, x2, y2, depth) {
    // A 'v' cut, going down into -Z, of depth 'depth' and width 'depth*2',
    // starting from [x1, y1] and going to [x2, y2].  This is described as
    // a linear_extrude of a triangle, and then rotated and translated into
    // position.  The 'cut' is into the XY plane.
    dx = x2 - x1; dy = y2 - y1;
    cut_len = sqrt(dx*dx + dy*dy); cut_angle = atan2(dy, dx);
    translate([x1, y1, 0]) rotate([0, 90, cut_angle]) linear_extrude(cut_len) polygon([
        [0, depth], [depth, 0], [0, -depth] 
    ]);
}

total_tangram_side = 124.5;
tri_a_side = total_tangram_side / sqrt(2);
tri_b_side = total_tangram_side / 2;
tri_c_side = tri_a_side / 2;
tangram_height = 9.5;

enclosure_wall = 3;
enclosure_side = total_tangram_side + 3*2;
enclosure_floor = 2.5;
enclosure_height = tangram_height + enclosure_floor;

v_cut_depth = 1; v_cut_off = 1; v_cut_2 = v_cut_off*2;

// small triangle
module small_triangle() linear_extrude(tangram_height) polygon([
    [0, 0], [tri_c_side, 0], [0, tri_c_side]
]);

// medium triangle
module medium_triangle() linear_extrude(tangram_height) polygon([
    [0, 0], [tri_b_side, 0], [0, tri_b_side]
]);

// large triangle
module large_triangle() linear_extrude(tangram_height) polygon([
    [0, 0], [tri_a_side, 0], [0, tri_a_side]
]);

// square
module tan_square() cube([tri_c_side, tri_c_side, tangram_height]);

// parallelogram
module parallelogram() linear_extrude(tangram_height) polygon([
    [0, 0], [tri_c_side, 0], [tri_a_side, tri_c_side], [tri_c_side, tri_c_side]
]);

color("white") translate([5, 0, 0]) rotate([0, 0, -45]) large_triangle();
color("black") translate([0, 5, 0]) rotate([0, 0, +45]) large_triangle();
color("red") translate([-tri_b_side-5, -tri_b_side-5, 0]) rotate([0, 0, 0]) medium_triangle();
color("yellow") translate([-tri_b_side/2-5, tri_b_side/2+5, 0]) rotate([0, 0, +135]) small_triangle();
color("green") translate([-tri_b_side/2-2.5, -tri_b_side/2, 0]) rotate([0, 0, +45]) tan_square();
color("blue") translate([0, -2.5, 0]) rotate([0, 0, +225]) small_triangle();
color("purple") translate([-tri_b_side/2+2.5, -tri_b_side/2-5, 0]) rotate([0, 0, -45]) parallelogram();

* difference() {
    rounded_box(enclosure_side, enclosure_side, enclosure_height, 2);
    translate([enclosure_wall, enclosure_wall, enclosure_floor]) union() {
        cube([total_tangram_side, total_tangram_side, tangram_height+1]);
        translate([v_cut_off, v_cut_off, 0.1]) union() {
            v_cut(0, 0, total_tangram_side-v_cut_2, total_tangram_side-v_cut_2, v_cut_depth);
            v_cut(tri_b_side, tri_b_side, total_tangram_side-v_cut_2, 0, v_cut_depth);
            v_cut(0, tri_b_side, tri_b_side, total_tangram_side-v_cut_2, v_cut_depth);
            v_cut(tri_b_side/2, tri_b_side/2, tri_b_side/2, tri_b_side*1.5-v_cut_off, v_cut_depth);
            v_cut(tri_b_side, tri_b_side, tri_b_side/2, tri_b_side*1.5-v_cut_off, v_cut_depth);
            v_cut(tri_b_side*1.5, tri_b_side*1.5, tri_b_side, total_tangram_side-v_cut_2, v_cut_depth);
        }
    }
}