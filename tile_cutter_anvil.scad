// include <pw_primitives.scad>;

length = 30;
width = 38;
height = 18.5;
back_width = 13;
back_length = 9;
diag_back_length = (back_length-back_length*sin(45));
back_side_angle = 45;
front_side_angle = 15;

$fn = 20;
difference() {
    // the whole area - slightly high and smaller to make every other
    // subtraction not face-overlap
    translate([-width/2, 0.01, 0.01]) cube([width, length, height-0.02]);
    // the central split for the arm
    translate([-2, -0.01, 0]) cube([4, back_length, height]);
    // the fulcrum hole
    translate([-back_width/2-0.02, back_length/2, height/2]) rotate([0, 90, 0]) 
        cylinder(h=back_width+0.04, d=4);
    // the back flat faces
    mirror([0, 0, 0]) translate([back_width/2+0.01, 0, 0]) 
        cube([(width-back_width)/2, back_length, height]);
    mirror([1, 0, 0]) translate([back_width/2+0.01, 0, 0]) 
        cube([(width-back_width)/2, back_length, height]);
    // the back angled faces
    mirror([0, 0, 0]) translate([(back_width/2+0.01)+back_width/2, diag_back_length, 0]) 
        rotate([0, 0, back_side_angle]) 
        cube([(width-back_width)/2*sqrt(2), back_length, height]);
    mirror([1, 0, 0]) translate([(back_width/2+0.01)+back_width/2, diag_back_length, 0]) 
        rotate([0, 0, back_side_angle]) 
        cube([(width-back_width)/2*sqrt(2), back_length, height]);
    // the front angled faces
    mirror([0, 0, 0]) translate([0, length-5*cos(front_side_angle), 0]) 
        rotate([0, 0, front_side_angle]) cube([width/2, 10, height]);
    mirror([1, 0, 0]) translate([0, length-5*cos(front_side_angle), 0]) 
        rotate([0, 0, front_side_angle]) cube([width/2, 10, height]);
    // the front centre notch
    translate([0, length-4, 0]) cylinder(h=height, r=4);
};