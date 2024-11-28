module holding_clip_v1(inner_width, outer_width, clip_height, length) {
    // A hexahedral clip that is easy to put in but harder to pull out.
    // It's designed to be printed parallel to the XY plane and pushed
    // down into the bracket (below).
    assert(inner_width < outer_width, "Inner must be less than outer width");
    iw2 = inner_width/2;  ow2 = outer_width/2;  diff= (ow2-iw2)*2;
    // This is constructed into the -Y direction so it can be rotated down
    // onto the XY plane.
    rotate([-90, 0, 0]) linear_extrude(length) polygon([
        // left hand (-Y) side, clockwise
        [-iw2, -clip_height], [-ow2, diff-clip_height], [-iw2, 0],
        // right hand (+Y) side, clockwise
        [iw2, 0], [ow2, diff-clip_height], [iw2, -clip_height]
    ]);
}

module holding_clip_v2(inner_width, outer_width, clip_height, length, waist_height=undef) {
    // A hexahedral clip that is easy to put in but harder to pull out.
    // It's designed to be printed parallel to the XY plane and pushed
    // down into the bracket (below).
    assert(inner_width < outer_width, "Inner must be less than outer width");
    iw2 = inner_width/2;  ow2 = outer_width/2;  diff= (ow2-iw2)*2;
    wheight = (waist_height != undef) ? -waist_height : diff-clip_height;
    assert(
        (waist_height == undef || waist_height < clip_height),
        "If set, waist must be within clip height"
    );
    // This is constructed into the -Y direction so it can be rotated down
    // onto the XY plane.
    rotate([-90, 0, 0]) linear_extrude(length) polygon([
        // left hand (-Y) side, clockwise
        [-iw2, -clip_height], [-ow2, wheight], [-iw2, 0],
        // right hand (+Y) side, clockwise
        [iw2, 0], [ow2, wheight], [iw2, -clip_height]
    ]);
}

module holding_bracket(
    inner_width, outer_width, clip_height, length, side_thick, base_thick,
    waist_height=undef,
) {
    assert(inner_width < outer_width, "Inner must be less than outer width");
    assert(
        (waist_height == undef || waist_height < clip_height),
        "If set, waist must be within clip height"
    );
    iw2 = inner_width/2;  ow2 = outer_width/2;  diff= (ow2-iw2)*2;
    wheight = (waist_height != undef) ? -waist_height : diff-clip_height;
    // This is constructed into the -Y direction so it can be rotated down
    // onto the XY plane.  The base is on the XY plane, which means that a
    // holding clip must be lifted by the base thickness to match.
    translate([0, 0, base_thick]) rotate([-90, 0, 0]) linear_extrude(length) polygon([
        // left hand (-Y) side, up and then anti-clockwise
        [-iw2, 0], [-ow2, wheight], [-iw2, -clip_height],
        [-ow2-side_thick, -clip_height],
        // across the base
        [-ow2-side_thick, base_thick], [ow2+side_thick, base_thick],
        // right hand (+Y) side, anti-clockwise
        [ow2+side_thick, -clip_height], [iw2, -clip_height],
        [ow2, wheight], [iw2, 0],
    ]);
}

wheight = 18;
* translate([0, -12, 0]) difference() {
    union() {
        holding_bracket(10, 12, 20, 10, 5, 5, waist_height=wheight);
        translate([-15, 0, 0]) cube([30, 10, 5]);
    }
    translate([-14, 2.5, -0.1]) linear_extrude(1, convexity=2) 
      text(str("waist ", str(wheight)), size=5.5);
}

* difference() {
    holding_clip_v2(10, 12, 20, 30, waist_height=wheight);
    translate([3, 1, 19]) rotate([0, 0, 90]) linear_extrude(1.1) 
      text(str("waist ", str(wheight)), size=5.5);
}
