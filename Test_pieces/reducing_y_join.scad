include <../libs/pw_primitives.scad>;

$fn=100;

std_pipe_in_dia = 50;  std_pipe_in_rad = std_pipe_in_dia / 2;
dbl_pipe_in_dia = sqrt(2) * std_pipe_in_dia;  dbl_pipe_in_rad = dbl_pipe_in_dia / 2;

wall_thick = 3;
join_angle = 45;

cone_height = (std_pipe_in_dia) / sin(join_angle);
bottom_fl_inner = dbl_pipe_in_rad; bottom_fl_outer = bottom_fl_inner + wall_thick;
top_fl_inner = std_pipe_in_rad; top_fl_outer = top_fl_inner + wall_thick;

module tip_on_point(dist1, dist2, angle) {
    translate([dist2, 0, 0]) rotate([0, angle, 0]) translate([-dist1, 0, 0]) children();
}

difference() {
    hollow_cone_oi(
        cone_height, bottom_fl_outer, bottom_fl_inner, top_fl_outer, top_fl_inner
    );
    # tip_on_point(std_pipe_in_rad, dbl_pipe_in_rad, join_angle)
      cylinder(h=100, d=std_pipe_in_dia);
}
difference() {
    tip_on_point(std_pipe_in_rad, dbl_pipe_in_rad, join_angle) pipe_rt(
        100, std_pipe_in_rad+wall_thick, wall_thick
    );
    cylinder(h=cone_height, r1 = bottom_fl_inner, r2 = top_fl_inner);
    translate([0, 0, epsilon-10]) cube([bottom_fl_inner*2, bottom_fl_inner*2, 20], center=true);
}