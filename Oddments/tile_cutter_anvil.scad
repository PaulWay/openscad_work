// include <../libs/pw_primitives.scad>;

length = 30; // total length in Y
width = 38; // total width in X
height = 18.5; // height in Z
back_width = 13; // width in X across back face
fulcrum_hole_diam = 5;
fulcrum_hole_forward = 5;
hbackw = back_width/2;
arm_cutout_width = 4;
arm_cutout_length = 13; // centre
back_length = 10; // length in Y from back face to start of outer angle
back_side_angle = 40; // angle of back outer sides
front_notch_diameter = 8; // diameter of circle for front notch
// for right triangle ABC with B=90deg, where we know length AB and angle A,
// C=90-A, BC = AB*sin(A)/sin(C), CA=AB*sin(B)/sin(C).
diag_back_length = ((width-back_width)/2)*sin(back_side_angle)/sin(90-back_side_angle);
diag_back_width = ((width-back_width)/2)/sin(90-back_side_angle);
// for right triangle ABC with B=90deg, where we know lengths AB and BC,
// A=atan(BC/AB)
front_notch_r = front_notch_diameter/2;
front_angle_forward = length-front_notch_r;
front_side_angle = atan(front_notch_r/(width/2));
fac_wid = (width/2)/sin(90-front_side_angle);

module front_corner_rotated_cube(x, y, z, angle) {
    translate([0, y, 0]) rotate([0, 0, angle]) translate([0, -y, 0])
        cube([x, y, z]);
};

$fn = 20;
difference() {
    // the whole area - slightly high and smaller to make every other
    // subtraction not face-overlap
    translate([-width/2, 0.01, 0.01]) cube([width, length-0.02, height-0.02]);
    // the central cutout for the arm
    translate([-arm_cutout_width/2, 0, 0])
        cube([arm_cutout_width, arm_cutout_length, height]);
    // the fulcrum hole
    translate([-back_width/2-0.02, back_length/2, height/2]) rotate([0, 90, 0]) 
        cylinder(h=back_width+0.04, d=fulcrum_hole_diam);
    // the back flat faces
    mirror([0, 0, 0]) translate([back_width/2+0.01, 0, 0]) 
        cube([(width-back_width)/2, back_length, height]);
    mirror([1, 0, 0]) translate([back_width/2+0.01, 0, 0]) 
        cube([(width-back_width)/2, back_length, height]);
    // the back angled faces
    mirror([0, 0, 0]) translate([back_width/2, back_length-diag_back_length, 0]) 
        front_corner_rotated_cube(
            diag_back_width, diag_back_length, height, back_side_angle
        );
    mirror([1, 0, 0]) translate([back_width/2, back_length-diag_back_length, 0]) 
        front_corner_rotated_cube(
            diag_back_width, diag_back_length, height, back_side_angle
        );
    // the front angled faces
    mirror([0, 0, 0]) translate([0, front_angle_forward, 0])
        front_corner_rotated_cube(fac_wid, front_notch_r, height, front_side_angle);
    mirror([1, 0, 0]) translate([0, front_angle_forward, 0])
        front_corner_rotated_cube(fac_wid, front_notch_r, height, front_side_angle);
    // the front centre notch
    translate([0, length-(front_notch_diameter/2), 0])
        cylinder(h=height, d=front_notch_diameter);
};