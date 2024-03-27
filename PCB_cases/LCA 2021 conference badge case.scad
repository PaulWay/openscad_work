full_length=120;
full_width=80;
height=5;
thickness=3;
inner_radius=4;
outer_radius=6;

module rounded_box(length, width, height, radius) {
    r2 = radius*2;
    translate([radius, radius, 0]) minkowski($fn=32) {
        cube([length-r2, width-r2, height]);
        cylinder(h=height, r=radius);
    };
}

difference() {
    t2=thickness*2;
    rounded_box(full_length+t2, full_width+t2, height+thickness, outer_radius);
    # translate([thickness, thickness, thickness])
      rounded_box(full_length, full_width, height+2.0, inner_radius);
}