include <pw_primitives.scad>;

$fs = 0.6;
$fa = 1;

magnet_dia = 6;
magnet_thick = 2;  magnet_insert_thick = 1;
handle_len = 100;  handle_wid = 10;  handle_thick = 5;
spring_len = 40;  spring_wid = 5;  // height below
spring_base_thick = 4; spring_top_thick = 1;
spring_start = 12;  spring_top_x_off = 15;  // spring_top_z_off below
main_angle = 10;  pusher_angle = 10;
outer_dia = 12;  outer_rad = outer_dia/2;
pusher_dia = 4;
washer_dia = 10;  washer_thick = 1.0;
washer_offset = magnet_insert_thick + 1;
support_dia = 5;  support_offset = 8;  support_thick = 10;
pivot_hole_dia = 2;
tolerance = 0.3;

hinge_overlap_len = (handle_thick) / tan(main_angle);
handle_angle = atan2((outer_dia-handle_wid)/2, handle_len);
support_start = washer_offset+magnet_insert_thick-washer_thick;
spring_height = (handle_len-(spring_start+spring_top_x_off)) * tan(main_angle+pusher_angle) - handle_thick;
spring_top_z_off = spring_top_thick * tan(main_angle+pusher_angle);
// translate([-10, -40, -1]) cube([150, 80, 1]);

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
            // the diagonal 'spring'
            translate([spring_start, 0, handle_thick-epsilon]) hexahedron([
                [0, -spring_wid/2, 0],
                [spring_base_thick, -spring_wid/2, 0],
                [spring_base_thick, spring_wid/2, 0],
                [0, spring_wid/2, 0],
                [spring_top_x_off, -spring_wid/2, spring_height],
                [spring_top_x_off+spring_top_thick, -spring_wid/2, spring_height-spring_top_z_off],
                [spring_top_x_off+spring_top_thick, spring_wid/2, spring_height-spring_top_z_off],
                [spring_top_x_off, spring_wid/2, spring_height]
            ]);
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
        // hinge cutouts
        translate([handle_len-hinge_overlap_len, handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+epsilon, handle_wid/4+1, handle_thick]);
        translate([handle_len-hinge_overlap_len, -handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+epsilon, handle_wid/4, handle_thick]);
        // pivot hole
        translate([handle_len, handle_wid/2, handle_thick/2-epsilon])
          rotate([90, 0, 0]) cylinder(d=pivot_hole_dia, h=handle_wid+epsilo2);
    }
}

// the arm
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
          cube([hinge_overlap_len+handle_thick/2+epsilon, handle_wid/4+1, handle_thick]);
        translate([handle_len-hinge_overlap_len, -handle_wid/4, handle_thick]) 
          rotate([0, main_angle, 0])
          cube([hinge_overlap_len+handle_thick/2+epsilon, handle_wid/4, handle_thick]);
        // pivot hole
        translate([handle_len, handle_wid/2, handle_thick/2-epsilon])
          rotate([90, 0, 0]) cylinder(d=pivot_hole_dia, h=handle_wid+epsilo2);
    }
    // outer, inner, angle
    translate([handle_len, 0, 0]) rotate([90, 0, 180]) 
      torus(handle_len+pusher_dia/3, pusher_dia/2, main_angle + pusher_angle);
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
            handle_len, outer_rad, main_angle, pusher_dia-tolerance/2,
            0, 0, false, false
          );
        translate([support_offset, 0, 0]) 
          cylinder(d=support_dia, h=support_thick);
    };
    // remove everything below XY plane
    translate([-(outer_rad+epsilon), -(outer_rad), -epsilon]) 
       cube([outer_dia+support_offset+support_dia, outer_dia, handle_thick-support_start]);
}
