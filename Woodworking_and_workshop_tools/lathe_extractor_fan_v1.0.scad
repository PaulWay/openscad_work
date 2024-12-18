include <libs/pw_funcs.scad>;
include <libs/pw_primitives.scad>;

$fn=45;
module flared_ring(outer_r, inner_r, thickness, angle=360) {
    rotate_extrude(angle=angle, convexity=2) translate([outer_r, 0]) intersection() {
        outer_edge = inner_r+thickness;
        difference() {
            circle(r=inner_r+thickness);
            circle(r=inner_r);
        }
        translate([-outer_edge, -outer_edge]) square(outer_edge);
    }
}

module lathe_shaft(tol=0) union() {
    cylinder(d=80.5+tol, h=11+tol);
    cylinder(d=59+tol, h=11+4+tol);
    cylinder(d=45+tol, h=15+5+tol);
    cylinder(d=50+tol, h=15+10+tol);
    cylinder(d=30+tol, h=25+30+tol);
}

inner_dia = 81; inner_height = 11; base_thickness = 2;
wall_thickness = 3;  wall_height = 29;  lid_wall_height = 5;
spiral_min_rad = 78; outlet_width = 40;
spiral_lid_wrad = spiral_min_rad - wall_thickness;
spiral_min_outer = spiral_min_rad + wall_thickness;
spiral_lid_outer = spiral_lid_wrad + outlet_width;
spiral_max_rad = spiral_min_rad + outlet_width;
spiral_max_outer = spiral_max_rad + wall_thickness;
outlet_length = 75;  outlet_start_x = -10;
magnet_offset = 60;

// mirrored because I originally modelled it going clockwise and couldn't be
// bothered trying to redo the calculations in the wall arith_spirals.
mirror([0, 1, 0]) union() {
    // the arithmetic spiral base
    linear_extrude(base_thickness) difference() {
        polygon(arith_spiral(spiral_min_outer, spiral_max_outer, 90));
        // inner circle before flared ring
        circle(d=inner_dia+inner_height-0.01);
        // magnet holes
        rotate([0, 0, -45]) rotate_distribute(4, 270) 
          translate([magnet_offset, 0]) circle(d=6);
    }
    // the outlet
    translate([0, spiral_min_rad, 0]) cube([outlet_length, outlet_width, base_thickness]);
    // the walls
    linear_extrude(wall_height) union() {
        polygon([
            each arith_spiral(spiral_min_rad, spiral_max_rad, 90),
            [outlet_length, spiral_max_rad], [outlet_length, spiral_max_outer],
            each arith_spiral(spiral_max_outer, spiral_min_outer, 90, angle=-360),
            [outlet_start_x, spiral_min_rad]
        ]);
        // because of clipping, easier to union in the 'inner' outlet wall
        translate([0, spiral_min_rad]) square([outlet_length, wall_thickness]);
    };
    // translate([0, 0, inner_height])
    //   flared_ring(81/2+inner_height, inner_height-2, 2);
}

blade_thickness = 2;  fan_height = 25;  hub_rad = 56/2;  blade_width = spiral_min_rad-3-hub_rad;

translate([0, 250, 0]) union() {
    // the arithmetic spiral base
    linear_extrude(base_thickness) difference() {
        polygon(arith_spiral(spiral_min_outer, spiral_max_outer, 90));
        // inlet
        circle(d=inner_dia+inner_height-0.01);
    }
    // the outlet
    translate([0, spiral_min_rad, 0])
      cube([outlet_length, outlet_width+wall_thickness, base_thickness]);
    // the walls
    # linear_extrude(lid_wall_height) union() {
        polygon([
            each arith_spiral(spiral_min_rad, spiral_max_rad, 90),
            [outlet_length, spiral_max_rad], [outlet_length, spiral_lid_outer],
            each arith_spiral(spiral_lid_outer, spiral_lid_wrad, 90, angle=-360),
            [outlet_start_x, spiral_min_rad]
        ]);
        // because of clipping, easier to union in the 'inner' outlet wall
        translate([0, spiral_min_rad+wall_thickness]) square([outlet_length, wall_thickness]);
    };
}

translate([200, 0, 0]) union() {
    rotate_distribute(36) translate([hub_rad, -blade_thickness/2, 0])
      cube([blade_width, blade_thickness, fan_height]);
}