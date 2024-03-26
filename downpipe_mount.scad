include <pw_primitives.scad>;

$fn = 32;

width = 32;
length = 140;
height_1 = 15;
height_2 = 70;
base_round_r = 30;
base_hole_sep = 60;
base_hole_diam = 5;
base_hole_ang = 22;
tower_r = 32/2;
top_hole_sep = 117;
top_hole_diam = 4;
top_face_ang = 20;
top_hole_depth = 20;

difference() {
    union() {
        // base
        intersection() {
            cube([length, width, height_1]);
            translate([0, width/2, -0.01]) hull() {
                translate([base_round_r, 0, 0])
                  cylinder(r=base_round_r, h=height_1+0.02);
                translate([length-base_round_r, 0, 0]) 
                  cylinder(r=base_round_r, h=height_1+0.02);
            };
        }
        // lh tower
        translate([tower_r, width/2, 0]) intersection() {
            translate([base_round_r-tower_r, 0, 0]) cylinder(r=base_round_r, h=height_2);
            translate([tower_r-base_round_r, 0, 0]) cylinder(r=base_round_r, h=height_2);
            translate([-tower_r, -width/2, 0]) cube([tower_r*2, width, height_2]);
            translate([-tower_r, -(sin(top_face_ang)*width), 0]) rotate([top_face_ang, 0, 0]) 
              cube([tower_r*2, width*2, height_2-sin(top_face_ang)*width]);
        }
        // rh tower
        translate([length-tower_r, width/2, 0]) intersection() {
            translate([base_round_r-tower_r, 0, 0]) cylinder(r=base_round_r, h=height_2);
            translate([tower_r-base_round_r, 0, 0]) cylinder(r=base_round_r, h=height_2);
            translate([-tower_r, -width/2, 0]) cube([tower_r*2, width, height_2]);
            translate([-tower_r, -(sin(top_face_ang)*width), 0]) rotate([top_face_ang, 0, 0]) 
              cube([tower_r*2, width*2, height_2-sin(top_face_ang)*width]);
        }
    }
    // minus base holes
    translate([length/2, width/2, -0.01]) rotate([0, 0, base_hole_ang]) union() {
        translate([-base_hole_sep/2, 0, 0]) cylinder(d=base_hole_diam, h=height_1+0.02);
        translate([base_hole_sep/2, 0, 0]) cylinder(d=base_hole_diam, h=height_1+0.02);
    }
    // minus top holes
    translate([length/2, (width+sin(top_face_ang)*width)/2, height_2-top_hole_depth]) 
    rotate([top_face_ang, 0, 0]) union() {
        translate([-top_hole_sep/2, 0, 0]) cylinder(d=top_hole_diam, h=top_hole_depth);
        translate([top_hole_sep/2, 0, 0]) cylinder(d=top_hole_diam, h=top_hole_depth);
    }
}
