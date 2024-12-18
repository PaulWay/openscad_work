module pulley_wheel(shaft_diam, outer_diam, cord_diam, height) {
    assert(height>cord_diam, "Wheel height must be greater than cord diameter");
    assert(shaft_diam+cord_diam<outer_diam, "Outer diameter must contain both shaft and cord");
    shaft_rad = shaft_diam/2;  outer_rad = outer_diam/2;
    rotate_extrude(convexity=2) difference() {
        translate([shaft_rad, 0]) square([outer_rad-shaft_rad, height]);
        translate([outer_rad, height/2]) circle(d=cord_diam);
    }
}

$fn=40;
translate([40/2+5+5, 0, 2.1]) pulley_wheel(5, 40, 6, 10);

module pulley_block(
    mount_shaft_diam, pulley_shaft_diam, wheel_diam, cord_diam, wheel_thick, side_thick,
    pulleys=1, side_clear=undef, mount_hole_diam=undef
) {
    // determine optional measurements
    side_off = wheel_thick + ((side_clear != undef) ? side_clear : side_thick*1.2);
    m_hole_d = (mount_hole_diam != undef) ? mount_hole_diam : pulley_shaft_diam;
    block_thick = side_off*pulleys + side_thick;
    // assemble:
    difference() {
        union() {
            // sides of the pulley blocks
            for (side=[0:pulleys]) union() translate([0, 0, side*side_off])
              linear_extrude(side_thick) hull() {
                circle(d=mount_shaft_diam);
                translate([wheel_diam/2+cord_diam+pulley_shaft_diam, 0])
                  circle(d=wheel_diam+cord_diam);
            }
            // mount shaft cylinder
            cylinder(h=block_thick, d=mount_shaft_diam);
        }
        translate([0, 0, -0.01]) union() {
            // mount shaft hole
            cylinder(h=block_thick+0.02, d=m_hole_d);
            // pulley shaft hole
            translate([wheel_diam/2+cord_diam+pulley_shaft_diam, 0, 0])
              cylinder(h=block_thick+0.02, d=pulley_shaft_diam);
        }
    }
}

pulley_block(10, 5, 40, 6, 10, 2, pulleys=1);