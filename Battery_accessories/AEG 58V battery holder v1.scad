module txl(x=0, y=0, z=0) { translate([x, y, z]) children();}
module rot(x=0, y=0, z=0) { rotate([x, y, z]) children();}

// X measurements
battery_top_width = 54;       battery_top_outer = battery_top_width/2;
// old version
battery_side_a_width = 89;    battery_side_a_outer = battery_side_a_width/2;
battery_side_b_width = 89;    battery_side_b_outer = battery_side_b_width/2;
// new version
//battery_side_a_width = 83;    battery_side_a_outer = battery_side_a_width/2;
//battery_side_b_width = 84;    battery_side_b_outer = battery_side_b_width/2;
battery_side_c_width = 89;    battery_side_c_outer = battery_side_c_width/2;
battery_side_d_width = 81.5;    battery_side_d_outer = battery_side_d_width/2;
battery_side_e_width = 89.5;  battery_side_e_outer = battery_side_e_width/2;
frame_width = 95;             frame_outer = frame_width/2;

// Y measurements
frame_height = +3;
battery_top = 0;
battery_side_a = -8.5;
battery_side_b = -18;
battery_side_c1 = -22;
battery_side_c = -22;
battery_side_df = -28.5;
battery_side_df1 = -28.5;
battery_side_db = -31.3;
battery_side_db1 = -31.3;
battery_side_e = -40;

// Z measurements
base_thick = 5;
slides_length = 126;
full_length = slides_length+base_thick;
hole_1_height = 20;
hole_2_height = full_length-20;

// angling
tilt_angle = 2;
tilt_y_dist = full_length * sin(tilt_angle);
tilt_z_dist = (frame_height - battery_side_e) * tan(tilt_angle);
t_base_thick = base_thick + tilt_z_dist;
screw_height = frame_height + tilt_y_dist;

$fn = 20;
// borrowed from pw_primitives
module countersink_hole(id, od, height) union() {
    or = min((od-id)/2, id);
    cylinder(h=height, d=id);
    translate([0, 0, height-or]) cylinder(h=or, d1=id, d2=od);
}

translate([-frame_outer, battery_side_e, 0])
  cube([frame_width, frame_height-battery_side_e, base_thick]);
difference() {
    union() {
        difference() {
            txl(x=-frame_outer, y=frame_height)
              cube([frame_width, tilt_y_dist, full_length*cos(tilt_angle)]);
            rot(x=-tilt_angle+0.1) txl(x=-frame_outer, y=frame_height-tilt_y_dist-0.01)
              cube([frame_width+0.2, tilt_y_dist, full_length]);
        };
        txl(y=frame_height) rot(x=-tilt_angle) txl(y=-frame_height)
          linear_extrude(full_length, convexity=3) { polygon([
            // From the middle of the top - heading anticlockwise.
            [+battery_top_outer, battery_top],
            // Around the inside right (+X)
            [+battery_side_a_outer, battery_side_a],  // diagonal
            [+battery_side_b_outer, battery_side_b],
            [+battery_side_c_outer, battery_side_b],
            [+battery_side_c_outer, battery_side_c],
            [+battery_side_d_outer, battery_side_c1],
            [+battery_side_d_outer, battery_side_df1],
            [+battery_side_e_outer, battery_side_df],
            [+battery_side_e_outer, battery_side_e],
            // Across the bottom of the frame to the outside right
            [+frame_outer, battery_side_e],
            // Then up across the top to the left (-X) side
            [+frame_outer, frame_height],
            [-frame_outer, frame_height],
            // Down to the bottom of the frame and to the inside left
            [-frame_outer, battery_side_e],
            // Up the inside left
            [-battery_side_e_outer, battery_side_e],
            [-battery_side_e_outer, battery_side_df],
            [-battery_side_d_outer, battery_side_df1],
            [-battery_side_d_outer, battery_side_c1],
            [-battery_side_c_outer, battery_side_c],
            [-battery_side_c_outer, battery_side_b],
            [-battery_side_b_outer, battery_side_b],
            [-battery_side_a_outer, battery_side_a],  // diagonal
            // And back to the top
            [-battery_top_outer, battery_top]
        ]);};
    };
    rot(x=-tilt_angle) txl(y=screw_height, z=hole_1_height) rot(x=90)
      countersink_hole(3, 8, screw_height+0.01);
    rot(x=-tilt_angle) txl(y=screw_height, z=hole_2_height) rot(x=90)
      countersink_hole(3, 8, screw_height+0.01);
}