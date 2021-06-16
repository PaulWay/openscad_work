module hollow_cube(length, width, height, wall_t) {
    difference() {
        two_t = wall_t*2;
        cube([length, width, height]);
        translate([wall_t, wall_t, -0.1]) 
          cube([length-two_t, width-two_t, height+0.2]);
    }
}

module rounded_box(length, width, height, outer_r, inner_r, thickness) {
    outer_d = outer_r*2;
    inner_t = thickness+inner_r;
    inner_d = outer_d+inner_t*2;
    translate([outer_r, outer_r, outer_r]) difference() {
        // outer rounded rectangle
        minkowski() {
            cube([length-outer_d, width-outer_d, height-outer_r]);
            sphere(r=outer_r);
        };
        // top face
        translate([-outer_r, -outer_r, height-outer_r]) 
          cube([length+2*outer_r, width+2*outer_r, outer_r]);
        // inner rounded rectangle
        translate([inner_t, inner_t, inner_t]) minkowski() {
            cube([length-inner_d, width-inner_d, height]);
            sphere(r=inner_r);
        };
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

module torus(outer, inner)
    rotate_extrude() {
        translate([max(outer-inner, 0), 0, 0]) circle(r=inner);
    }
