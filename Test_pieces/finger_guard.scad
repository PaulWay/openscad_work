module rotate_distribute(number, angle=360, last_fencepost=false) {
    // Spreads a number of child objects across an angle.  If 'last_fencepost' is set,
    // then there will be a last item placed at that ending spot; if it is set to false,
    // there is no 'last' fencepost at the ending angle.  rotate_distribute is
    // mostly used when distributing n items evenly around a circle; when the angle
    // is less than 360 degrees you probably want to turn last_fencepost on.
    let(last_number = number - (last_fencepost ? 1 : 0))
    for(i = [0 : number-1]) {
        rotate([0, 0, i * angle / last_number]) children();
    }
}

module linear_distribute(start, step, end, tvec = [1, 0, 0]) {
    // Distribute children along the translation vector given.
    for(i = [start : step : end]) {
        translate(tvec*i) children();
    }
}

height = 50;
inner_size_base = 24;
inner_size_tip = 21;
thickness = 2;
hole_size = 2;
holes_per_layer = 19;
split_dia = 3;

outer_size_base = inner_size_base + thickness;
outer_size_tip= inner_size_tip + thickness;
outer_tip_rad = outer_size_tip / 2;
hole_start = min(inner_size_base, inner_size_tip) / 2;
hole_len = abs(inner_size_base - inner_size_tip) + thickness;
max_width = max(outer_size_base, outer_size_tip) + 0.02;
alt_layer_rot_offset = 180 / holes_per_layer;
layer_step = (hole_size*2);

// 72, 54, 36, 18 worked well if no alternate row in sphere
dome_layer_1_ang = 67;
dome_layer_2_ang = 53;
dome_layer_3_ang = 38;
dome_layer_4_ang = 24;

$fn=45;
difference() {
    union() {
        /*
        linear_extrude(height, convexity=4) difference() {
            circle(d=outer_size);
            circle(d=outer_size-thickness);
        }
        */
        difference() {
            cylinder(d1=outer_size_base, d2=outer_size_tip, h=height);
            translate([0, 0, -0.01])
              cylinder(d1=inner_size_base, d2=inner_size_tip, h=height+0.02);
        };
        translate([0, 0, height]) difference() {
            sphere(d=outer_size_tip);
            sphere(d=inner_size_tip);
            translate([0, 0, -outer_tip_rad/2])
              cube([outer_size_tip, outer_size_tip, outer_tip_rad], center=true);
        };
    }
    // The holes along the length
    union() {
        // no offset row
        linear_distribute(0, layer_step*2, height, tvec=[0, 0, 1])
        rotate_distribute(holes_per_layer)
          translate([hole_start, 0, 0]) rotate([0, 90, 0])
          cylinder(d=hole_size, h=hole_len, $fn=8);
        // alternate offset row
        linear_distribute(0, layer_step*2, height, tvec=[0, 0, 1])
        rotate([0, 0, alt_layer_rot_offset])
        rotate_distribute(holes_per_layer)
          translate([hole_start, 0, layer_step]) rotate([0, 90, 0])
          cylinder(d=hole_size, h=hole_len, $fn=8);
    }
    // The holes around the spherical tip
    translate([0, 0, 50]) union() {
        rotate_distribute(holes_per_layer/90*dome_layer_1_ang)
          rotate([0, dome_layer_1_ang, 0]) translate([0, 0, hole_start])
          cylinder(d=hole_size, h=hole_len, $fn=8);
        rotate_distribute(holes_per_layer/90*dome_layer_2_ang)
          rotate([0, dome_layer_2_ang, 0]) translate([0, 0, hole_start])
          cylinder(d=hole_size, h=hole_len, $fn=8);
        rotate_distribute(holes_per_layer/90*dome_layer_3_ang)
          rotate([0, dome_layer_3_ang, 0]) translate([0, 0, hole_start])
          cylinder(d=hole_size, h=hole_len, $fn=8);
        rotate_distribute(holes_per_layer/90*dome_layer_4_ang)
          rotate([0, dome_layer_4_ang, 0]) translate([0, 0, hole_start])
          cylinder(d=hole_size, h=hole_len, $fn=8);
    }
    // The split to allow the sides to be pulled together
    hull() {
        rotate([90, 0, 0])
          cylinder(d=split_dia, h=max_width, center=true);
        translate([0, 0, height]) rotate([90, 0, 0])
          cylinder(d=split_dia, h=max_width, center=true);
    }
}

