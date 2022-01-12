include <pw_primitives.scad>;

rb = 20;
r1 = 10;  h1 = 0;
r2 = 15;  h2 = 10;
r3 = 0;   h3 = 30;

vane_thick = 2; vane_off = -(vane_thick/2);

module vane(height, thickness, width, inner_radius, twist, slices) {
    linear_extrude(height=height, twist=twist, slices=slices, convexity=2)
    translate([inner_radius, 0, 0]) square([width, thickness]);
}


// Cyclone base
translate([200, 0, 0]) intersection() {
    union() {
        hollow_cone_rt(100, rb, 50, 4);
        cylinder(h=h2, r1=r1, r2=r2);
        translate([0, 0, h2-0.01]) { cylinder(h=(h3-h2)+0.01, r1=r2, r2=r3); }
        rotate([0, 0,   0]) vane(h2, vane_thick, rb, 0, 36, 40);
        rotate([0, 0,  90]) vane(h2, vane_thick, rb, 0, 36, 40);
        rotate([0, 0, 180]) vane(h2, vane_thick, rb, 0, 36, 40);
        rotate([0, 0, 270]) vane(h2, vane_thick, rb, 0, 36, 40);
    };
    translate([-100, -100, 0]) cube(200);
};

// Cyclone lid
translate([0, 200, 0]) union() {
    // Body, minus hole for inlet
    difference() {
        ring_rt(30, 50, 4);
        translate([-35, -75, 28]) rotate([-105, 0, 0]) cylinder(h=75, r=15-4);
    }
    // Cap, minus hole for outlet
    difference() {
        translate([0, 0, 30-0.01]) cylinder(h=4.01, r=50);
        cylinder(h=30+4+0.01, r=15-4);
    }
    // Inlet, minus body:
    difference() {
        translate([-35, -75, 28]) rotate([-105, 0, 0]) ring_rt(75, 15, 4);
        translate([0, 0, -6]) cylinder(h=36, r=50);
    }
    // Outlet:
    ring_rt(60, 15, 4);
}

module cyclone_lid(inlet_diam, wall_thick) {
    // Outer diameter is 3*inlet + 4*wall_thick.
    // Because in cross section we have one inlet (diameter), the outlet, and then
    // another inlet diameter for the other side of the spiral, with two walls on the
    // outside and two walls protecting the outlet.
    inlet_r = inlet_diam/2;
    torus_outer_r = inlet_r*3+wall_thick*2;
    z_angle = atan(inlet_diam / (inlet_diam+wall_thick)*2*PI);
    difference() {
        // top cap is a quarter-torus, on a cylinder, with a cylinder inside.
        union() {
            // outlet
            cylinder(h=inlet_diam+wall_thick*2, d=inlet_diam+wall_thick);
            // base
            cylinder(h=inlet_r+wall_thick, r=torus_outer_r);
            // top
            translate([0, 0, inlet_r+wall_thick]) intersection() {
                torus(torus_outer_r, inlet_r+wall_thick);
                cylinder(h=inlet_r+wall_thick, r=torus_outer_r);
            };
            // inlet
            translate([-(inlet_diam+wall_thick), 0, inlet_r]) rotate([z_angle, 0, 0])
                cylinder(h=inlet_r*3, r=inlet_r+wall_thick);
        }
        // Spiral inside the cap for the airflow - mirrored and negative
        // spiral to put the inlet at the right place.
        translate([0, 0, inlet_r]) mirror([1,0,0]) spring(
            inlet_diam+wall_thick, inlet_r, -inlet_diam, 1, 20
        );
        // inlet - cylinder starts off 'standing on' Z axis, is rotated around
        // X axis so it's at the same angle as the spiral, and then translated
        // to the right start point for the spiral
        translate([-(inlet_diam+wall_thick), 0, inlet_r]) rotate([z_angle, 0, 0])
            cylinder(h=inlet_r*3+4, r=inlet_r);
        // outlet
        translate([0, 0, -0.1]) cylinder(h=inlet_r+wall_thick+0.2, d=inlet_diam);
    }
}



cyclone_lid(50, 4);
