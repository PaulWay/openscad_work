epsilon = 0.01;
epsilo2 = epsilon*2;

////////////////////////////////////////////////////////////////////////////////
// ARRANGERS
////////////////////////////////////////////////////////////////////////////////

module hex_arrange(num_x, num_y, diameter) {
    alt_row_shift = diameter/2;
    row_offset = diameter * sin(60);
    for (x = [0:num_x-1]) {
        for (y = [0:num_y-1]) {
            x_off = x * diameter + (y % 2) * alt_row_shift;
            y_off = y * row_offset;
            translate([x_off, y_off, 0]) children();
        };
    };
}

////////////////////////////////////////////////////////////////////////////////
// SIMPLE CUBE MODULES
////////////////////////////////////////////////////////////////////////////////

module rounded_box(length, width, height, outer_r) {
    // A simple solid box with rounded bottom and side edges.
    // Essentially this is a box with spherical corners and cylindrical
    // edges on the outside.  You can then subtract whatever object you want
    // from it to make it hollow if you like.
    // Parameters are: the external length, width and height,
    // the radius of the corners and edges.
    outer_d = outer_r*2;
    translate([outer_r, outer_r, outer_r]) difference() {
        // outer rounded rectangle
        minkowski() {
            cube([length-outer_d, width-outer_d, height-outer_r]);
            sphere(r=outer_r);
        };
        // top face
        translate([-outer_r, -outer_r, height-outer_r+epsilon]) 
          cube([length+2*outer_r, width+2*outer_r, outer_r]);
    }
}

module chamfered_cube(x, y, z, side, chamfer_x=true, chamfer_y=true, chamfer_z=true) {
    // A simple solid box, chamfered on all sides.
    s2=side*2;
    xoff = chamfer_x ? side : 0; xsub = chamfer_x ? s2 : 0;
    yoff = chamfer_y ? side : 0; ysub = chamfer_y ? s2 : 0;
    zoff = chamfer_z ? side : 0; zsub = chamfer_z ? s2 : 0;
    
    hull() {
        translate([xoff, yoff, 0]) cube([x-xsub, y-ysub, z]);
        translate([xoff, 0, zoff]) cube([x-xsub, y, z-zsub]);
        translate([0, yoff, zoff]) cube([x, y-ysub, z-zsub]);
    }
}

module rounded_cube(x, y, z, chamfer_rad) {
    // A simple cube with rounded vertical sides but a flat base
    // apparently if {} blocks keep the context of 
    chamfer_rad = (chamfer_rad >= x/2) || (chamfer_rad >= y/2)
      ? min(x, y)/2 - epsilon : chamfer_rad;
    c2 = chamfer_rad*2;
    linear_extrude(z, center=false) translate([chamfer_rad, chamfer_rad, 0]) 
      offset(r=chamfer_rad) square([x-c2, y-c2], center=false);
}

module hexahedron(corners, convexity) {
    // A 'cube', but with eight arbitrary corners.  The corners must be
    // listed in this order:
    // - the bottom four corners, such that going around them in the order
    //   0, 1, 2, 3 is a clockwise circle as seen from the outside facing
    //   inward.
    // - the top four corners, such that going around them in the order
    //   *7, 6, 5, 4* is a *clockwise* circle as seen from the outside
    //   facing inward.  In other words, the top four are in the opposite
    //   order from the bottom four.
    // This is the same as the example given in:
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
    // i.e.
    //
    // 7--------6
    // |  top   |
    // 4--------5-------6------7------4
    // | front  | right | back | left |
    // 0--------1-------2------3------0
    // | bottom |
    // 3--------2
    polyhedron(
        points=corners, faces=[
            [0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]   // left
        ], convexity=convexity
    );
}

////////////////////////////////////////////////////////////////////////////////
// RINGS AND CONES
////////////////////////////////////////////////////////////////////////////////

module pipe_rt(height, radius, thickness) { difference() {
    // For when you know the outer radius and the wall thickness.
    cylinder(h=height, r=radius);
    translate([0, 0, -epsilon]) 
      cylinder(h=height+epsilo2, r=max(radius-thickness, 0));
}};

module pipe_oi(height, o_radius, i_radius) { difference() {
    // For when you know the outer and inner radius but not the wall thickness.
    cylinder(h=height, r=o_radius);
    translate([0, 0, -epsilon]) 
      cylinder(h=height+epsilo2, r=i_radius);   
}};

module hollow_cone_rt(height, bottom_radius, top_radius, thickness) { difference() {
    // For when you know the outer radii and the wall thickness.
    cylinder(h=height, r1=bottom_radius, r2=top_radius);
    translate([0, 0, -epsilon]) cylinder(
        h=height+epsilo2, 
        r1=max(bottom_radius-thickness, 0), r2=max(top_radius-thickness, 0)
    );
}};

module hollow_cone_oi(
    height, o_bot_radius, i_bot_radius, o_top_radius, i_top_radius,
) { difference() {
    // For when you know the outer and inner radii but not the wall thickness.
    cylinder(h=height, r1=o_bot_radius, r2=o_top_radius);
    translate([0, 0, -epsilon]) 
      cylinder(h=height+epsilo2, r1=i_bot_radius, r2=i_top_radius);
}};

////////////////////////////////////////////////////////////////////////////////
// CYLINDER SEGMENTS
////////////////////////////////////////////////////////////////////////////////

module half_cylinder(height, radius) {
    // Half of a cylinder of the given height and radius in the positive X, so
    // starting from -Y radius to +Y radius.
    intersection() {
        cylinder(h=height, r=radius);
        translate([0, -radius, 0]) cube([radius, radius*2, height]);
    }
};

module cylinder_segment(height, radius, angle=360) {
    // Make an arc of a pipe by sweeping a rectangle through a rotate_extrude.
    rotate_extrude(angle=angle, convexity=2) {
        square([radius, height]);
    }
}

module pipe_rt_segment(radius, thickness, height, angle) {
    // Make an arc of a pipe by sweeping a rectangle through a rotate_extrude.
    rotate_extrude(angle=angle, convexity=2) {
        translate([radius, 0, 0]) square([thickness, height]);
    }
}

////////////////////////////////////////////////////////////////////////////////
// TOROIDS AND PIPE BENDS
////////////////////////////////////////////////////////////////////////////////

module torus(outer, inner, angle=360)
    // a torus whose ring is a circle of outer-inner radius, 
    // centred on a circle of outer radius.
    rotate_extrude(angle=angle) {
        translate([max(outer-inner, 0), 0, 0]) circle(r=inner);
    };


module quarter_torus_bend_snub_end(outer_rad, width, angle, outer=true) {
    // A torus's upper quarter - inner or outer depending on the 'outer' setting
    // - of a given outer_rad distance from the centre of the torus to the right
    // angle in the quadrant, that is a given width high and wide, stretching an
    // angle around the circle.
    // In other words, a quarter-circle shaped piece wrapped around the outside
    // or inside (again if cut_outer is false, or true, respectively).  The
    // 'front' and 'back' of the piece end in spheres to make it a bit
    // 'aerodynamic'.
    intersection() {
        union() {
            torus(outer_rad+width, width, angle);
            rotate([0, 0, 0]) translate([outer_rad, 0, 0]) sphere(r=width);
            rotate([0, 0, angle]) translate([outer_rad, 0, 0]) sphere(r=width);
        }
        if (outer) {
            difference() {
                translate([0, 0, 0]) cylinder(h=width+epsilon, r=outer_rad+width);
                translate([0, 0, -epsilon]) cylinder(h=width+epsilo2, r=outer_rad);
            }
        } else {
            translate([0, 0, -epsilon]) cylinder(h=width+epsilon, r=outer_rad);
        }
    }
}

module conduit_angle_bend_straight_join(
    bend_radius, pipe_radius, bend_angle, thickness, join_length, overlap_len,
    join_a=true, join_b=true, flare_a=true, flare_b=true
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
        rotate([0, 0, -epsilon]) torus(bend_radius, pipe_radius-thickness, bend_angle+epsilo2);
    };
    // First flange
    if (join_a) {
        join_a_rad_ext = (flare_a ? overlap_len : 0);
        translate([bend_radius-pipe_radius+thickness, 0, 0])
          rotate([90, 0, 0]) union() {
            ring_rt(join_length, pipe_radius+join_a_rad_ext, thickness);
            if (flare_a) {
                translate([0, 0, -overlap_len]) hollow_cone_rt(
                  thickness, pipe_radius, 
                  pipe_radius+join_a_rad_ext, thickness
                );
            }
        }
    }
    // Second flange (taken around the angle)
    if (join_b) {
        join_b_rad_ext = (flare_b ? overlap_len : 0);
        rotate([0, 0, bend_angle])
          translate([bend_radius-pipe_radius+thickness, join_length-join_b_rad_ext, 0])
          rotate([90, 0, 0]) union() {
            ring_rt(join_length, pipe_radius+join_b_rad_ext, thickness);
            if (flare_b) {
                translate([0, 0, join_length]) hollow_cone_rt(
                  thickness, pipe_radius+join_b_rad_ext, 
                  pipe_radius, thickness
                );
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// RECTANGULAR TUBES AND TOROIDS
////////////////////////////////////////////////////////////////////////////////

module rectangular_pipe(width, height, thickness, length) difference() {
    // a rectangular pipe of OUTER width (X) and height (Z), with walls of thickness,
    // going length in the Y direction.
    cube([width, length, height]);
    translate([thickness, -epsilon, thickness]) cube([
      width-thickness*2, length+epsilo2, height-thickness*2
    ]);
}

module hollow_cube(length, width, height, wall_t) {
    // a rectangular pipe of OUTER length (X) and width (Y), with walls of thickness,
    // going height in the Z direction.
    difference() {
        two_t = wall_t*2;
        cube([length, width, height]);
        translate([wall_t, wall_t, -epsilon]) 
          cube([length-two_t, width-two_t, height+epsilo2]);
    }
}

module rectangular_tube(x, y, thickness, height) {
    // x and y are INNER widths, and tube goes in the Z direction like a cylinder.
    difference() {
        cube([x+thickness*2, y+thickness*2, height]);
        translate([thickness, thickness, -epsilon]) cube([x, y, height+epsilo2]);
    }
}

module rectangular_cone(x1, y1, x2, y2, height) {
    // A symmetrical rectangular cone, from -x1,-y1 to x1,y1 on the XY plane
    // and from -x2,-y2 to x2,y2 at height.  This is not really a 'cone'
    // because the x and y can vary independently - i.e. the slope of the X faces
    // can be different from the Y faces, if x1 > x2 but y1 < y2 say.
    polyhedron(points=[ // points
        [-x1, -y1, 0], [x1, -y1, 0], [x1, y1, 0], [-x1, y1, 0],
        [-x2, -y2, height], [x2, -y2, height], [x2, y2, height], [-x2, y2, height]
    ], faces=[ // faces - clockwise facing in, right hand rule
        [0, 1, 2, 3], // bottom
        [0, 4, 5, 1], // -y face
        [1, 5, 6, 2], // +x face
        [2, 6, 7, 3], // +y face
        [3, 7, 4, 0], // -x face
        [4, 7, 6, 5]  // top
    ], convexity=1);
};


module rectangular_torus(outer, inner, height, angle=360) {
    // a torus from inner radius to outer radius - thickness is
    // outer-inner - and height in z.
    rotate_extrude(angle=angle) {
        translate([inner, 0, 0]) square([outer-inner, height]);
    }
}

module rectangular_pipe_bend(width, height, thickness, inner_radius, bend_angle) {
    difference() {
        rectangular_torus(
          width+inner_radius+thickness*2, inner_radius, 
          height+thickness*2, bend_angle
        );
        translate([0, 0, thickness]) rotate([0, 0, -0.01]) rectangular_torus(
          width+inner_radius+thickness, inner_radius+thickness, 
          height, bend_angle+0.02
        );
    }
}

module rectangular_pipe_bend_straight_ends(
    width, height, thickness, inner_radius, bend_angle, join_length,
    overlap_len, join_a=true, join_b=true, flange_a=true, flange_b=true
){
    // a rectangular pipe of inner measurements width * height, bent around
    // inner_radius, with walls of thickness.  Pipe is on XY plane, starting
    // from +xz plane.
    translate([0, join_length, 0]) rectangular_pipe_bend(
        width, height, thickness, inner_radius, bend_angle
    );
    if (join_a) {
        fa_thick = flange_a ? thickness*2 : 0;
        fa_outer = fa_thick + thickness*2;
        translate([inner_radius-fa_thick, 0, -fa_thick]) difference() {
            cube([width+fa_outer, join_length+overlap_len, height+fa_outer]);
            translate([thickness, -0.01, thickness])
              cube([width+fa_thick, join_length+overlap_len+0.02, height+fa_thick]);
        }
    };
    if (join_b) {
        fb_thick = flange_b ? thickness : 0;
        fb_outer = fb_thick + thickness*2;
        translate([0, join_length, 0]) rotate([0, 0, bend_angle]) 
          translate([inner_radius-fb_thick, 0, -fb_thick]) difference() {
            cube([width+fb_outer, join_length+overlap_len, height+fb_outer]);
            translate([thickness, -0.01, thickness])
              cube([width+fb_thick, join_length+overlap_len+0.02, height+fb_thick]);
        }
    }
}

module rectangular_pipe_bend_curved_ends(
    width, height, thickness, inner_radius, bend_angle, join_angle,
    overlap_angle, join_a=true, join_b=true, flange_a=true, flange_b=true
) {
    // a rectangular pipe of inner measurements width * height, bent around
    // inner_radius for bend_anghe, with walls of thickness.  Pipe is on XY
    // plane, starting from +xz plane.  If flange_a and/or flange_b is set,
    // these parts (the 'a' and 'b' ends of the pipe) are flared (extending
    // below XY plane). Total bend angle is bend_angle + 
    // (join_angle-overlap_angle)*2 - set join and overlap angles to zero to
    // have no extras.
    // main bend
    tor_outer_r = width+inner_radius+thickness;
    rectangular_pipe_bend(
        width, height, thickness, inner_radius, bend_angle
    );
    // flange a
    if (join_a) {
        fa_thick = flange_a ? thickness : 0;
        fa_outer = fa_thick*2;
        translate([0, 0, -fa_thick]) rotate([0, 0, overlap_angle-join_angle])
          rectangular_pipe_bend(
            width+fa_outer, height+fa_outer, thickness, inner_radius-fa_thick, join_angle
          );
    }
    // flange b
    if (join_b) {
        fb_thick = flange_b ? thickness : 0;
        fb_outer = fb_thick*2;
        translate([0, 0, -fb_thick]) rotate([0, 0, bend_angle+overlap_angle-join_angle])
          rectangular_pipe_bend(
            width+fb_outer, height+fb_outer, thickness, inner_radius-fb_thick, join_angle
          );
    }
}

////////////////////////////////////////////////////////////////////////////////
// SPRINGS
////////////////////////////////////////////////////////////////////////////////

module coil_spring(spring_r, wire_r, rise_per_rev, turns, step_deg) {
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

module flat_spring(length, width, height, gap_length, segments) union() {
    // Like a cube of [length, width, height], but with segments 'cut out'
    // progressively full-width across the top and bottom, at half the height.
    // The gap sits in the middle of the 'segment' length (length / segments).
    seg_len = length / segments;
    split_offset = (seg_len - gap_length) / 2;
    h2 = height / 2;
    difference() {
        cube([length, width, height]);
        for (i = [0:segments]) {
            translate([i * seg_len + split_offset, -epsilon, h2 * (i % 2) - epsilon])
              cube([gap_length, width+epsilo2, h2 + epsilo2]);
        }
    }
}

module rect_circ_spring(in_radius, out_radius, angle, segments, height, thickness) union () {
    // A flexible 'spring' curve made purely out of rectangular pieces.
    // There will always be a last segment wall - the angle is divided up into
    // segments-1 pieces so there are always 'segments' number of radial pieces.
    assert (segments > 1, "must have at least two segments");
    rad_diff = out_radius - in_radius;
    seg1 = (segments-1);
    in_step = (in_radius * PI) / seg1;  // both half a circumference because of interleave
    out_step = (out_radius * PI) / seg1;
    for(seg = [0:seg1]) {
        frac = seg/seg1;
        rotate([0, 0, angle*frac]) translate([in_radius, 0, 0]) {
            cube([rad_diff, thickness, height]);
            if (seg % 2 == 0 && (seg < seg1)) {
                rotate([0, 0, (angle/seg1)/2]) translate([0, thickness/2, 0])
                  cube([thickness, in_step, height]);
            }
            if (seg % 2 == 1 && (seg < seg1)) {
                rotate([0, 0, (angle/seg1)/2]) translate([rad_diff-thickness, 0, 0]) 
                  cube([thickness, out_step, height]);
            }
        }
    };
}

////////////////////////////////////////////////////////////////////////////////
// BOLT SHAPES
////////////////////////////////////////////////////////////////////////////////

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

module hexagon(radius) {
    // A hexagon centred on the origin, with points on the X-Y plane, extending
    // up into the +Z.  Diameter is from point to point, not flat to flat.
    radius2 = radius*sin(30);
    radius3 = radius*sin(60);
    polygon([  // going anticlockwise
        [radius, 0], [radius2, radius3], [-radius2, radius3], 
        [-radius, 0], [-radius2, -radius3], [radius2, -radius3],
    ]);
}

module hexagon_solid(radius, height) {
    // A hexagon centred on the origin, with points on the X-Y plane, extending
    // up into the +Z.  Diameter is from point to point, not flat to flat.
    radius2 = radius*sin(30);
    radius3 = radius*sin(60);
    linear_extrude(height)
    polygon([  // going anticlockwise
        [radius, 0], [radius2, radius3], [-radius2, radius3], 
        [-radius, 0], [-radius2, -radius3], [radius2, -radius3],
    ]);
}
