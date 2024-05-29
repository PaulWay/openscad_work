$fa = 5;
$fs = 1;

include <../libs/pw_primitives.scad>;

width = 20;
hb_radius = 20; hb_thick=3;
bolt_or = 6; bolt_ir = 2.5;

difference() {  // Torch clip
    hull() {  // Body of the torch clip
        translate([-10, 0, 0]) cylinder(h=8, d=width);
        translate([+10, 0, 0]) cylinder(h=8, d=width);
    };
    translate([0, 0, 3]) union() { // minus:
        translate([-5, 0, 0]) cylinder(h=5.01, d=12);  // entry hole
        hull() {  // lower full-width slot
            translate([-5, 0, 0]) cylinder(h=2.5, d=12);
            translate([10, 0, 0]) cylinder(h=2.5, d=12);
        };
        hull() {  // upper pin-width slot
            translate([-5, 0, 0]) cylinder(h=5.01, d=8);
            translate([10, 0, 0]) cylinder(h=5.01, d=8);
        };
    };
};
difference() {  // Nicer join from torch clip to handlebar mount
    // translate([0, 0, -8]) hull() {  // Body of the torch clip
    //     translate([-10, 0, 0]) cylinder(h=8, d1=width-4, d2=width);
    //     translate([+10, 0, 0]) cylinder(h=8, d1=width-4, d2=width);
    // };
    translate([0, 0, +2]) hull() {
        translate([-10, 0, 0]) sphere(d=width);
        translate([+10, 0, 0]) sphere(d=width);
    }
    translate([0, -10.05, -hb_radius+hb_thick]) rotate([-90, 0, 0])
      cylinder(h=width+0.1, r=hb_radius-hb_thick);
    translate([0, 0, width/2]) cube([width*2, width, width], center=true);
};
// Handlebar mount half-circle with bolt rings
translate([0, -10, -hb_radius+hb_thick]) rotate([-90, 0, 0]) union() {  
    intersection() {
        pipe_rt(width, hb_radius, hb_thick);
        translate([-hb_radius, -hb_radius, 0]) 
          cube([hb_radius*2, hb_radius, width]);
    }
    translate([(hb_radius+hb_thick), 0, width/2]) rotate([90, 0, 0]) union() {
        pipe_oi(hb_thick, bolt_or, bolt_ir);
        translate([-hb_thick, -(bolt_or+bolt_ir+0.7), 0]) rotate([0, 0, 45]) 
          cube([bolt_or-bolt_ir+1, bolt_or-bolt_ir, hb_thick]);
        translate([-hb_thick-bolt_ir, bolt_or+0.7, 0]) rotate([0, 0, -45]) 
          cube([bolt_or-bolt_ir+1, bolt_or-bolt_ir, hb_thick]);
    }
    translate([-(hb_radius+hb_thick), 0, width/2]) rotate([90, 0, 0]) union() {
        pipe_oi(hb_thick, bolt_or, bolt_ir);
        translate([0, -bolt_or, 0]) rotate([0, 0, -45]) 
          cube([bolt_or-bolt_ir+1, bolt_or-bolt_ir, hb_thick]);
        translate([bolt_ir, bolt_ir+1, 0]) rotate([0, 0, 45]) 
          cube([bolt_or-bolt_ir+1, bolt_or-bolt_ir, hb_thick]);
    }
};
