use <../libs/gears.scad>;

$fn = 50;
eps = 0.01; ep2 = 0.02;

module centre_roller(roller_diam, shaft_diam, key_x, key_y, axis_off, height) {
    difference() {
        // The actual roller
        translate([0, axis_off, 0]) cylinder(d=roller_diam, h=height);
        // The centre bearing
        translate([0, 0, -eps]) cylinder(d=shaft_diam, h=height+ep2);
        // The key
        translate([-key_x/2, shaft_diam/2, -eps]) cube([key_x, key_y, height+ep2]);
    }
}

module cutter_roller_v1(roller_diam, shaft_diam, key_x, key_y, axis_off, height, angle) {
    min_diam = shaft_diam + axis_off * 2 + 0.4;  // 0.4 = one print width
    h2 = height / 2;
    angle_diam = roller_diam - h2 / tan(angle);
    // taper_point = max(roller_diam - height / 1.8, );
    difference() {
        // The actual roller
        translate([0, axis_off, 0]) union() {
            translate([0, 0, 0]) cylinder(d1=roller_diam, d2=angle_diam, h=h2);
            translate([0, 0, h2]) cylinder(d1=angle_diam, d2=roller_diam, h=h2);
            // fudge the calculation of the height that the min-diameter cylinder
            // intersects the angled sides - just put an extra full-height cylinder in.
            if (min_diam > angle_diam) {
                cylinder(d=min_diam, h=height);
            }
        }
        // The centre bearing
        translate([0, 0, -eps]) cylinder(d=shaft_diam, h=height+ep2);
        // The key
        translate([-key_x/2, shaft_diam/2, -eps]) cube([key_x, key_y, height+ep2]);
    }
}

module cutter_roller_v2(
    roller_diam, shaft_diam, key_x, key_y, height, 
    blade_angle=45, cutter_angle=180
) {
    min_rad = sqrt(key_x*key_x + key_y*key_y)+1;
    cutter_outer_rad = roller_diam - min_rad - 2;  // conversion from diameter to radius
    h2 = height / 2;
    cutter_inner_rad = cutter_outer_rad - h2 / tan(blade_angle);
    difference() {
        // The center roller and the cutter part
        union() {
            cylinder(h=height, r=min_rad);
            rotate_extrude(angle=cutter_angle, convexity=2) polygon([
                [0, 0], [cutter_outer_rad, 0],
                [cutter_inner_rad, h2], [cutter_outer_rad, height],
                [0, height]
            ]);
        }
        // The centre bearing
        translate([0, 0, -eps]) cylinder(d=shaft_diam, h=height+ep2);
        // The key
        translate([-key_x/2, shaft_diam/2, -eps]) cube([key_x, key_y, height+ep2]);
    }
}

module end_block(roller_diam, shaft_diam, height) { difference() {
    cube([end_block_length, end_block_width, 10]);
    translate([0, end_block_width/2, -eps]) union() {
        translate([
            (end_block_length-roller_diam-separation/2)/2, 0, 0
        ]) cylinder(d=shaft_diam, h=height+ep2);
        translate([
            (end_block_length+roller_diam+separation/2)/2, 0, 0
        ]) cylinder(d=shaft_diam, h=height+ep2);
    }
}}

roller_diam = 30;
shaft_diam = 14.5;
key_x = 10.3;
key_y = 3.3;
axis_off = 5;
height = 10;

rotate([0, 0, -$t*360]) cutter_roller_v2(roller_diam, shaft_diam, key_x, key_y, height);
translate([0, 40, 0]) rotate([0, 0, $t*360]) cutter_roller_v2(roller_diam, shaft_diam, key_x, key_y, height);

// bearing diameter = corner point of key
x = key_x/2;
y = key_y+(shaft_diam/2);
bearing_diam = sqrt(x*x + y*y)*2 + 1;
//bearing_diam = 25;

end_block_length = 100;
end_block_width = 60;
separation = 3;

teeth = 20;
tooth_height = roller_diam / teeth + 0.1;  // 30/20=1.5
bore = 10;

module this_gear(max_diam, tooth_height, key_rotate=0) {difference() {
    teeth = floor(max_diam / tooth_height);
    herringbone_gear(
        tooth_height, teeth, height, shaft_diam, 
        pressure_angle=20, helix_angle=40, optimized=false
    );
    // The key
    rotate([0, 0, key_rotate]) translate([-key_x/2, shaft_diam/2, -eps])
      cube([key_x, key_y, height+ep2]);
}};

* translate([15, 0, 0]) this_gear(30, 1.5);
* translate([15*2+45+4, 0, 0]) difference() {
    this_gear(90, 1.5, 18);
    translate([30, 0, -eps]) cylinder(d=shaft_diam, h=height+ep2);
}

// the big handle gear
* difference() {
    centre_roller(120, shaft_diam, key_x, key_y, 0, height);
    translate([45, 0, -eps]) cylinder(d=shaft_diam, h=height+ep2);
}
// translate([(roller_diam+separation/2)*1, 0, height*1]) // layout check
* translate([(roller_diam+8)*1, (end_block_width)*1, 0]) // print pattern
  this_gear(roller_diam, 1.5);
// translate([(roller_diam+separation/2)*0, 0, height*1]) // layout check
* translate([(roller_diam+8)*0, (end_block_width)*1, 0]) // print pattern
  difference() {
    herringbone_gear(
        tooth_height, teeth, height, shaft_diam, 
        pressure_angle=20, helix_angle=-40, optimized=false
    );
    // The key
    translate([-key_x/2, shaft_diam/2, -eps]) cube([key_x, key_y, height+ep2]);
};    

// the centred rollers
// translate([(roller_diam+separation/2)*1, 0, height*2]) // layout check
* translate([(roller_diam+5)*1, (roller_diam+5)*1, 0]) // print pattern
  centre_roller(roller_diam, shaft_diam, key_x, key_y, 0, height);
// translate([(roller_diam+separation/2)*0, 0, height*2]) // layout check 
* translate([(roller_diam+5)*1, (roller_diam+5)*1, 0]) // print pattern
  centre_roller(roller_diam, shaft_diam, key_x, key_y, 0, height);
// the off-centre rollers
// translate([(roller_diam+separation/2)*1, 0, height*3]) // layout check
* translate([(roller_diam+5)*1, (roller_diam+5)*1, 0]) // print pattern
  centre_roller(roller_diam, shaft_diam, key_x, key_y, axis_off, height);
// translate([(roller_diam+separation/2)*0, 0, height*3]) // layout check
* translate([(roller_diam+5)*1, (roller_diam+5)*1, 0]) // print pattern
  centre_roller(roller_diam, shaft_diam, key_x, key_y, axis_off, height);
// the bearings
// translate([(roller_diam+separation/2)*0, (roller_diam+5)*0, 0]) // layout check
* translate([(roller_diam+8)*1, (roller_diam+5)*1, 0]) // print pattern
  centre_roller(bearing_diam, shaft_diam, key_x, key_y, 0, height);
// translate([(roller_diam+separation/2)*1, (roller_diam+5)*0, 0]) // layout check
* translate([(roller_diam+8)*1, (roller_diam+5)*1, 0]) // print pattern
  centre_roller(bearing_diam, shaft_diam, key_x, key_y, 0, height);

// end block - layout check
* translate([-((end_block_length-roller_diam-separation/2)/2), -end_block_width/2, 0])
  end_block(roller_diam, bearing_diam+0.2, height);

