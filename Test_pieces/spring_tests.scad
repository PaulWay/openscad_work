include <../libs/pw_primitives.scad>;
include <../libs/pw_funcs.scad>;

// rect_circ_spring(10, 15, 180, 20, 10, 1.5);
// translate([10, -100, 0]) cube([5, 100, 10]);
// translate([-15, -100, 0]) cube([5, 100, 10]);

module circ_flexer(in_radius, out_radius, angle, segments, height, thickness) union() {
    // like the rect_flexer but with semi-circles 
    assert (segments > 1, "must have at least two segments");
    rad_diff = out_radius - in_radius;
    seg1 = (segments-1);
    step_angle = angle / seg1;
    in_rad = 2;
}

* union() {
    cube([100, 1, 10]);
    rotate([0, 0, 10]) cube([100, 1, 10]);
    r=200*tan(10/2);
    rotate([0, 0, 10/2]) translate([100-r, 0, 0]) cylinder(h=10, d=r);
}

$fa=2;
// _/ \ screw
linear_extrude(40, twist=3600) polygon(polar_to_cart([
    each p_arc(18, 90),
    each p_translate(p_arcline(18, 20, 90), [0, 90]),
    each p_translate(p_arc(20, 90), [0, 180]),
    each p_translate(p_arcline(20, 18, 90), [0, 270])
]));

// V screw
* linear_extrude(40, twist=3600) polygon(polar_to_cart([
    each p_translate(p_arcline(18, 20, 180), [0, 0]),
    each p_translate(p_arcline(20, 18, 180), [0, 180])
]));