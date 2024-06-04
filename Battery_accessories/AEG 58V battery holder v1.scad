// X measurements
battery_top_width = 54;       battery_top_outer = battery_top_width/2;
battery_side_a_width = 83;    battery_side_a_outer = battery_side_a_width/2;
battery_side_b_width = 84;    battery_side_b_outer = battery_side_b_width/2;
battery_side_c_width = 89;    battery_side_c_outer = battery_side_c_width/2;
battery_side_d_width = 81.5;    battery_side_d_outer = battery_side_d_width/2;
battery_side_e_width = 89.5;  battery_side_e_outer = battery_side_e_width/2;
frame_width = 95;             frame_outer = frame_width/2;

// Y measurements
frame_height = +5;
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

screw_height = frame_height+0.02;

// Z measurements
base_thick = 5;
slides_length = 126;
hole_1_height = 40;
hole_2_height = 80;

$fn = 20;
module countersink_hole(id, od, height) union() {
    or = min((od-id)/2, id);
    cylinder(h=height, d=id);
    translate([0, 0, height-or]) cylinder(h=or, d1=id, d2=od);
}

module txl(x=0, y=0, z=0) { translate([x, y, z]) children();}
module rot(x=0, y=0, z=0) { rotate([x, y, z]) children();}
translate([-frame_outer, battery_side_e, 0])
  cube([frame_width, frame_height-battery_side_e, base_thick]);
difference() {
    linear_extrude(slides_length+base_thick) { polygon([
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
    txl(y=screw_height-0.01, z=hole_1_height) rot(x=90) 
      countersink_hole(3, 8, screw_height+0.02);
    txl(y=screw_height-0.01, z=hole_2_height) rot(x=90) 
      countersink_hole(3, 8, screw_height+0.02);
}