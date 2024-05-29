include <../libs/pw_primitives.scad>;

$fn = 30;

magnet_dia = 6;
magnet_thick = 2;  magnet_insert_thick = 1;
handle_len = 100;  handle_wid = 10;  handle_thick = 5;

main_angle = 20;  pusher_angle = 10;

join_len = (handle_thick) / tan(main_angle);  join_off = 12;

spring_len = 60;  spring_gap = 2; spring_segments = 10;

outer_dia = 12;  outer_rad = outer_dia/2;
pusher_dia = 4;  arm_head_dia = 8;
washer_dia = 10;  washer_thick = 1.0;
washer_offset = magnet_insert_thick + 1;
support_dia = 5;  support_offset = 8;  support_thick = 10;
pivot_hole_dia = 2;
tolerance = 0.3;

hinge_overlap_len = (handle_thick) / tan(main_angle);
support_start = washer_offset+magnet_insert_thick-washer_thick;

// the base
union() {
    difference() {
        union() {
            // the handle
            hull() {
                cylinder(d=outer_dia, h=handle_thick);
                translate([handle_len, -handle_wid/2, handle_thick/2])
                  rotate([-90, 0, 0]) cylinder(d=handle_thick, h=handle_wid);
            };
        }
        // hole for pusher to go through
        translate([0, 0, -epsilon]) cylinder(d=pusher_dia+tolerance, h=handle_thick+epsilo2);
        // the cutout for the tube and support
        translate([0, 0, support_start]) union() {
            cylinder(d=outer_dia+epsilon, h=handle_thick-support_start+epsilo2);
            translate([support_offset, 0, 0]) 
              cylinder(d=support_dia+epsilon, h=handle_thick-support_start+epsilo2);
        };
        // hole for holding the magnet in place before being pushed
        translate([0, 0, -epsilon])
          cylinder(d=magnet_dia+tolerance*2, h=magnet_insert_thick+epsilo2);
        // cutout for bar across dispenser slider
        translate([-1-tolerance, -outer_dia/2-epsilon, -epsilon])
          cube([2+tolerance*2, outer_dia+epsilo2, 1+epsilo2]);
        // cutout for washer
        translate([0, 0, magnet_insert_thick])
          cylinder(d=washer_dia, h=washer_thick+epsilon);
        // cutout to join arm to base
        translate([handle_len-(join_len+join_off), -handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([join_len*2, handle_wid/2, handle_thick]);
        // locking hole
        translate([handle_len, handle_wid/2, handle_thick/2-epsilon])
          rotate([90, 0, 0]) cylinder(d=pivot_hole_dia, h=handle_wid+epsilo2);
        // bolt holes to hold it in place
        translate([handle_len-join_len+2, -epsilon, handle_thick/2]) rotate([-90, 0, 0])
          translate([0, 0, -handle_wid/2-1]) cylinder(h=handle_wid+epsilo2+2, d=2);
    }
}

// the arm
// sideways for maximum strength on the spring.  The 
translate([0, 20, handle_wid/2]) rotate([-90, 0, 0]) union() {
    // The disk 
    cylinder(d=handle_wid, h=handle_thick);
    // The other parts, translated to centre them on the disk
    translate([0, -handle_wid/2, 0]) {
        // cube to join the cylinder end with the spring
        cube([handle_wid/2, handle_wid, handle_thick]);
        // flat spring
        translate([handle_wid/2, 0, 0]) 
          flat_spring(spring_len, handle_wid, handle_thick, spring_gap, spring_segments);
    }
    // The join 
    translate([spring_len+handle_wid/2, -handle_wid/2, 0]) difference() {
        // The handle to be differenced
        cube([join_len*2+10-0.1, handle_wid, handle_thick]);
        // Left hand side
        translate([10, 0.1-handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([join_len*2, handle_wid/2, handle_thick]);
        // Right hand side
        translate([10, +handle_wid*3/4-0.1, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([join_len*2, handle_wid/2, handle_thick]);
        // Bottom side to be flat
        translate([10, -epsilon, handle_thick])
          rotate([0, main_angle, 0]) translate([0, 0, handle_thick-epsilon])
          cube([join_len*2+10, handle_wid+epsilo2, handle_thick]);
        // bolt hole to hold it in place
        translate([10+join_len, -epsilon, handle_thick/2]) rotate([-90, 0, 0])
          cylinder(h=handle_wid+epsilo2, d=2);
    }
    // the finger - outer, inner, angle
    $fn = 90;
    translate([handle_len+20, 0, 0]) rotate([90, 0, 180]) 
      torus(handle_len+pusher_dia/3+20, pusher_dia/2-0.2, angle=main_angle-5);
}

// the tube and support
// for the tube plus support, easier to subtract the offset thickness rather than
// recalculate the angle of the tube.
translate([0, -20, -(handle_thick-support_start)]) difference() {
    union() {
        translate([handle_len-(outer_rad-(pusher_dia-tolerance/2)), 0, 0]) rotate([90, 0, 180]) 
          conduit_angle_bend_straight_join(
          // bend_radius, pipe_radius, bend_angle, thickness,
          // join_length, overlap_len, join_a=true, join_b=true, flare_a=true, flare_b=true
            handle_len, outer_rad, main_angle-pusher_angle, pusher_dia-tolerance/2,
            0, 0, false, false
          );
        translate([support_offset, 0, 0]) 
          cylinder(d=support_dia, h=support_thick);
    };
    // remove everything below XY plane
    translate([-(outer_rad+epsilon), -(outer_rad), -epsilon]) 
       cube([outer_dia+support_offset+support_dia, outer_dia, handle_thick-support_start]);
}
