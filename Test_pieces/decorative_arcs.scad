module toroid_from_by_to(from, by, to, d=undef, r=undef) {
    // A toroidal segment that goes through each point in a circular arc.
    //
}

module decorative_arc(outer_rad, start_angle=0, end_angle=180) {
   // An arc formed by the children, moved outer_rad along the X axis,
   // going from start_angle to end_angle.
   assert(end_angle>start_angle, "End angle must be greater than start");
   rotate([0, 0, start_angle]) rotate_extrude(angle=end_angle-start_angle)
     translate([outer_rad, 0, 0]) children();
}

module decorative_corner(outer_rad, height, start_angle=0, end_angle=90) {
    // Where a decorative_arc bends the children through an angle via
    // rotate_extrude, this joins two linear_extrudes to achive the same
    // 'bend' with straight edges.  This works by intersecting each line
    // with a ??
}

module decorative_line(length, angle=0) {
    // A line formed by extruding the children from the origin
    // length along the angle, counterclockwise from the X axis.
    rotate([0, 90, angle]) linear_extrude(length) rotate([0, 0, 90]) children();
}

module decorative_line_ft(from, to) {
    diff = to - from; 
    length = sqrt(diff.x^2 + diff.y^2);
    angle = atan2(diff.y, diff.x);
    translate(from) decorative_line(length, angle) children();
}

module circ_lens_hw(width, height) {
    // The intersection of two circles, such that the lens is
    // 'width' in the X direction and 'height' in the Y.
    // The main case is when height > width - this puts both
    // circles on the X axis.  The distance from the origin to
    // either circle's centre is set by the triangle whose
    // hypotenuse is the radius of the circle, adjacent is the
    // distance to the origin, and opposite is half the height.
    // The adjacent is the radius minus half the width.
    /*
    radius^2 = (radius-hwidth)^2 + hheight^2.
    radius^2 = radius^2 - 2*radius*hwidth + hwidth^2 + hheight^2.
    0 = 0 - 2*radius*hwidth + hwidth^2 + hheight^2.
    2*radius*hwidth = hwidth^2 + hheight^2.
    radius = (hwidth^2 + hheight^2)/2*hwidth.
    angle = 
    */
    hwidth = width/2; hheight = height/2;
    hypsqr = hwidth^2 + hheight^2;
    if (width<height) {
        // the circles are on the X axis
        radius = hypsqr / (2 * hwidth);
        echo(hwidth=hwidth, hheight=hheight, radius=radius); 
        intersection() {
            translate([-radius+hwidth, 0, 0]) circle(r=radius);
            translate([+radius-hwidth, 0, 0]) circle(r=radius);
        }
    } else if (width > height) {
        radius = hypsqr / (2 * hheight);
        intersection() {
            translate([0, -radius+hheight, 0]) circle(r=radius);
            translate([0, +radius-hheight, 0]) circle(r=radius);
        }
    }
}

module circ_lens_ro(radius, overlap) {
    // The intersection of two circles.  Each circle has the
    // given radius.  Overlap is given as a fraction from 0 to 1.
    // Both circles are on the Y axis, offset by (radius*(offset/2)).
    assert(overlap>0, "Overlap must be > 0, circles must overlap");
    assert(overlap<1, "Overlap must be < 1, circles must overlap");
    offset = radius*(1-overlap);
    intersection() {
        translate([0, -offset, 0]) circle(radius);
        translate([0, +offset, 0]) circle(radius);
    }
}

module diamond(width, height) {
    // A 2D diamond centred on the origin of given X width and Y height.
    w2=width/2; h2=height/2;
    polygon([[+w2, 0], [-0, +h2], [-w2, 0], [0, -h2]]);
}

module diamond_wavelet() {
    // A simplified wavelet of a diamond that goes from 0 at the origin and
    // at 1,1 and is at +1/-1 on the other diagonals (0,1 and 1,0).  Scale
    // and rotate this to fit the design you want.  It's a weird shape of
    // octahedron, if you will.
    polyhedron(
        points=[
            [0, 0, 0],
            [1, 0, 1], [1, 0, -1],
            [0, 1, 1], [0, 1, -1],
            [1, 1, 0]
        ],
        faces=[
            [0, 1, 2], [0, 2, 4], [0, 4, 3], [0, 3, 1],
            [5, 2, 1], [5, 4, 2], [5, 3, 4], [5, 1, 3],
        ]
    );
}

module diamond_wavelet_i() {
    // The 'inverse' of the diamond wavelet - with +1/-1 at the origin and
    // 1,1 and zero at the other diagonals.  A few more faces involved?
    polyhedron(
        points=[
            // the diamond wavelet
            [0, 0, 1], [0, 0, -1],
            [1, 0, 0], [0, 1, 0],
            [1, 1, 1], [1, 1, -1]
        ],
        faces=[
            [0, 2, 1], [0, 1, 3],
            [0, 3, 2], [1, 2, 3],
            [4, 2, 3], [5, 3, 2],
            [4, 3, 5], [4, 5, 2]
        ],
        convexity=2
    );
}

module diamond_wavelet_both() {
    // The diamond wavelet and its inverse, without the pesky internal
    // faces, going to 2 in the X axis.
    polyhedron(
        points=[
            [0, 0, 0],  // 0
            [1, 0, 1], [1, 0, -1], // 1, 2
            [2, 0, 0],  // 3
            [0, 1, 1], [0, 1, -1], // 4, 5
            [1, 1, 0],  // 6
            [2, 1, 1], [2, 1, -1], // 7, 8
        ],
        faces=[
            // top faces
            [0, 4, 1], [1, 4, 6, 3], [3, 6, 7],
            // bottom faces
            [0, 2, 5], [5, 2, 3, 6], [3, 8, 6],
            // sides
            [0, 1, 3, 2], [3, 7, 8], [7, 6, 8], [6, 4, 5], [4, 0, 5]
        ],
        convexity=2
    );
}

module tile(n_x, n_y) {
    for(x=[0:n_x-1]) for(y=[0:n_y-1])
        translate([x, y, 0]) children();
}

* scale([10, 10, 2]) diamond_wavelet_both();

scale([10, 10, 1]) union() {
    tile(3, 3) scale([0.5, 0.5, 1]) union() {
        rotate([0, 0, 0]) diamond_wavelet_both();
        translate([2, 2, 0]) rotate([0, 0, 180]) diamond_wavelet_both();
    }
    rotate([0, 0, 90]) tile(3, 3) scale([0.5, 0.5, 1]) union() {
        rotate([0, 0, 0]) diamond_wavelet_both();
        translate([2, 2, 0]) rotate([0, 0, 180]) diamond_wavelet_both();
    }
    rotate([0, 0, 180]) tile(3, 3) scale([0.5, 0.5, 1]) union() {
        rotate([0, 0, 0]) diamond_wavelet_both();
        translate([2, 2, 0]) rotate([0, 0, 180]) diamond_wavelet_both();
    }
    rotate([0, 0, 270]) tile(3, 3) scale([0.5, 0.5, 1]) union() {
        rotate([0, 0, 0]) diamond_wavelet_both();
        translate([2, 2, 0]) rotate([0, 0, 180]) diamond_wavelet_both();
    }
}

* union() {
    decorative_arc(100) circ_lens_ro(50, 0.5);

    translate([200, 0, 0]) decorative_arc(100, 180, 360) circ_lens_ro(50, 0.5);
}

* union() {
    decorative_arc(25) circ_lens_ro(10, 0.6);
    translate([75+25, 0, 0]) decorative_arc(75, 180, 360) circ_lens_ro(10, 0.6);
    
    decorative_arc(75) circ_lens_ro(10, 0.6);
    translate([75+25, 0, 0]) decorative_arc(25, 180, 360) circ_lens_ro(10, 0.6);
}

module decorative_r_square(side_len, arc_len, line_wid, line_off) union() {
    in_side_len = side_len - (arc_len*2);
    assert(in_side_len > 0, "Side length must accomodate at least two arcs");
    arc_off = side_len - arc_len;
    translate([arc_len, 0, 0]) decorative_line(in_side_len, 00)
      circ_lens_ro(line_wid, line_off);
    translate([arc_off, arc_len, 0]) decorative_arc(arc_len, 270, 360)
      circ_lens_ro(line_wid, line_off);
    translate([side_len, arc_len, 0]) decorative_line(in_side_len, 90)
      circ_lens_ro(line_wid, 0.5);
    translate([arc_off, arc_off, 0]) decorative_arc(arc_len, 0, 90)
      circ_lens_ro(line_wid, 0.5);
    translate([arc_len, side_len, 0]) decorative_line(in_side_len, 00)
      circ_lens_ro(line_wid, 0.5);
    translate([arc_len, arc_off, 0]) decorative_arc(arc_len, 90, 180)
      circ_lens_ro(line_wid, 0.5);
    translate([0, arc_len, 0]) decorative_line(in_side_len, 90)
      circ_lens_ro(line_wid, 0.5);
    translate([arc_len, arc_len, 0]) decorative_arc(arc_len, 180, 270)
      circ_lens_ro(line_wid, 0.5);
}

* translate([100+10+00, 0, 0]) decorative_r_square(100, 25, 10, 0.5);
* translate([100+10+20, 20, 0]) decorative_r_square(60, 10, 10, 0.5);

module decorative_key(side_len, line_wid) {
    // A greek key, joining at the mid point of the long vertical side.
}

decorative_key(100);