include <pw_primitives.scad>;
include <pwlib_boards.scad>;

board_len = 87.25;  board_wid = 45.25; board_hei = 2;
wall_thick = 2;  offset_hei = 1;  board_rad = 5;
case_len = board_len + wall_thick*2;  case_wid = board_wid + wall_thick*2;
case_hei = board_hei + wall_thick;  case_rad = 2;
hole_off = 3.5; board_holes = [
  [board_len-hole_off, hole_off], [hole_off, board_wid-hole_off]
];  prop_dia = 5;  screw_dia = 2.5; clearance = 1;

$fn=30;

union() {
    difference() {
        // the case
        rounded_cube(case_len, case_wid, case_hei, case_rad);
        // the board insert
        translate([wall_thick, wall_thick, case_hei+epsilon]) union() {
            board_cutout(
              board_len, board_wid, board_hei, board_rad,
              board_holes, screw_dia, 0.5
            );
        }
    }
    translate([wall_thick, wall_thick, board_hei])
      board_supports(board_holes, prop_dia, screw_dia, clearance);
}