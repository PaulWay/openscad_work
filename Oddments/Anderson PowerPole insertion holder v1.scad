include <../libs/pw_primitives.scad>;

tolerance = 0.15;
connector_upper_wid = 7.55;  conn_upp_wid_t = connector_upper_wid + tolerance;
connector_lower_wid = 5.8;  conn_low_wid_t = connector_lower_wid + tolerance;
conn_low_offset = (connector_upper_wid - connector_lower_wid)/2;
// The connector body is essentially square, so height is used as width as well.
connector_full_hgt = 7.8;  conn_hgt_t = connector_full_hgt + tolerance;
conn_half_t = conn_hgt_t / 2;
powerpole_wid = 8.5;  // this is offset on the top and left sides looking down;
connector_len = 8;  lug_len = 13;  lug_width = 3.35;  powerpole_len = 24.8;
lug_offset = powerpole_wid - connector_full_hgt;
lug_body_len = powerpole_len - connector_len;

grip_thick = 2;
body_len = powerpole_wid + grip_thick*2;  body_hgt = powerpole_len + grip_thick;
chamfer_r = 3;

$fn = ($preview ? 20 : 50);
module anderson_powerpole() union() {
    // main body
    cube([lug_body_len+epsilon, conn_hgt_t, conn_hgt_t]);
    // the two connector pieces
    translate([lug_body_len, 0, conn_half_t]) union() {
        translate([0, 0, 0]) cube([connector_len, conn_upp_wid_t, conn_half_t]);
        translate([0, conn_low_offset, -conn_half_t])
          cube([connector_len, conn_low_wid_t, conn_half_t+epsilon]);
    }
    // the lug at the top
    translate([0, conn_half_t-lug_width/2, conn_hgt_t-epsilon])
      cube([lug_len, lug_width, lug_offset]);
    // the lug on the left hand side
    translate([0, conn_hgt_t-epsilon, conn_half_t-lug_width/2])
      cube([lug_len, lug_offset, lug_width]);
}

difference() {
    rounded_box(body_len, body_len, body_hgt, chamfer_r);
    translate([grip_thick, grip_thick, body_hgt+epsilo2]) rotate([0, 90, 0])
      anderson_powerpole();
}
