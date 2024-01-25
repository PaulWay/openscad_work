include <pw_primitives.scad>;

$fs = 0.6;
$fa = 1;

magnet_dia = 6;
magnet_thick = 2;  magnet_insert_thick = 1;
handle_len = 100;  handle_wid = 10;  handle_thick = 5;
spring_len = 40;  spring_wid = 5;  spring_thick = 1.2;
spring_angle = 50;  spring_start = 20 + spring_len*cos(spring_angle);
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
support_start = washer_offset+washer_thick;
spring_top_angle = spring_angle-main_angle;
spring_top_len = spring_thick/sin(spring_top_angle);

// translate([-10, -40, -1]) cube([150, 80, 1]);

// the base
! union() {
    difference() {
        union() {
            // the handle
            hull() {
                cylinder(d=outer_dia, h=handle_thick);
                translate([handle_len, -handle_wid/2, handle_thick/2])
                  rotate([-90, 0, 0]) cylinder(d=handle_thick, h=handle_wid);
            };
            // the diagonal 'spring'
            translate([spring_start, -spring_wid/2, 0])  rotate([0, spring_angle, 0])
              translate([-spring_len, 0, 0]) difference() {
                  // main spring arm
                  cube([spring_len, spring_wid, spring_thick]);
                  // make it have a flat top when rotated
                  rotate([0, -spring_top_angle, 0]) translate([0, -0.01, 0])
                    cube([spring_top_len, spring_wid+0.02, spring_thick]);
            }
            // test - min height of spring
            * translate([0, 0, 20]) rotate([0, main_angle, 0])
              cube([handle_len, spring_wid, spring_thick]);
            // test - max height of spring
            * translate([0, 0, 37]) rotate([0, main_angle+pusher_angle, 0])
              cube([handle_len, spring_wid, spring_thick]);
        }
        // hole for pusher to go through
        translate([0, 0, -0.01]) cylinder(d=pusher_dia+tolerance, h=handle_thick+0.02);
        // cutout for washer, up to top of handle
        translate([0, 0, washer_offset]) 
          cylinder(d=washer_dia, h=(handle_thick-washer_offset)+0.01);
        // the cutout for the tube and support
        translate([0, 0, support_start]) union() {
            cylinder(d=outer_dia+tolerance, h=handle_thick-support_start+0.02);
            translate([support_offset, 0, 0]) 
              cylinder(d=support_dia+tolerance*2, h=handle_thick-support_start+0.02);
        };
        // hole for holding the magnet in place before being pushed
        translate([0, 0, -0.01]) cylinder(d=magnet_dia+tolerance*2, h=magnet_insert_thick);
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

// the tube and support
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
    translate([-(outer_rad+0.01), -(outer_rad), -0.01]) 
       cube([outer_dia+support_offset+support_dia, outer_dia, handle_thick-support_start]);
}
