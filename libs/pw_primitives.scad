epsilon = 0.01;
epsilo2 = epsilon*2;

////////////////////////////////////////////////////////////////////////////////
// ARRANGERS
////////////////////////////////////////////////////////////////////////////////

// abbreviated translate
module txl(x=0, y=0, z=0) { translate([x, y, z]) children();}
// abbreviated rotate
module rot(x=0, y=0, z=0) { rotate([x, y, z]) children();}

module hex_distribute(num_x, num_y, diameter) {
    // Spreads a child across a hexagonal grid num_x across and num_y along, with
    // each hexagon having a widest diameter (point to point) of diameter.
    // IOW, each X object will be diameter apart and the space between X objects
    // in adjacent rows will be diameter apart, at a 60 degree diagonal.  Y rows
    // will be less than diameter apart, but even numbered Y columns will line
    // up on the same X value, as will odd numbered Y columns.
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


module rotate_distribute(number, angle=360, last_fencepost=false) {
    // Spreads a number of child objects across an angle.  If 'last_fencepost' is set,
    // then there will be a last item placed at that ending spot; if it is set to false,
    // there is no 'last' fencepost at the ending angle.  rotate_distribute is
    // mostly used when distributing n items evenly around a circle; when the angle
    // is less than 360 degrees you probably want to turn last_fencepost on.
    for(i = [0 : number-1]) {
        rotate([0, 0, i * angle / (number - (last_fencepost ? 1 : 0))]) children();
    }
}


module linear_distribute(start, step, end, tvec = [1, 0, 0]) {
    // Distribute children in a for loop, but multiplying the translation
    // vector `tvec` by the loop value.
    for(i = [start : step : end]) {
        translate(tvec*i) children();
    }
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
    // apparently 'if {}' blocks keep the context of variables, so we can't
    // use that to change the chamfer_rad.
    chamfer_rad = (chamfer_rad >= x/2) || (chamfer_rad >= y/2)
      ? min(x, y)/2 - epsilon : chamfer_rad;
    c2 = chamfer_rad*2;
    linear_extrude(z, center=false) translate([chamfer_rad, chamfer_rad, 0])
      offset(r=chamfer_rad) square([x-c2, y-c2], center=false);
}

module hexahedron(corners, convexity=1) {
    // A 'cube', but with eight arbitrary corners.  The corners must be
    // listed in this order:
    // - the bottom four corners, such that going around them in the order
    //   0, 1, 2, 3 is a clockwise circle as seen from the outside facing
    //   inward (i.e. from the bottom, looking up).
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

/* From the examples at
 * https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
 * via https://github.com/superjamie/handyscad/blob/master/handyscad.scad
 * For when you need a cylinder or circle that entirely encompasses a circle of a
 * given radius, because of the way circular objects are approximated by straight
 * line segments in OpenSCAD.
 *
 */
module cylinder_outer(h, d=undef, r=undef) {
    // entirely encompasses a given cylinder
    assert (!(r == undef) || (d == undef));
    radius = (r == undef) ? d/2 : r;
    fn = ($fn > 0) ? max($fn, 3) : ceil(max(min(360/$fa,r*2*PI/$fs),5));
    fudge = 1/cos(180/fn);
    cylinder(h=h, r=radius*fudge);
}

module cylinder_mid(h, d=undef, r=undef) {
    // the mid-point between cylinder and cylinder_outer
    assert (!(r == undef) || (d == undef));
    radius = (r == undef) ? d/2 : r;
    fn = ($fn > 0) ? max($fn, 3) : ceil(max(min(360/$fa,r*2*PI/$fs),5));
    fudge = (1+1/cos(180/fn))/2;
    cylinder(h=h, r=radius*fudge);
}


module circle_outer(d=undef, r=undef) {
    // entirely encompasses a given circle
    assert (!(r == undef) || (d == undef));
    radius = (r == undef) ? d/2 : r;
    fn = ($fn > 0) ? max($fn, 3) : ceil(max(min(360/$fa,r*2*PI/$fs),5));
    fudge = 1/cos(180/fn);
    circle(r=radius*fudge);
}

module circle_mid(d=undef, r=undef) {
    // the mid-point between circle and circle_outer
    assert (!(r == undef) || (d == undef));
    radius = (r == undef) ? d/2 : r;
    fn = ($fn > 0) ? max($fn, 3) : ceil(max(min(360/$fa,r*2*PI/$fs),5));
    fudge = (1+1/cos(180/fn))/2;
    circle(r=radius*fudge);
}

module ellipse(x, y) {
    scale([1, y/x, 1]) circle(d=x);
}

module ellipsoid(x, y, height) {
    scale([1, y/x, 1]) cylinder(h=height, d=x);
}

module elliptical_pipe(x, y, height, thick)
linear_extrude(height, convexity=3) difference() {
    scale([1, (y+thick)/(x+thick), 1]) circle(d=x+thick);
    scale([1, y/x, 1]) circle(d=x);
}

module pipe_rt(height, radius, thickness)
linear_extrude(height, convexity=3) difference() {
    // For when you know the outer radius and the wall thickness.
    circle(r=radius);
    circle(r=radius-thickness);
}

module pipe_oi(height, o_radius, i_radius)
linear_extrude(height, convexity=3) difference() {
    // For when you know the outer and inner radius but not the wall thickness.
    circle(r=o_radius);
    circle_outer(r=i_radius);
}

module hollow_cone_rt(height, bottom_radius, top_radius, thickness) { difference() {
    // For when you know the outer radii and the wall thickness.
    // We can't do cones with the linear_extrude, so we have to do it with
    // cylinders.  This may not cope well with some $fn/$fa/$fs settings.
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

module torus(outer, inner, x_stretch=1, angle=360) {
    // a torus whose ring is a circle of outer-inner radius,
    // centred on a circle of outer radius.  Can be scaled to make a flat or
    // tall toroid.
    assert(outer > inner, "Torus inner must be less than outer");
    rotate_extrude(angle=angle, convexity=2) translate([max(outer-inner, 0), 0, 0]) 
      scale([x_stretch, 1, 1]) circle(r=inner);
}

module toroidal_pipe(bend_radius, pipe_i_radius, thickness, angle=360) {
    // A toroidal pipe with *inner* radius and wall thickness, with an outer bend
    // radius.  Elliptical toroidal pipes need a different scaling calculation
    // and are handled separately.
    assert(bend_radius > pipe_i_radius+thickness*2, "Pipe radius must be less than bend radius");
    rotate_extrude(angle=angle, convexity=2)
      translate([max(bend_radius-pipe_i_radius, 0), 0, 0]) difference() {
        circle(r=pipe_i_radius+thickness);
        circle_outer(r=pipe_i_radius);
    }
}

module quarter_torus_bend_snub_end(outer_rad, width, angle, outer=true) {
    // A torus's upper quarter - inner or outer depending on the 'outer' setting
    // - of a given outer_rad distance from the centre of the torus to the right
    // angle in the quadrant, that is a given width high and wide, stretching an
    // angle around the circle.
    // In other words, a quarter-circle shaped piece wrapped around the outside
    // or inside (again if outer is false or true, respectively).  The
    // 'front' and 'back' of the piece end in spheres to make it a bit
    // 'aerodynamic'.
    intersection() {
        union() {
            torus(outer_rad+width, width, angle=angle);
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

module conduit_angle_bend(
    bend_radius, pipe_radius, bend_angle, thickness, join_length, join_radius=undef,
    join_a=true, join_b=true, flare_a=true, flare_b=true,
    curved_a=false, curved_b=false
) union() {
    // A piece of conduit with a pipe *inner* radius (not diameter) and wall
    // thickness, curving around a bend angle at a bend radius from the centre
    // of the circle.  The two ends can have straight flanges (a flange allows
    // a pipe of pipe radius to fit inside it) with a join length, overlapping
    // into the angle bend for a given length.  The flanges can be disabled, which
    // will result in a smaller piece of straight pipe of the given radius and
    // wall thickness (with no overlap).  The flanges can also be curved (to join
    // another piece of curved pipe) or straight.
    join_radius = (join_radius!=undef) ? join_radius : pipe_radius + thickness;
    // The actual bend
    toroidal_pipe(bend_radius, pipe_radius, thickness, bend_angle);
    // First flange
    if (join_a) {
        // because pipe_rt takes outer radius and here we have inner radius
        join_a_rad = (flare_a ? join_radius : pipe_radius) + thickness;
        translate([bend_radius-pipe_radius, 0, 0])
          rotate([90, 0, 0]) union() {
            if (curved_a) {
                j_a_angle=atan2(join_length, bend_radius-join_a_rad);
                j_a_rad = join_a_rad - thickness;
                translate([-bend_radius+join_a_rad-thickness, 0, 0]) rotate([90, 0, 0])
                  toroidal_pipe(bend_radius, join_a_rad-thickness, thickness, angle=j_a_angle);
            } else {
                pipe_rt(join_length, join_a_rad, thickness);
            }
            if (flare_a) {
                translate([0, 0, -thickness]) hollow_cone_rt(
                  thickness, pipe_radius+thickness, join_a_rad, thickness
                );
            }
        }
    }
    // Second flange (taken around the angle)
    if (join_b) {
        join_b_rad = (flare_b ? join_radius : pipe_radius) + thickness;
        rotate([90, 0, bend_angle]) {
            if (curved_b) {
                j_b_angle = atan2(join_length, bend_radius-join_b_rad);
                j_b_rad = join_b_rad - thickness;
                translate([flare_b ? thickness : 0, 0, 0])
                rotate([90, j_b_angle, 0])
                  toroidal_pipe(bend_radius, j_b_rad, thickness, j_b_angle);
            } else {
                translate([bend_radius-join_radius+thickness, 0, -join_length])
                pipe_rt(join_length, join_b_rad, thickness);
            }
            if (flare_b) {
                translate([bend_radius-join_b_rad+thickness*2, 0, 0])
                hollow_cone_rt(
                  thickness, join_b_rad, pipe_radius+thickness, thickness
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
    // going length in the Y direction.  Bore of pipe is along Y axis.
    cube([width, length, height]);
    translate([thickness, -epsilon, thickness]) cube([
      width-thickness*2, length+epsilo2, height-thickness*2
    ]);
}

module rectangular_tube(x, y, thickness, height) {
    // x and y are INNER widths, and tube goes in the Z direction like a cylinder.
    difference() {
        cube([x+thickness*2, y+thickness*2, height]);
        translate([thickness, thickness, -epsilon]) cube([x, y, height+epsilo2]);
    }
}

module rectangular_cone(x1, y1, x2, y2, height, center=true) {
    // A symmetrical rectangular cone, from -x1,-y1 to x1,y1 on the XY plane
    // and from -x2,-y2 to x2,y2 at height.  This is not really a 'cone'
    // because the x and y can vary independently - i.e. the slope of the X faces
    // can be different from the Y faces, if x1 > x2 but y1 < y2 say.
    translate([center?0:x1, center?0:y1, 0]) polyhedron(
    points=[ // points
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


module rectangular_hollow_cone(height, x1, y1, x2, y2, thickness) {
    // Like the hollow_cone_rt, but as a rectangle; bottom goes from
    // -(x1+thickness),-(y1+thickness) to +(x1+thickness),+(y1+thickness)
    // and top likewise.  I.e. x1,x2 and y1,y2 are the INNER radius.
    polyhedron(points=[
        [-(x1+thickness),-(y1+thickness), 0], [+(x1+thickness),-(y1+thickness), 0],
        [+(x1+thickness),+(y1+thickness), 0], [-(x1+thickness),+(y1+thickness), 0],
        [-x1, -y1, 0], [+x1, -y1, 0], [+x1, +y1, 0], [-x1, +y1, 0],
        [-(x2+thickness),-(y2+thickness), height], [+(x2+thickness),-(y2+thickness), height],
        [+(x2+thickness),+(y2+thickness), height], [-(x2+thickness),+(y2+thickness), height],
        [-x2, -y2, height], [+x2, -y2, height], [+x2, +y2, height], [-x2, +y2, height],
    ], faces=[
        [0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 0, 4, 7], // bottom
        [0, 8, 9, 1], [1, 9, 10, 2], [2, 10, 11, 3], [3, 11, 8, 0], // outside
        [4, 5, 13, 12], [5, 6, 14, 13], [6, 7, 15, 14], [7, 4, 12, 15], // inside
        [8, 12, 13, 9], [9, 13, 14, 10], [10, 14, 15, 11], [11, 15, 12, 8] // top
    ], convexity=2);
}


module rectangular_torus(outer, inner, height, angle=360) {
    // a torus from inner radius to outer radius - thickness is
    // outer-inner - and height in z.
    rotate_extrude(angle=angle) {
        translate([inner, 0, 0]) square([outer-inner, height]);
    }
}

module rectangular_pipe_bend(width, height, thickness, inner_radius, bend_angle) {
    rotate_extrude(angle=bend_angle, convexity=2)
      translate([inner_radius, 0, 0]) difference() {
        square([width+thickness*2, height+thickness*2]);
        translate([thickness, thickness, 0]) square([width, height]);
    }
}

module rectangular_pipe_bend_straight_ends(
    width, height, thickness, inner_radius, bend_angle, join_length,
    overlap_len, join_a=true, join_b=true, flange_a=true, flange_b=true,
    curved_a=false, curved_b=false
){
    // a rectangular pipe of inner measurements width * height, bent around
    // inner_radius, with walls of thickness.  Pipe is on XY plane, starting
    // from +xz plane.
    join_angle = atan2(join_length, inner_radius);
    translate([0, join_length, 0]) rectangular_pipe_bend(
        width, height, thickness, inner_radius, bend_angle
    );
    if (join_a) {
        fa_thick = flare_a ? thickness*2 : 0;
        fa_outer = fa_thick + thickness*2;
        if (flange_a) translate([0, 0, 0]) rotate([-90, 0, 0]) rectangular_cone(
            width+thickness*2, height+thickness*2, width, height, thickness
        );
        translate([0, 0, -fa_thick]) if (curved_a) {
            rotate([0, 0, overlap_angle-join_angle])
              rectangular_pipe_bend(
                width+fa_outer, height+fa_outer, thickness,
                inner_radius-fa_thick, join_angle
              );
        } else {
            translate([inner_radius-fa_thick, 0, 0]) difference() {
                cube([width+fa_outer, join_length+overlap_len, height+fa_outer]);
                translate([thickness, -0.01, thickness])
                  cube([width+fa_thick, join_length+overlap_len+0.02, height+fa_thick]);
            }
        }
    };
    if (join_b) {
        fb_thick = flare_b ? thickness : 0;
        fb_outer = fb_thick + thickness*2;
        translate([0, join_length, 0]) rotate([0, 0, bend_angle])
          translate([inner_radius-fb_thick, 0, -fb_thick]) difference() {
            cube([width+fb_outer, join_length+overlap_len, height+fb_outer]);
            translate([thickness, -0.01, thickness])
              cube([width+fb_thick, join_length+overlap_len+0.02, height+fb_thick]);
        }
    }
}

* rectangular_pipe_bend_straight_ends(
    60, 40, 3, 20, 45, 10,
    15, join_a=true, join_b=true, flange_a=true, flange_b=true,
    curved_a=false, curved_b=false
);

module rectangular_pipe_bend_curved_ends(
    width, height, thickness, inner_radius, bend_angle, join_angle,
    overlap_angle, join_a=false, join_b=false, flange_a=true, flange_b=true
) {
    // a rectangular pipe of inner measurements width * height, bent around
    // inner_radius for bend_angle, with walls of thickness.  Pipe is on XY
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

////////////////////////////////////////////////////////////////////////////////
// TRIANGLE SHAPES
////////////////////////////////////////////////////////////////////////////////

module equ_triangle(side) {
    // the easy case
    polygon([[0, 0], [side, 0], [side/2, side*sin(60)]]);
}

module arb_triangle(ab, bc, ac) {
    // the complicated case - three distances.  Point A is on the origin,
    // and side ab is along the X axis.  We use the law of cosines to
    // derive cos(CAB), substitute that into the polar-to-cartesian
    // calculation to derive ac's X component, and then use Pythagoras'
    // Theorem knowing the hypotenuse of that right angled triangle ab-x-y.
    assert(
        max(ab, bc, ac) < ((ab+bc+ac)-max(ab, bc, ac)),
        "Longest side must be shorter than the other two sides combined"
    );
    let(x=(bc*bc+ac*ac-ab*ab)/(2*bc), y=sqrt(ac*ac-x*x)) {
        echo(ac=ac, x=x, y=y);
        polygon([[0, 0], [ac, 0], [x, y]]);
    }
}

////////////////////////////////////////////////////////////////////////////////
// HEXAGON SHAPES
////////////////////////////////////////////////////////////////////////////////

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
    linear_extrude(height) hexagon(radius);
}

module tapered_hexagon(radius1, radius2, height) {
    // We have to construct this from a polyhedron, since linear_extrude doesn't
    // do expansion and I don't really want to have to come up with the three
    // dimensional scale transform.
    radius1b = radius1*sin(30);
    radius1c = radius1*sin(60);
    radius2b = radius2*sin(30);
    radius2c = radius2*sin(60);
    polyhedron([
        // bottom hexagon
        [radius1, 0, 0], [radius1b, radius1c, 0],
        [-radius1b, radius1c, 0], [-radius1, 0, 0],
        [-radius1b, -radius1c, 0], [radius1b, -radius1c, 0],
        // top hexagon
        [radius2, 0, height], [radius2b, radius2c, height],
        [-radius2b, radius2c, height], [-radius2, 0, height],
        [-radius2b, -radius2c, height], [radius2b, -radius2c, height],
    ], [
        [0, 1, 2, 3, 4, 5],  // bottom hexagon
        [0, 6, 7, 1], // side 1
        [1, 7, 8, 2], // side 2
        [2, 8, 9, 3], // side 3
        [3, 9, 10, 4], // side 4
        [4, 10, 11, 5], // side 5
        [5, 11, 6, 0], // side 6
        [11, 10, 9, 8, 7, 6], // top hexagon
    ]);
}
