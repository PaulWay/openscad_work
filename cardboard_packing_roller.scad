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
            (end_block_length-roller_diam-separation)/2, 0, 0
        ]) cylinder(d=shaft_diam, h=height+0.02);
        translate([
            (end_block_length+roller_diam+separation)/2, 0, 0
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

// translate([(end_block_length-roller_diam-separation)/2, end_block_width/2, 0])
translate([(roller_diam+5)*1, 0, 0]) 
  centre_roller(roller_diam, shaft_diam, key_x, key_y, axis_off, height);
// translate([(end_block_length+roller_diam+separation)/2, end_block_width/2, 0])
translate([(roller_diam+5)*0, 0, 0]) 
  centre_roller(roller_diam, shaft_diam, key_x, key_y, 0, height);
// translate([(end_block_length+roller_diam+separation)/2, end_block_width/2, height])
*   centre_roller(bearing_diam, shaft_diam, key_x, key_y, 0, height);

* translate([-bearing_diam/2, (roller_diam/2+10)*1, 0])
  end_block(roller_diam, bearing_diam, height);