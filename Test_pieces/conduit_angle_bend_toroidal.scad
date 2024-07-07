include <../libs/pw_primitives.scad>;

$fa=2;

outer_rad = 200;
inner_dia = 56;
inner_rad = inner_dia/2;
thickness = 2.5;
// Swept angle is the 'exposed' bend; the join is going to cover 
swept_angle = 90/3;
join_overlap = 2.5;
flange_angle = 10;

translate([-(outer_rad-inner_rad), 0, 0]) rotate([90, 0, 0]) union() {
    // The segment of pipe, which starts flange_angle up and goes to swept_angle
    rotate([0, 0, flange_angle]) toroidal_pipe(outer_rad, inner_rad, thickness, swept_angle);
    // The outer flange, which goes up to flange_angle
    rotate([0, 0, 0]) 
      toroidal_pipe(outer_rad+thickness, inner_rad+thickness, thickness, flange_angle);
    // The overlap, which makes sure that that those two hollow toroids connect
    rotate([0, 0, flange_angle - join_overlap])
      toroidal_pipe(outer_rad, inner_rad, thickness*2, join_overlap);
}

join_length = 20;
overlap_length = 1;
is_outer = true;
join_thickness = inner_rad+thickness+(is_outer ? thickness : 0);

* translate([-(outer_rad-inner_rad), 0, join_length]) rotate([90, 0, 0]) union() {
    // Toroidal pipe segment, total of swept_angle degrees
    rotate([0, 0, 0]) toroidal_pipe(outer_rad, inner_rad, thickness, swept_angle);
    // Straight flange - this goes below XY plane before outer rotation
    translate([outer_rad-inner_rad, 0, 0]) rotate([90, 0, 0]) 
      pipe_rt(join_length, join_thickness, thickness);  // thickness here goes in
    // Join cylinder just to make sure
    translate([outer_rad-inner_rad, 0, 0]) rotate([90, 0, 0]) 
      pipe_rt(overlap_length, join_thickness, thickness+(is_outer ? thickness : 0));
}