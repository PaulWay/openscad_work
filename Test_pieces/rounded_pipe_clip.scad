include <../libs/pw_primitives.scad>;

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
    rotate([0, 0, angle/2]) union() {
        rotate_extrude(angle=360-angle) translate([irad, 0, 0]) square([thick, height]);
        if (add_rounding) {
            translate([irad+thick/2, 0, 0]) cylinder(h=height, d=thick);
            rotate([0, 0, -angle]) 
              translate([irad+thick/2, 0, 0]) cylinder(h=height, d=thick);
        }
    }
}

module crenell_ring(segments, height, inner_rad, thickness, angle_tol=0) {
    seg_angle = 360/(segments);
    hsegang = (seg_angle - angle_tol) / 2;
    for(segment = [0:segments-1]) {
        angle = seg_angle*segment;
        rot(z=angle) rotate_extrude(angle=hsegang)
          txl(x=inner_rad) square([thickness, height]);
    }
}

$fn=$preview ? 40 : 80;

// Trialling one form of a 90 degree clip, set up so that minimal support
// is needed: by rotating and flattening it, only two small places overhang
// rather than a whole under-edge.
* flatten(20) txl(z=10) rotate([45, 0, 0]) 
union() {
    translate([24/2-4/2, 0, -12]) rounded_pipe_clip(16, 24, 14, 24);
    translate([-24/2+4/2, 0, -12]) rotate([0, 0, 180]) 
      translate([0, 24/2, 24/2]) rotate([90, 0, 0])
      rounded_pipe_clip(16, 24, 14, 24);
}
// translate([-5/2, 0, 20/2]) rotate([0, 90, 0]) cylinder(h=5, d=16);

// testing the actual dimension of the inlet...
// translate([-5, 6.3, 0]) rounded_pipe_clip(16, 24, 14, 20, false);
* translate([-4.9, 26.9, 0]) rounded_pipe_clip(16, 24, 14, 20, true);
* color("green") translate([0, 20, 0]) cube([1, 14, 1]);

* translate([-7.8, 4.35, 0]) rounded_pipe_clip(16, 24, 10, 20, true);
* color("green") translate([1, 0, 0]) cube([1, 10, 1]);

// A cap for the rod so that mesh can be pulled over it easily.
difference() {
    intersection() {
        sphere(r=24);
        cylinder(h=24, d1=24, d2=24*2.8);
    }
    translate([0, 0, -0.01]) cylinder(h=21, d=18.3);
}

// A pipe clip that can be connected to another via a central bolt hole.
// May need to add a set of V slots in the cylinder to prevent it
// twisting?
* difference() {
    union() {
        txl(x=24/2) rounded_pipe_clip(16, 24, 14, 24);
        translate([0, 0, 24/2]) rot(y=90) union() {
            cylinder(h=4, d=16);
            txl(z=-1) rot(z=0)
              crenell_ring(16, 1, 4, 4, angle_tol=2);
        }
    }
    union() {
        translate([-5/2-0.01, 0, 24/2]) rot(y=90) cylinder(h=7, d=4);
        translate([3, 0, 24/2]) rot(y=90) cylinder(h=2, d=8);
    }
}

// testing the actual dimension of the inlet...
* union() {
    // translate([-5, 6.3, 0]) rounded_pipe_clip(16, 24, 14, 20, false);
    translate([-4.9, 26.9, 0]) rounded_pipe_clip(16, 24, 14, 20, true);
    color("green") translate([0, 20, 0]) cube([1, 14, 1]);
    
    translate([-7.8, 4.35, 0]) rounded_pipe_clip(16, 24, 10, 20, true);
    color("green") translate([1, 0, 0]) cube([1, 10, 1]);
}
