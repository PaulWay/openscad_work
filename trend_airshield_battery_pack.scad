include <pw_primitives.scad>;

body_length=78;
body_width=58;
body_height=26.1;
body_fillet_radius=9.5;
base_width=71;
base_thick=2.2;
step_width=63.7;
step_thick=5;  // from bottom, not from top of base
tab_cyl_height = 3;
tab_cyl_diam = 30;
tab_cyl_length = 10;
tab_cyl_inset_height = 1;

// The actual Trend AirShield battery pack has a solid top box with clips on the
// lower edge, and then the bottom piece has the base and step and holes for the clips.
// For ease of 3D printing and ease of assembly we follow that basic design but
// use bolt / screw holes instead of clips.  The base and step is one part,
// and the top walls, curved top and tab are the other.  Bolts screw in from underneath
// the base to hold the top on.  The top has the cut-outs for the terminals.

union() {
    // base
    cube([body_length, base_width, base_thick]);
    // step
    translate([0, (base_width-step_width)/2, base_thick])
      cube([body_length, step_width, step_thick]);
};

translate([0, base_width+10]) union() {
    // body
    translate([0, (base_width-body_width)/2, base_thick]) hull() {
        cube([body_length, body_width, body_height-body_fillet_radius]);
        // note that if body_fillet_radius*2 > body_height, cylinder will
        // stick out below body and we have no fix for that right now.
        translate([0, body_fillet_radius, body_height-body_fillet_radius])
          rotate([0, 90, 0]) cylinder(h=body_length, r=body_fillet_radius);
        translate([0, body_width-body_fillet_radius, body_height-body_fillet_radius])
          rotate([0, 90, 0]) cylinder(h=body_length, r=body_fillet_radius);
    };
    // tab
    difference() {
        // main tab body
        translate([(tab_cyl_diam/2)-tab_cyl_length, base_width/2, body_height/2])
            cylinder(h=tab_cyl_height, d=tab_cyl_diam);
        // top inset cutout
        translate([
            (tab_cyl_diam/2)-tab_cyl_length, base_width/2,
            body_height/2+(tab_cyl_height-tab_cyl_inset_height)
        ])
            cylinder(h=tab_cyl_inset_height+0.01, d=tab_cyl_diam-tab_cyl_inset_height*2);
    };
}
