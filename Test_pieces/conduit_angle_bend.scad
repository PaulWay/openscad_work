include <pw_primitives.scad>;

bend_radius = 100;
bend_angle = 45;
thickness = 3;
pipe_dia = 56;
pipe_radius = (pipe_dia)/2;
join_length = 25;
overlap_len = 5;
a_joint_female = true;
b_joint_female = true;

$fn=90;

translate([-(50+thickness), 0, (join_length-overlap_len)]) rotate([90, 0, 0])
conduit_angle_bend_straight_join(
    bend_radius, pipe_radius, bend_angle, thickness, join_length,
    overlap_len, a_joint_female, b_joint_female
);