include <pw_primitives.scad>;

$fn = 90;

translate([0, 0, 2.5]) difference() {
    cube([158, 196, 5], center=true);
    cube([120, 160, 5.02], center=true);
    translate([-50, -90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([ 50, -90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([-50,  90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([ 50,  90, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([-70,   0, -0.01]) cylinder(d=8, h=5.03, center=true);
    translate([ 70,   0, -0.01]) cylinder(d=8, h=5.03, center=true);
};

translate([-(120/2+5), -(200+160/2+5), 0]) rotate([90, 0, 90]) 
  rectangular_pipe_bend(160, 120, 5, 200, 30);

translate([160-(120/2+5), -(200+160/2+5), 0]) rotate([90, -3, 90]) 
  rectangular_pipe_bend_curved_ends(
    160, 120, 5, 200, 30, 5, 2, join_b=false
  );