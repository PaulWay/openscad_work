include <pw_primitives.scad>;

bend_radius = 100;
bend_angle = 60;
pipe_radius = 25;
thickness = 3;
join_length = 25;
overlap_len = 5;

difference() {
    $fn=50;
    torus(bend_radius+thickness, pipe_radius+thickness, bend_angle);
    rotate([0, 0, -0.1]) torus(bend_radius, pipe_radius, bend_angle+0.2);
}
translate([bend_radius-pipe_radius, overlap_len, 0]) rotate([90, 0, 0])
    ring_oi(join_length, pipe_radius+thickness*2, pipe_radius+thickness);

rotate([0, 0, bend_angle]) translate([bend_radius-pipe_radius, join_length-overlap_len, 0])
  rotate([90, 0, 0]) 
    ring_oi(join_length, pipe_radius+thickness*2, pipe_radius+thickness);
    
