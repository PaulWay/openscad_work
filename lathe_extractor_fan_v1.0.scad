
function arith_spiral(start_rad, end_rad, steps, angle=360) = [
    for (i=[0:steps-1])  let (fract = i/(steps-1))
    [
        (start_rad+(end_rad-start_rad)*fract)*sin(angle*fract),
        (start_rad+(end_rad-start_rad)*fract)*cos(angle*fract)
    ],
];

module cylinder_outer(h, d) {
    radius = d/2;
    fudge = 1/cos(180/$fn);
    cylinder(h=h, r=radius*fudge);
}

module cylinder_mid(h, d) {
    radius = d/2;
    fudge = (1+1/cos(180/$fn))/2;
    cylinder(h=h, r=radius*fudge);
}


module circle_outer(d) {
    radius = d/2;
    fudge = 1/cos(180/$fn);
    circle(r=radius*fudge);
}

module circle_mid(d) {
    radius = d/2;
    fudge = (1+1/cos(180/$fn))/2;
    circle(r=radius*fudge);
}
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

module lathe_shaft() union() {
    cylinder(d=80.5, h=11);
    cylinder(d=59, h=11+4);
    cylinder(d=45, h=15+5);
    cylinder(d=50, h=15+10);
    cylinder(d=30, h=25+30);
}

inner_dia = 81; inner_height = 11; base_thickness = 2;
wall_thickness = 3;  wall_height = 29;
spiral_min_dia = 78; outlet_width = 40; 
spiral_min_outer = spiral_min_dia + wall_thickness;
spiral_max_dia = spiral_min_dia + outlet_width;
spiral_max_outer = spiral_max_dia + wall_thickness;
outlet_length = 75;  outlet_start_x = -10;
magnet_offset = 40;

mirror([0, 1, 0]) union() {
    linear_extrude(base_thickness) difference() {
        polygon(arith_spiral(spiral_min_outer, spiral_max_outer, 90));
        // inner circle before flared ring
        circle(d=inner_dia+inner_height-0.01);
        // magnet holes
        translate([+magnet_offset, +magnet_offset]) circle(d=6);
        translate([-magnet_offset, +magnet_offset]) circle(d=6);
        translate([+magnet_offset, -magnet_offset]) circle(d=6);
        translate([-magnet_offset, -magnet_offset]) circle(d=6);
    }
    translate([0, spiral_min_dia, 0]) cube([outlet_length, outlet_width, base_thickness]);
    linear_extrude(wall_height) union() {
        polygon([
            each arith_spiral(spiral_min_dia, spiral_max_dia, 90), 
            [outlet_length, spiral_max_dia], [outlet_length, spiral_max_outer],
            each arith_spiral(spiral_max_outer, spiral_min_outer, 36, angle=-360),
            [outlet_start_x, spiral_min_dia]
        ]);
        // because of clipping, easier to union in the 'inner' outlet wall
        translate([0, spiral_min_dia]) square([outlet_length, wall_thickness]);
    };
    translate([0, 0, inner_height])
      flared_ring(81/2+inner_height, inner_height-2, 2);
}

translate([200, 0, 0]) union() {
}