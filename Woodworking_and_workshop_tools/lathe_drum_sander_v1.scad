include <../libs/pw_primitives.scad>;


belt_cyl_dia = 533/PI; belt_cyl_rad = belt_cyl_dia/2;
belt_height = 75;
outer_thick = 3;  belt_inner_rad = belt_cyl_rad-outer_thick;
lathe_jaw_dia = 128; lathe_jaw_rad = lathe_jaw_dia/2;
jaw_thick = 5;  jaw_height = 45;
fan_twist = 40;

$fa=2;
union() {
    // outer
    difference() {
        // The actual belt support
        pipe_rt_segment(belt_inner_rad, outer_thick, belt_height, 195);
        // the v inset at the start (+X axis) side
        translate([belt_cyl_rad, -0.01, 0]) rotate([0, -90, 0]) linear_extrude(10) polygon([
            [0, 0], [belt_height, 0],
            [belt_height/2, 20], [0, 0]
        ]);
        // the v outset at the end (-X axis) side
        translate([-belt_cyl_rad+10-0.01, -0.01, -0.01]) rotate([0, -90, 0])
          linear_extrude(10) polygon([
            [0, 0], [0, -30],
            [belt_height+0.02, -30], [belt_height+0.02, 0],
            [belt_height/2, -20], [0, 0]
        ]);
    }
    // inner
    pipe_rt_segment(lathe_jaw_rad, jaw_thick, jaw_height, 180);
    // support between, as a 'fan' to move dust
    difference() {
        rotate_distribute(5, angle=180-fan_twist)
          linear_extrude(belt_height, twist=-fan_twist) { 
            translate([lathe_jaw_rad, 0, 0]) square([belt_inner_rad-lathe_jaw_rad, 5]);
        }
        cylinder(h=belt_height+0.01, d1=0, r2=belt_inner_rad);
    }
}
