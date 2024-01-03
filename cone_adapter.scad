include <pw_primitives.scad>;

$fn=100;

in_join_thickness = 3;
wall_thickness = 5;
step_thickness = wall_thickness - in_join_thickness;
flange_height = 30;
cone_height = 60;

// radii not diameters
top_inner = 95.5 / 2;
top_outer = top_inner + in_join_thickness;
top_fl_outer = top_outer;
top_fl_inner = top_inner - step_thickness;

bottom_outer = 110.9 / 2;
bottom_inner = bottom_outer - in_join_thickness;
bottom_fl_outer = bottom_outer + step_thickness;
bottom_fl_inner = bottom_inner;

union() {
    translate([0, 0, 0]) ring_oi(
        flange_height, bottom_outer, bottom_inner
    );
    translate([0, 0, flange_height-0.01]) hollow_cone_oi(
        cone_height, bottom_fl_outer, bottom_fl_inner, top_fl_outer, top_fl_inner
    );
    translate([0, 0, flange_height+cone_height-0.01]) ring_oi(
        flange_height+0.01, top_outer, top_inner
    );
}