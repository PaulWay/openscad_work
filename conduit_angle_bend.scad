include <pw_primitives.scad>;

bend_radius = 100;
pipe_radius = 25;
bend_angle = 60;
thickness = 3;
join_length = 25;
overlap_len = 5;

$fn=50;

conduit_angle_bend(
    bend_radius, pipe_radius, bend_angle, thickness, join_length, overlap_len, false, true
);