epsilon = 0.01; epsilo2 = epsilon*2;

base_width = 60;
base_length = 90;
base_height = 4;
neck_width = 25;  // neck is the 'centre' of the narrowing up to the holder
neck_length = 40;
neck_height = 20;



neck_rad = (neck_height - base_height);
neck_wid_off = (base_width - neck_width) / 2 - neck_rad;
neck_wid_fof = base_width - neck_wid_off;
neck_len_off = (base_length - neck_length) / 2 - neck_rad;
neck_len_fof = base_length - neck_len_off;
echo("neck_rad", neck_rad, "neck_wid_off", neck_wid_off);

* difference() {
    union() {
        // the base, up to the centre neck
        cube([base_width, base_length, neck_height]);
        translate([(base_width-neck_width)/2, -5, 0]) cube([neck_width, 1, 1]);
    }
    union() {
        translate([neck_wid_off, -epsilon, neck_height]) 
          rotate([-90, 0, 0]) cylinder(h=base_length + epsilo2, r=neck_rad);
        translate([neck_wid_fof, -epsilon, neck_height]) 
          rotate([-90, 0, 0]) cylinder(h=base_length + epsilo2, r=neck_rad);
        if (neck_wid_off>0) { union() {
            translate([-epsilon, -epsilon, base_height])
              cube([neck_wid_off, base_length + epsilo2, neck_rad]); 
            translate([neck_wid_fof, -epsilon, base_height])
              cube([neck_wid_off+epsilon, base_length + epsilo2, neck_rad]); 
        } }
        translate([-epsilon, neck_len_off, neck_height])
          rotate([0, 90, 0]) cylinder(h=base_width + epsilo2, r=neck_rad);
        translate([-epsilon, neck_len_fof, neck_height])
          rotate([0, 90, 0]) cylinder(h=base_width + epsilo2, r=neck_rad);
        if (neck_len_off>0) { union() {
            translate([-epsilon, -epsilon, base_height])
              cube([base_width + epsilo2, neck_len_off, neck_rad]); 
            translate([-epsilon, neck_len_fof, base_height])
              cube([base_width + epsilo2, neck_len_off+epsilon, neck_rad]); 
        } }
    }
}

holder_outer_bot_d = 55;
holder_outer_top_d = 55;
holder_height = 40;
holder_inner1_bot_d = 20; holder_inner1_bot_r = holder_inner1_bot_d/2;
holder_inner1_top_d = 34;
holder_inner1_height= 32;
holder_inner2_bot_d = 37;
holder_inner2_top_d = 42.5;
holder_inner2_height= 19;
holder_inner_angle = 10;
holder_inner_z_off = holder_height*sin(holder_inner_angle);
holder_inner_epsilon = holder_inner1_bot_d*sin(holder_inner_angle);
holder_throat_1_angle = 10;  // based as an offset from holder_inner1_bot_d;
holder_throat_2_angle = 15;
holder_throat_2_offset = 10;

difference() {
    cylinder(h=holder_height, d1=holder_outer_bot_d, d2=holder_outer_top_d);
    translate([0, -holder_inner_z_off, -holder_inner_epsilon]) 
      rotate([-holder_inner_angle, 0, 0]) union() {
        // The cones to make up the holder
        translate([0, 0, 0]) cylinder(
          h=holder_inner1_height, d1=holder_inner1_bot_d, d2=holder_inner1_top_d
        );
        translate([0, 0, holder_height-holder_inner2_height+holder_inner_epsilon]) cylinder(
          h=holder_inner2_height+holder_inner_epsilon, d1=holder_inner2_bot_d, 
          d2=holder_inner2_top_d
        );
        // The throat wedges
        translate([-holder_inner1_bot_r, holder_inner1_bot_r/2, 0])
          rotate([0, 0, holder_throat_1_angle]) translate([0, 0, 0]) cube([
            holder_inner1_bot_d, holder_outer_top_d/2, holder_height+holder_inner_z_off*2
          ]);
        # translate([-holder_inner1_bot_r, holder_inner1_bot_r/2, 0])
          rotate([0, 0, -holder_throat_1_angle]) translate([0, 0, 0]) cube([
            holder_inner1_bot_d, holder_outer_top_d/2, holder_height+holder_inner_z_off*2
          ]);
    };
}