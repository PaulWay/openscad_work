include <../libs/pw_primitives.scad>;

module board_cutout(x, y, z, fillet_rad, hole_array=[], hole_dia=0, hole_len=0) {
    // a 'cutout' that will sit a small circuit board within a larger box.  The board
    // is x by y, and its corners are chamfered by fillet_rad.  Note that this shape is
    // a 'negative' to remove from your larger block, which means that it goes into the
    // negative Z; the 'top' of the cutout is at zero because this is done relative to
    // the height of the thing you're cutting out of.
    translate([0, 0, -z]) filleted_cube(x, y, z, fillet_rad);
    for(point = hole_array) {
        translate([point.x, point.y, -z-hole_len+epsilon]) cylinder(h=hole_len, d=hole_dia);
    }
}

function corner_offset_points(x, y, x_off, y_off) =
    // return four 2D points, at offsets from the four corners of a rectangle.
    [[x_off, y_off], [x-x_off, y_off], [x_off, y-y_off], [x-x_off, y-y_off]];


module board_supports(hole_array=[], prop_dia, screw_dia, clearance) {
    // This positions a set of cylinders, each with a hole in it for a screw, such that
    // they stick up above the board cutout hole above.  The holes are in [x, y] format
    // measured from the same lower-left corner of your board that you use the board_cutout
    // on.
    union() for(point = hole_array) { 
        translate([point.x, point.y, 0]) pipe_oi(clearance, prop_dia/2, screw_dia/2);
    }
}
