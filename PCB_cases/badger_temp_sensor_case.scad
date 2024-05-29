include <../libs/pw_primitives.scad>;
include <pwlib_boards.scad>;

$fn=32;

case_height = 14;  case_rad = 2;
case_surround_thick = 3;

badger_len = 86.25;  badger_wid = 49;
badger_top_height = 8.8; badger_support_height = 7.55-1.6;
badger_top_thick = badger_top_height - badger_support_height;
badger_hole_dia = 2.5;  badger_board_chamfer_r = 3;
badger_hole_off = (badger_hole_dia/2 + 1.8);
badger_screw_dia = 2;

// the charger dimensions
charger_len = 35.5;  charger_wid = 21.2;  charger_height = 7.35;  
charger_hole_dia = 3.2;  charger_hole_sp_x = 1.8;  charger_hole_sp_y = 2.8;
charger_screw_dia = 2;  charger_hole_len = 3;
charger_hole_x = charger_hole_dia/2 + charger_hole_sp_x;
charger_hole_y = charger_hole_dia/2 + charger_hole_sp_y;
charger_holes = [[charger_hole_x, charger_hole_y], [charger_len-charger_hole_x, charger_hole_y]];

// position of charger relative to badger
charger_len_off = 0;  charger_wid_off = 19;
charger_hei_off = -(badger_top_height - badger_support_height);
charger_usb_x = 0;  charger_usb_y = 9;  charger_usb_z = 1.6;  // relative to charger

usb_c_cable_allow_y = 11;  usb_c_cable_allow_z = 7;
usb_c_open_x = charger_usb_x - epsilon;
usb_c_open_y = case_surround_thick + charger_wid_off + charger_usb_y;
usb_c_open_z = case_height + charger_hei_off - charger_height + charger_usb_z;

// the piicodev atmospheric sensor
sensor_len = 25.3;  sensor_wid = 26.15;  sensor_height = 4.8;

// the battery itself
battery_len = 52;  battery_wid = 33.7;  battery_height = 6.0;

// calculated dimensions
case_len = badger_len + case_surround_thick * 2;
case_wid = badger_wid + case_surround_thick * 2;


union() {
    difference() {
        // the board
        rounded_cube(case_len, case_wid, case_height, case_rad);
        // all the cutouts
        // translate the cutouts relative to the top and start of the case internals
        translate([case_surround_thick, case_surround_thick, case_height+epsilon]) union() {
            // the Badger-2040w
            board_cutout(badger_len, badger_wid, badger_top_height, badger_board_chamfer_r);
            // the charger board
            translate([charger_len_off, charger_wid_off, charger_hei_off]) 
              board_cutout(
                charger_len, charger_wid, charger_height, 0.1, 
                charger_holes, charger_hole_dia/2, charger_screw_dia
              );
            // the battery
            // the temperature sensor
        };
        // the USB C connector hole
        translate([usb_c_open_x, usb_c_open_y, usb_c_open_z])
          cube([case_surround_thick+epsilo2, usb_c_cable_allow_y, usb_c_cable_allow_z]);
    }
    // The props to support the board, again, extending down (for consistency)
    translate([case_surround_thick, case_surround_thick, case_height+epsilon]) union() {
        // the Badger-2040w
        translate([0, 0, -badger_top_height]) board_supports(
            corner_offset_points(badger_len, badger_wid, badger_hole_off, badger_hole_off),
            badger_hole_dia+2, badger_hole_dia, badger_support_height
        );
    }
}
