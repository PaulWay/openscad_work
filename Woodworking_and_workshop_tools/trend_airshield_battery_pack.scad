include <../libs/pw_primitives.scad>;

$fn = 32;
body_length=78;
body_width=58;
body_height=26.1;
body_fillet_radius=9.5;
base_width=71;
base_wid_offset = (base_width-body_width)/2;
base_thick=2.2;
bolt_offset = 5;
batt_space_length = 70;
batt_space_width = 50;
batt_space_height = 20;
batt_splen_offset = (body_length-batt_space_length)/2;
batt_spwid_offset = (body_width-batt_space_width)/2;
step_width=63.7;
step_thick=5;  // from bottom, not from top of base
step_offset = (base_width-step_width)/2;
tab_cyl_height = 3;
tab_cyl_diam = 30;
tab_cyl_length = 10;
tab_cyl_inset_height = 1;
bolt_head_len = 4;
bolt_shaft_len = 16;

// The actual Trend AirShield battery pack has a solid top box with clips on the
// lower edge, and then the bottom piece has the base and step and holes for the clips.
// For ease of 3D printing and ease of assembly we follow that basic design but
// use bolt / screw holes instead of clips.  The base and step is one part,
// and the top walls, curved top and tab are the other.  Bolts screw in from underneath
// the base to hold the top on.  The top has the cut-outs for the terminals.

module base_bolt(x, y) {
    translate([x, y, (bolt_head_len+bolt_shaft_len-0.01)])
      mirror([0, 0, 1]) flat_head_bolt_hole(3, bolt_shaft_len, 6, bolt_head_len);
};

// The base:
* difference() {
    union() {
        // base
        cube([body_length, base_width, base_thick]);
        // step
        translate([0, step_offset, base_thick])
          cube([body_length, step_width, step_thick]);
    };
    // bolt holes
    base_bolt(bolt_offset, step_offset+bolt_offset);
    base_bolt(body_length-bolt_offset, step_offset+bolt_offset);
    base_bolt(bolt_offset, step_offset+step_width-bolt_offset);
    base_bolt(body_length-bolt_offset, step_offset+step_width-bolt_offset);
};

// The top:
//translate([0, base_width+10, 0]) 
translate([0, 0, body_height]) mirror([0, 0, 1]) union() {
    difference() {
        union() {
            // body
            translate([0, base_wid_offset, 0]) hull() {
                cube([body_length, body_width, body_height-body_fillet_radius]);
                // note that if body_fillet_radius*2 > body_height, cylinder will
                // stick out below body and we have no fix for that right now.
                translate([0, body_fillet_radius, body_height-body_fillet_radius])
                  rotate([0, 90, 0]) cylinder(h=body_length, r=body_fillet_radius);
                translate([0, body_width-body_fillet_radius, body_height-body_fillet_radius])
                  rotate([0, 90, 0]) cylinder(h=body_length, r=body_fillet_radius);
            }
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
                    cylinder(
                        h=tab_cyl_inset_height+0.01,
                        d=tab_cyl_diam-tab_cyl_inset_height*2
                    );
            };
        }
        // bolt holes
        translate([0, 0, -bolt_head_len]) union() {
            base_bolt(bolt_offset, step_offset+bolt_offset);
            base_bolt(body_length-bolt_offset, step_offset+bolt_offset);
            base_bolt(bolt_offset, step_offset+step_width-bolt_offset);
            base_bolt(body_length-bolt_offset, step_offset+step_width-bolt_offset);
        }
        // battery space
        translate([batt_splen_offset, base_wid_offset+batt_spwid_offset, -0.01])
        cube([batt_space_length, batt_space_width, batt_space_height]);
        
    };
}


// The back of the circuit board.  This has cutouts for the DC jack (right) and the
// switch (in this case an R13-66 switch, but change the switch width and height to
// suit yourself).

bp_max_wid = 48.35;
bp_max_hgt = 21.15;
bp_min_hgt = 18;
bp_thick = 1.6;
bp_cnr_rad = 4;
ellipse_hgt = 22;
// These X and Y measurements are from the LHS when looking FROM THE CIRCUIT
// BOARD DIRECTION.  That's because we have to then print a channel to mount
// the circuit board 'onto' this.
bp_dc_in_w = 9.5; bp_dc_in_h = 11.5;
bp_dc_in_x = 9.5; bp_dc_in_y = 3;
bp_sw_wid = 20.5; bp_sw_hgt = 13;
bp_sw_x = bp_max_wid-(bp_sw_wid+5); bp_sw_y = 4;
bp_board_h = 1.9;  bp_brd_mt_h = 1.1;  bp_brd_mt_w = 6;
bp_brd_mt_l = 6;  bp_brd_mt_base_l = 3;  bp_brd_mt_base_h = bp_brd_mt_h*2 + bp_board_h;
bp_brd_mt_y = bp_dc_in_y - (bp_board_h + bp_brd_mt_h);
bp_brd_mt_x1 = 3.5;  bp_brd_mt_x2 = bp_max_wid - (bp_brd_mt_w + bp_brd_mt_x1);

* union() {
    linear_extrude(bp_thick) difference() {
        hull() {  // faster to do hull on 2d and linear_extrude than with 3D
            intersection() {
                translate([bp_max_wid/2, bp_max_hgt-ellipse_hgt/2, 0])
                  ellipse(bp_max_wid*1.25, ellipse_hgt);
                translate([bp_cnr_rad-0.5, 0])
                  square([bp_max_wid-(bp_cnr_rad-0.5)*2, bp_max_hgt]);
            }
            translate([bp_max_wid-bp_cnr_rad, bp_min_hgt-bp_cnr_rad, 0])
              circle(r=bp_cnr_rad);
            translate([bp_cnr_rad, bp_min_hgt-bp_cnr_rad, 0])
              circle(r=bp_cnr_rad);
            square([bp_max_wid, bp_min_hgt-bp_cnr_rad]);
        }
        // DC jack cutout
        translate([bp_dc_in_x, bp_dc_in_y]) square([bp_dc_in_w, bp_dc_in_h]);
        // Switch cutout
        translate([bp_sw_x, bp_sw_y]) square([bp_sw_wid, bp_sw_hgt]);
    }
    // board mounts
    translate([bp_brd_mt_x1, bp_brd_mt_y, bp_thick])
      cube([bp_brd_mt_w, bp_brd_mt_base_h, bp_brd_mt_base_l]);
    translate([bp_brd_mt_x1, bp_brd_mt_y, bp_thick])
      cube([bp_brd_mt_w, bp_brd_mt_h, bp_brd_mt_l]);
    translate([bp_brd_mt_x1, bp_brd_mt_y+bp_brd_mt_h+bp_board_h, bp_thick])
      cube([bp_brd_mt_w, bp_brd_mt_h, bp_brd_mt_l]);
    translate([bp_brd_mt_x2, bp_brd_mt_y, bp_thick])
      cube([bp_brd_mt_w, bp_brd_mt_base_h, bp_brd_mt_base_l]);
    translate([bp_brd_mt_x2, bp_brd_mt_y, bp_thick])
      cube([bp_brd_mt_w, bp_brd_mt_h, bp_brd_mt_l]);
    translate([bp_brd_mt_x2, bp_brd_mt_y+bp_brd_mt_h+bp_board_h, bp_thick])
      cube([bp_brd_mt_w, bp_brd_mt_h, bp_brd_mt_l]);
}