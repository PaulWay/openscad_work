include <pw_primitives.scad>;

$fn=180;

magnet_dia = 6;
magnet_thick = 2;
handle_len = 100;
handle_wid = 10;
handle_thick = 5;
main_angle = 10;
pusher_angle = 10;
outer_dia = 12; outer_rad = outer_dia/2;
pusher_dia = 4;
washer_dia = 10; washer_thick = 1.0; washer_offset = 3.0;
support_dia = 5; support_offset = 8; support_thick = 10;
pivot_hole_dia = 2;
tolerance = 0.3;

hinge_overlap_len = (handle_thick) / tan(main_angle);
handle_angle = atan2((outer_dia-handle_wid)/2, handle_len);
support_start = washer_offset+washer_thick;

union() {
    difference() {
        // the handle
            hull() {
                cylinder(d=outer_dia, h=handle_thick);
                translate([handle_len, -handle_wid/2, handle_thick/2])
                  rotate([-90, 0, 0]) cylinder(d=handle_thick, h=handle_wid);
            };
        // hole for pusher to go through
        translate([0, 0, -0.01]) cylinder(d=pusher_dia+tolerance, h=handle_thick+0.02);
        // cutout for washer, up to top of handle
        translate([0, 0, washer_offset]) hull() {
            cylinder(d=washer_dia, h=(handle_thick-washer_offset)+0.01);
            translate([-washer_dia/2, 0, 0]) 
              cylinder(d=washer_dia, h=(handle_thick-washer_offset)+0.01);
        };
        // the cutout for the tube and support
        translate([0, 0, support_start]) union() {
            cylinder(d=outer_dia+tolerance, h=handle_thick-support_start+0.02);
            translate([support_offset, 0, 0]) 
              cylinder(d=support_dia+tolerance*2, h=handle_thick-support_start+0.02);
        };
        // hole for holding the magnet in place before being pushed
        translate([0, 0, -0.01]) cylinder(d=magnet_dia+tolerance*2, h=magnet_thick);
        // hinge cutouts
        translate([handle_len-hinge_overlap_len, handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+0.01, handle_wid/4+1, handle_thick]);
        translate([handle_len-hinge_overlap_len, -handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+0.01, handle_wid/4, handle_thick]);
        // pivot hole
        translate([handle_len, handle_wid/2, handle_thick/2-0.01])
          rotate([90, 0, 0]) cylinder(d=pivot_hole_dia, h=handle_wid+0.02);
    }
}

// upside-down to print flat handle first
translate([0, 20, 0]) union() {
    difference() {
        hull() {
            cylinder(d=outer_dia, h=handle_thick);
            translate([handle_len, -handle_wid/2, handle_thick/2])
              rotate([-90, 0, 0]) cylinder(d=handle_thick, h=handle_wid);
        };
        // hinge cutouts
        translate([handle_len-hinge_overlap_len, handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+0.01, handle_wid/4+1, handle_thick]);
        translate([handle_len-hinge_overlap_len, -handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+0.01, handle_wid/4, handle_thick]);
        // pivot hole
        translate([handle_len, handle_wid/2, handle_thick/2-0.01])
          rotate([90, 0, 0]) cylinder(d=pivot_hole_dia, h=handle_wid+0.02);
    }
    // outer, inner, angle
    translate([handle_len, 0, 0]) rotate([90, 0, 180]) 
      torus(handle_len+pusher_dia/3, pusher_dia/2, main_angle + pusher_angle);
}

// for the tube plus support, easier to subtract the offset thickness rather than
// recalculate the angle of the tube.
translate([0, -20, -(handle_thick-support_start)]) difference() {
    union() {
        translate([handle_len-(outer_rad-(pusher_dia-tolerance/2)), 0, 0]) rotate([90, 0, 180]) 
          conduit_angle_bend(
          // bend_radius, pipe_radius, bend_angle, thickness,
          // join_length, overlap_len, flange_a=true, flange_b=true    
            handle_len, outer_rad, main_angle, pusher_dia-tolerance/2,
            0, 0, false, false
          );
        translate([support_offset, 0, 0]) 
          cylinder(d=support_dia, h=support_thick);
    };
    translate([-(outer_rad+0.01), -(outer_rad+0.01), -0.01]) 
       cube([outer_dia+support_offset+support_dia, outer_dia, handle_thick-support_start]);
}