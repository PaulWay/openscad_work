module rounded_pipe_clip(inner_dia, outer_dia, inlet_dia, height, add_rounding=true) {
    // A circlip that can fit around a pipe or rod and attach something
    // else to it non-permanently.  The size of the inlet must be smaller
    // than the inner diameter; OTOH the inlet size at the moment is
    // slightly smaller than that given, because of the size of the
    // cylinders on each side.  If 'add_rounding' is turned off the
    // inlet size will be correct, but it won't be as easy to push onto
    // the rod.  For relatively small differences between inner and
    // outer diameter, this won't be more than a small fraction of
    // the inlet_dia size.
    assert(inlet_dia < inner_dia, "Inlet must be smaller than inner diameter for clip to hold");
    irad = inner_dia/2;
    thick = (outer_dia-inner_dia)/2;
    // This is a bit of experimentation.  The right angle triangle
    // we're calculating the angle for has its hypotenuse as the inner
    // radius and the opposite side as half the inlet diameter.  But
    // because of the rounding, that theoretically puts the actual
    // touch point somewhere between the inner radius and the middle
    // of the clip.  But when I try that, it makes the gap much smaller
    // than inlet_dia.
    // In practical testing (see below) I've found that the inner
    // radius is slightly too large - i.e I needed to reduce it slightly
    // to make the gap fit.  This factor needs to be closer to 1 the
    // smaller the ratio of 
    s_factor = (add_rounding ? sqrt(sqrt(inlet_dia/inner_dia)) : 1);
    angle = asin((inlet_dia/2)/(irad*s_factor))*2;
    echo (inlet_dia=inlet_dia, s_factor=s_factor, angle=angle);
    rotate([0, 0, angle/2]) union() {
        rotate_extrude(angle=360-angle) translate([irad, 0, 0]) square([thick, height]);
        if (add_rounding) {
            translate([irad+thick/2, 0, 0]) cylinder(h=height, d=thick);
            rotate([0, 0, -angle]) 
              translate([irad+thick/2, 0, 0]) cylinder(h=height, d=thick);
        }
    }
}

$fn=$preview ? 40 : 80;
* translate([24/2-4/2, 0, 0]) rounded_pipe_clip(16, 24, 14, 20);
* translate([-24/2+4/2, 0, 0]) rotate([0, 0, 180]) 
  translate([0, 20/2, 24/2]) rotate([90, 0, 0])
  rounded_pipe_clip(16, 24, 14, 20);
// translate([-5/2, 0, 20/2]) rotate([0, 90, 0]) cylinder(h=5, d=16);

// testing the actual dimension of the inlet...
// translate([-5, 6.3, 0]) rounded_pipe_clip(16, 24, 14, 20, false);
translate([-4.9, 26.9, 0]) rounded_pipe_clip(16, 24, 14, 20, true);
color("green") translate([0, 20, 0]) cube([1, 14, 1]);

translate([-7.8, 4.35, 0]) rounded_pipe_clip(16, 24, 10, 20, true);
color("green") translate([1, 0, 0]) cube([1, 10, 1]);
