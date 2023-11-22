use <gears.scad>;

$fn = 50;

module centre_roller(roller_diam, shaft_diam, key_x, key_y, axis_off, height) {
    difference() {
        // The actual roller
        translate([0, axis_off, 0]) cylinder(d=roller_diam, h=height);
        // The centre bearing
        translate([0, 0, -0.01]) cylinder(d=shaft_diam, h=height+0.02);
        // The key
        translate([-key_x/2, shaft_diam/2, -0.01]) cube([key_x, key_y, height+0.02]);
    }
}

module end_block(roller_diam, shaft_diam, height) { difference() {
    cube([end_block_length, end_block_width, 10]);
    translate([0, end_block_width/2, -0.01]) union() {
        translate([
            (end_block_length-roller_diam-separation/2)/2, 0, 0
        ]) cylinder(d=shaft_diam, h=height+0.02);
        translate([
            (end_block_length+roller_diam+separation/2)/2, 0, 0
        ]) cylinder(d=shaft_diam, h=height+0.02);
    }
}}

roller_diam = 30;
shaft_diam = 14.5;
key_x = 10.3;
key_y = 3.3;
axis_off = 5;
height = 10;

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
    rotate([0, 0, key_rotate]) translate([-key_x/2, shaft_diam/2, -0.01])
      cube([key_x, key_y, height+0.02]);
}};

* translate([15, 0, 0]) this_gear(30, 1.5);
* translate([15*2+45+4, 0, 0]) difference() {
    this_gear(90, 1.5, 18);
    translate([30, 0, -0.01]) cylinder(d=shaft_diam, h=height+0.02);
}

difference() {
    centre_roller(120, shaft_diam, key_x, key_y, 0, height);
    translate([45, 0, -0.01]) cylinder(d=shaft_diam, h=height+0.02);
}
// translate([(roller_diam+separation/2)*1, 0, height*1]) // layout check
* translate([(roller_diam+8)*1, (end_block_width)*1, 0]) // print pattern
  this_gear(roller_diam, 1.5);
//  difference() {
//    herringbone_gear(
//        tooth_height, teeth, height, shaft_diam, 
//        pressure_angle=20, helix_angle=40, optimized=false
//    );
//    // The key
//    translate([-key_x/2, shaft_diam/2, -0.01]) cube([key_x, key_y, height+0.02]);
//};    
// translate([(roller_diam+separation/2)*0, 0, height*1]) // layout check
* translate([(roller_diam+8)*0, (end_block_width)*1, 0]) // print pattern
  difference() {
    herringbone_gear(
        tooth_height, teeth, height, shaft_diam, 
        pressure_angle=20, helix_angle=-40, optimized=false
    );
    // The key
    translate([-key_x/2, shaft_diam/2, -0.01]) cube([key_x, key_y, height+0.02]);
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

