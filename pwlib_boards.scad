module board_cutout(x, y, z, chamfer_rad, hole_array=[], hole_dia=0, hole_len=0) {
    // a 'cutout' that will sit a small circuit board within a larger box.  The board
    // is x by y, and its corners are chamfered by chamfer_rad.  Note that this shape is
    // a 'negative' to remove from your larger block, which means that it goes into the
    // negative Z; the 'top' of the cutout is at zero because this is done relative to
    // the height of the thing you're cutting out of.
    c2 = chamfer_rad*2;
    translate([chamfer_rad, chamfer_rad, -z]) minkowski() {
        cylinder(h=chamfer_rad, r=chamfer_rad);
        cube([x-c2, y-c2, z-chamfer_rad]);
    }
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
