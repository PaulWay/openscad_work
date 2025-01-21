module arch_inner(width, height) {
    // Produces the 'underside' of a circular arch as a 2D shape to be extruded.
    assert(height >= width/2, "Can't intersect circles with height < width/2");
    hwidth = width/2;
    // half the angle of the triangle from one base, to the peak, to the
    // other base - i.e. the angle from the centre vertical to one base.
    htopang = atan2(hwidth, height);
    // The distance between the peak and one base.
    pk2base = sqrt(hwidth*hwidth + height*height);
    // Due to equivalent triangles, the circle radius is the hypotenuse
    // of the triangle formed by one base, to half way along the line from
    // base to peak.  
    c_rad = (pk2base/2) / sin(htopang);
    c_offset = c_rad - hwidth;
    intersection() {
        translate([-c_offset, 0]) circle(r=c_rad);
        translate([+c_offset, 0]) circle(r=c_rad);
        translate([-hwidth, 0]) square([width, height]);
    }
}

$fn=50;
linear_extrude(10) arch_inner(10, 9);