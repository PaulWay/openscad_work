include <../libs/pw_primitives.scad>;

$fa=2;

outer_rad = 200;
inner_dia = 57;
inner_rad = inner_dia/2;
thickness = 2.5;
// Swept angle is the 'exposed' bend; the join is going to cover 
swept_angle = 20;
join_overlap = 2.5;
flange_angle = 10;

conduit_angle_bend(
    outer_rad, inner_rad, swept_angle, join_overlap, 30,
    curved_a=true, curved_b=true, join_b=true, flare_b=false
);
