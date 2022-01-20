length = 76;
width = 53;
front_height = 10;
back_height = 25;
walls = 3;

full_length = length+walls*2;
full_width = width+walls*2;
height_diff = back_height-front_height;
angle = atan2(height_diff, full_width);
diag_width = sqrt(full_width*full_width + height_diff*height_diff);
overhang = front_height*sin(angle);

intersection() {
    // the main hollow box, tilted so the front is lower than the back.
    translate([0, diag_width+overhang, 0]) rotate([angle, 0, 0])
    translate([0, -full_width, 0]) difference() {
        cube([full_length, full_width, back_height]);
        translate([walls, walls, -0.01]) cube([length, width, back_height+0.02]);
    }
    // the bit above the Z plane...
    cube([full_length, diag_width+overhang, back_height]);
};