include <../libs/pw_primitives.scad>;

$fa=2;

outer_rad = 100;
inner_dia = 56;
inner_rad = inner_dia/2;
thickness = 2.5;
// Swept angle is the 'exposed' bend; the join is going to cover 
// swept_angle = 90/3;
swept_angle = 45;
join_overlap = 25;
flange_angle = 10;

rot(x=90) txl(x=inner_dia-outer_rad, y=25) conduit_angle_bend(
    outer_rad, inner_rad, swept_angle, thickness, join_overlap
    , flare_a=false
);
