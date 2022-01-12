include <pw_primitives.scad>;

board_length = 47;
board_width = 36.7;
usb_height = 17;
usb_width = 32;
usb_x_start = 9;
usb_y_start = 1;
board_bottom_thick = 4;
board_height = usb_height + board_bottom_thick;
in_margin = 2;
wall_thick = 4;
outer_r = 4;

in_length = board_length + in_margin * 2;
in_width = board_width + in_margin * 2;
out_length = in_length + wall_thick * 2;
out_width = in_width + wall_thick * 2;
// echo("total length:", out_length, "total width:", out_width);
box_height = board_height + wall_thick;
lid_height = wall_thick * 2;

// xy coords relative to board
bb_hole_1_x = 3; 
bb_hole_1_y = 2.15;
bb_hole_2_x = 4.7;
bb_hole_2_y = 32;
bb_hole_3_x = 42.15;
bb_hole_3_y = 3.85;
bb_hole_4_x = 44.75;
bb_hole_4_y = 32.5;
board_bolt_shaft_d = 3;
board_bolt_shaft_l = wall_thick;
board_bolt_head_d = 6;
board_bolt_head_l = 2;

// xy coords relative to box
box_hole_1_x = out_length/3;
box_hole_1_y = out_width/2;
box_hole_2_x = (2*out_length)/3;
box_hole_2_y = out_width/2;
box_screw_shaft_d = 4;
box_screw_shaft_l = wall_thick;
box_screw_head_d = 8;
box_screw_head_l = wall_thick;

// xy coords relative to box
lid_hole_1_x = wall_thick/2;
lid_hole_1_y = out_width/5;
lid_hole_2_x = wall_thick/2;
lid_hole_2_y = 4*out_width/5;
lid_hole_3_x = out_length-wall_thick/2;
lid_hole_3_y = out_width/5;
lid_hole_4_x = out_length-wall_thick/2;
lid_hole_4_y = 4*out_width/5;
lid_bolt_shaft_d = 2;
lid_in_base_shaft_d = 1.8; // to allow thread grip
lid_bolt_shaft_l = 10;
lid_in_base_shaft_l = 8; // head must sit above base of lid
lid_bolt_head_d = 4;
lid_bolt_head_l = 2;

module board_bolt_hole(x, y) {
    translate([
        x+wall_thick+in_margin, 
        y+wall_thick+in_margin, 
        board_bolt_shaft_l + board_bolt_head_l - 0.005
    ]) mirror([0, 0, 1]) flat_head_bolt_hole(
        board_bolt_shaft_d, board_bolt_shaft_l, board_bolt_head_d, board_bolt_head_l
    );
}

module box_screw_hole(x, y) {
    // top at wall_thick, but have to move base
    translate([x, y, wall_thick-(box_screw_shaft_l+box_screw_head_l-0.05)])
        countersunk_bolt_hole(
            box_screw_shaft_d, box_screw_shaft_l, box_screw_head_d, box_screw_head_l
        );
}

module lid_bolt_hole(x, y) {
    // translate relative to lid
    translate([x, y, 0]) flat_head_bolt_hole(
        lid_bolt_shaft_d, lid_bolt_shaft_l, lid_bolt_head_d, lid_bolt_head_l
    );
}

module lid_in_base_bolt_hole(x, y) {
    // translate relative to body
    translate([x, y, box_height-lid_in_base_shaft_l]) flat_head_bolt_hole(
        lid_in_base_shaft_d, lid_in_base_shaft_l, lid_bolt_head_d, lid_bolt_head_l
    );
}

$fn = 40;
// translate([-100, 0, 0])
translate([0, 0, 0])
difference() {
    cube([out_length, out_width, box_height-0.001]);
    // inside
    translate([wall_thick, wall_thick, wall_thick]) {
        cube([in_length, in_width, box_height+10]);
    };
    // front entrance for USB ports
    translate([wall_thick+in_margin+usb_x_start, -0.01, wall_thick+board_bottom_thick])
        cube([usb_width, wall_thick+0.02, usb_height]);
    // hole for power socket
    translate([wall_thick+5, in_width+wall_thick-0.01, wall_thick+board_bottom_thick+10])
        rotate([-90, 0, 0]) cylinder(h=wall_thick+0.02, d=8);
    // holes for bolts to hold board in place
    board_bolt_hole(bb_hole_1_x, bb_hole_1_y);
    board_bolt_hole(bb_hole_2_x, bb_hole_2_y);
    board_bolt_hole(bb_hole_3_x, bb_hole_3_y);
    board_bolt_hole(bb_hole_4_x, bb_hole_4_y);
    // holes to hold box to table
    box_screw_hole(box_hole_1_x, box_hole_1_y);
    box_screw_hole(box_hole_2_x, box_hole_2_y);
    // holes to hold lid onto box
    lid_in_base_bolt_hole(lid_hole_1_x, lid_hole_1_y);
    lid_in_base_bolt_hole(lid_hole_2_x, lid_hole_2_y);
    lid_in_base_bolt_hole(lid_hole_3_x, lid_hole_3_y);
    lid_in_base_bolt_hole(lid_hole_4_x, lid_hole_4_y);
}

// translate([0, 0, box_height])
translate([out_length/2, out_width+10, 0]) rotate([0, 180, 0]) translate([-out_length/2, 0, 0])
translate([0, 0, -(lid_height+wall_thick)]) union() {
    // whole of lid top - because 'rounded_box' has a rounded bottom and
    // squared-off top, we mirror it around to be in the right relationship
    // with the other parts of the lid.
    difference() {
        translate([0, 0, lid_height+wall_thick]) mirror([0, 0, 1])
            rounded_box(out_length, out_width, wall_thick+0.01, outer_r);
        // holes to hold lid onto box
        lid_bolt_hole(lid_hole_1_x, lid_hole_1_y);
        lid_bolt_hole(lid_hole_2_x, lid_hole_2_y);
        lid_bolt_hole(lid_hole_3_x, lid_hole_3_y);
        lid_bolt_hole(lid_hole_4_x, lid_hole_4_y);
    };
    // USB topper
    translate([wall_thick+in_margin+usb_x_start, -0.01, wall_thick])
        cube([usb_width, wall_thick+0.02, wall_thick]);
}