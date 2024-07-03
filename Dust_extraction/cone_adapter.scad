include <../libs/pw_primitives.scad>;

$fn=100;

in_join_thickness = 3;
wall_thickness = 3;
step_thickness = wall_thickness - in_join_thickness;
flange_height = 30;
cone_height = 40;

// radii not diameters
//top_inner = 95.5 / 2;
//top_outer = top_inner + in_join_thickness;
top_outer = 35.3 / 2;
top_inner = top_outer - 2;
top_fl_outer = top_outer;
top_fl_inner = top_inner - step_thickness;

//bottom_outer = 110.9 / 2;
//bottom_inner = bottom_outer - in_join_thickness;
bottom_inner = 39.5 / 2;
bottom_outer = bottom_inner + wall_thickness;
bottom_fl_outer = bottom_outer + step_thickness;
bottom_fl_inner = bottom_inner;

union() {
    translate([0, 0, 0]) pipe_oi(
        flange_height, bottom_outer, bottom_inner
    );
    translate([0, 0, flange_height-0.01]) hollow_cone_oi(
        cone_height, bottom_fl_outer, bottom_fl_inner, top_fl_outer, top_fl_inner
    );
    translate([0, 0, flange_height+cone_height-0.01]) pipe_oi(
        flange_height+0.01, top_outer, top_inner
    );
}