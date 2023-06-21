$fn = 50;

module centre_roller(roller_diam, bearing_diam, key_x, key_y, axis_off, height) {
    difference() {
        // The actual roller
        translate([0, axis_off, 0]) cylinder(d=roller_diam, h=height);
        // The centre bearing
        translate([0, 0, -0.01]) cylinder(d=bearing_diam, h=height+0.02);
        // The key
        translate([-key_x/2, bearing_diam/2, -0.01]) cube([key_x, key_y, height+0.02]);
    }
}

roller_diam = 30;
bearing_diam = 14.5;
key_x = 10.3;
key_y = 3.3;
axis_off = 5;
height = 10;

centre_roller(roller_diam, bearing_diam, key_x, key_y, 0, height);
translate([roller_diam+2, -axis_off, 0])
  centre_roller(roller_diam, bearing_diam, key_x, key_y, axis_off, height);