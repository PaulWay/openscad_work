include <../libs/pw_primitives.scad>;

$fn = 90;

module interface_plate() translate([0, 0, 2.5]) difference() {
    cube([158, 196, 5], center=true);
    cube([120, 160, 5.02], center=true);
    translate([-50, -90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([ 50, -90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([-50,  90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([ 50,  90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([-70,   0, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([ 70,   0, -0.01]) cylinder(d=8, h=5.03, center=true);
};

* union() {
    translate([-(120/2+5), -(100+160/2+5), 0]) rotate([90, 0, 90]) 
      rectangular_pipe_bend(160, 120, 5, 100, 45);
    interface_plate();
}

* translate([0, 0, 0]) union() {
    translate([-(120/2+5), -(100+160/2+5), 0]) rotate([90, 0, 90]) 
      rectangular_pipe_bend_curved_ends(
        // width, height, thickness, inner_radius, bend_angle, join_length,
        // overlap_len, join_a=true, join_b=true, flange_a=true, flange_b=true,
        // curved_a=false, curved_b=false
        160, 120, 5, 100, 45, 10, 5, join_a=false
      );
    interface_plate();
}

rectangular_pipe_bend(