module hollow_cube(length, width, height, wall_t) {
    difference() {
        two_t = wall_t*2;
        cube([length, width, height]);
        translate([wall_t, wall_t, -0.1]) 
          cube([length-two_t, width-two_t, height+0.2]);
    }
}

module rounded_box(length, width, height, outer_r) {
    // A simple solid box with rounded bottom and side edges.
    // Essentially this is a box with spherical corners and cylindrical
    // edges on the outside.  You can then subtract whatever object you want
    // from it to make it hollow if you like.
    // Parameters are: the external length, width and height,
    // the radius of the corners and edges.
    outer_d = outer_r*2;
    union() translate([outer_r, outer_r, outer_r]) difference() {
        // outer rounded rectangle
        minkowski() {
            cube([length-outer_d, width-outer_d, height-outer_r]);
            sphere(r=outer_r);
        };
        // top face
        translate([-outer_r, -outer_r, height-outer_r]) 
          cube([length+2*outer_r, width+2*outer_r, outer_r]);
    }
}

module ring_rt(height, radius, thickness) { difference() {
    // For when you know the outer radius and the wall thickness.
    cylinder(h=height, r=radius);
    translate([0, 0, -0.05]) 
      cylinder(h=height+0.1, r=max(radius-thickness, 0));
}};
module pipe_rt(height, radius, thickness) ring_rt(height, radius, thickness);
module hollow_cylinder(width, height, wall_t) ring_rt(height, width, wall_t);

module ring_oi(height, o_radius, i_radius) { difference() {
    // For when you know the outer and inner radius but not the wall thickness.
    cylinder(h=height, r=o_radius);
    translate([0, 0, -0.05]) 
      cylinder(h=height+0.1, r=i_radius);   
}};
module pipe_oi(height, o_radius, i_radius) ring_oi(height, o_radius, i_radius);

module hollow_cone_rt(height, bottom_radius, top_radius, thickness) { difference() {
    // For when you know the outer radii and the wall thickness.
    cylinder(h=height, r1=bottom_radius, r2=top_radius);
    translate([0, 0, -0.05]) cylinder(
        h=height+0.1, 
        r1=max(bottom_radius-thickness, 0), r2=max(top_radius-thickness, 0)
    );
}};

module hollow_cone_oi(
    height, o_bot_radius, i_bot_radius, o_top_radius, i_top_radius,
) { difference() {
    // For when you know the outer and inner radii but not the wall thickness.
    cylinder(h=height, r1=o_bot_radius, r2=o_top_radius);
    translate([0, 0, -0.05]) 
      cylinder(h=height+0.1, r1=i_bot_radius, r2=i_top_radius);
}};
module cone_oi(height, bottom_o_radius, top_o_radius, bottom_i_radius, top_i_radius)
  hollow_cone_oi(height, bottom_o_radius, bottom_i_radius, top_o_radius, top_i_radius);

module half_cylinder(height, radius) {
    // Half of a cylinder of the given height and radius in the positive X, so
    // starting from -Y radius to +Y radius.
    intersection() {
        cylinder(h=height, r=radius);
        translate([0, -radius, 0]) cube([radius, radius*2, height]);
    }
};

module cylinder_segment(height, radius, angle=360) {
    // A cylindrical arc segment of the given height and radius, starting
    // from 0 degrees (along the -Y axis) and rotating anti-clockwise around
    // the given angle.
    if (angle < 180) {
        // make up out of the intersection of two half cylinders
        intersection() {
            half_cylinder(height, radius);
            rotate([0, 0, -(180-angle)]) half_cylinder(height, radius);
        };
    } else {
        // make up of the union of two half cylinders
        union() {
            half_cylinder(height, radius);
            rotate([0, 0, -(180-angle)]) half_cylinder(height, radius);
        };
    };
}

module torus(outer, inner, angle=360)
    rotate_extrude(angle=angle) {
        translate([max(outer-inner, 0), 0, 0]) circle(r=inner);
    };

module conduit_angle_bend(
    bend_radius, pipe_radius, bend_angle, thickness, join_length, overlap_len,
    flange_a=true, flange_b=true
) {
    // A piece of conduit with a pipe outer radius (not diameter) and wall
    // thickness, curving around a bend angle at a bend radius from the centre
    // of the circle.  The two ends can have straight flanges (a flange allows
    // a pipe of pipe radius to fit inside it) with a join length, overlapping
    // into the angle bend for a given length.  The flanges can be disabled, which
    // will result in a smaller piece of straight pipe of the given radius and
    // wall thickness (with no overlap).

    // The actual bend
    difference() {
        torus(bend_radius+thickness, pipe_radius, bend_angle);
        rotate([0, 0, -0.1]) torus(bend_radius, pipe_radius-thickness, bend_angle+0.2);
    };
    // First flange
    translate([bend_radius-pipe_radius+thickness, (flange_a ? overlap_len : 0), 0])
    rotate([90, 0, 0])
    ring_rt(join_length, pipe_radius+(flange_a ? thickness : 0), thickness);
    // Second flange (taken around the angle)
    rotate([0, 0, bend_angle])
    translate([bend_radius-pipe_radius+thickness, join_length-(flange_b ? overlap_len : 0), 0])
    rotate([90, 0, 0])
    ring_rt(join_length, pipe_radius+(flange_b ? thickness : 0), thickness);
}

module spring(spring_r, wire_r, rise_per_rev, turns, step_deg) {
    // A spring of radius spring_r made of wire of radius wire_r, that goes
    // (fractional) turns around, modeled as sphere at each 'node', and a
    // cylinder between each node.  If rise_per_rev is negative, spiral goes
    // 'down' - i.e. is left-handed, rather than right-handed.  If turns is
    // not evenly divisible by step_deg, the final sphere will not be added.
    assert(turns>0, "turns must be positive");
    assert(step_deg>0, "step_deg must be positive");
    // start on X axis at zero.
    x = spring_r; y = 0; z = 0;
    // each complete turn (360deg) goes up one rise_per_rev
    z_factor = rise_per_rev / 360;
    // z angle for each step
    spring_circ = (spring_r*2*PI);
    z_angle = atan(rise_per_rev / spring_circ);
    // step_len is the length of the cylinder joining each node; it's the
    // spiral length of each turn divided by 360/step_deg.
    one_turn_len = sqrt(rise_per_rev*rise_per_rev + spring_circ*spring_circ);
    step_len = one_turn_len / (360/step_deg);
    for(angle = [0 : step_deg : turns*360]) {
        // the 'next' point around the spiral
        xn = spring_r * cos(angle);
        yn = spring_r * sin(angle);
        zn = (angle/360) * rise_per_rev;
        // The sphere node is easy:
        translate([xn, yn, zn]) sphere(r=wire_r);
        // The cylinder joining them is more complicated.  Start with cylinder
        // of step_len, rotate it down to point a step up in Z, then rotate it
        // around Z to point from [x,y,z] to [xn,yn,zn], then move it to [x,y,z]
        if (angle < turns*360) {
            translate([x, y, z]) rotate([0, 0, 90+(angle+step_deg/2)])
                rotate([0, 90-z_angle, 0]) cylinder(h=step_len, r=wire_r);
        }
        x = xn; y = yn; z = zn;
    }
}

module countersunk_bolt_hole(shaft_d, shaft_len, head_d, head_len) {
    // The solid area taken up by a countersunk bolt, to be subtracted
    // from a body to make a screw hole.  The bolt is 'pointing down' and is
    // centred on the Z axis.
    union() {
        cylinder(h=shaft_len, d=shaft_d);
        translate([0, 0, shaft_len-0.01]) cylinder(h=head_len, d1=shaft_d, d2=head_d);
    }
}

module flat_head_bolt_hole(shaft_d, shaft_len, head_d, head_len) {
    // The solid area taken up by a flat-head bolt, to be subtracted
    // from a body to make a screw hole.  The bolt is 'pointing down' and is
    // centred on the Z axis.
    union() {
        cylinder(h=shaft_len, d=shaft_d);
        translate([0, 0, shaft_len-0.01]) cylinder(h=head_len+0.01, d=head_d);
    }
}
