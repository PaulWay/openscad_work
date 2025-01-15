module key_1(size, thick) union() {
    s2 = size;  s1 = size/2; 
    translate([0, 0, 0]) cube([thick, s2, thick]);    
    translate([0, s2-thick, 0]) cube([s1, thick, thick]);

    translate([s1, 0, 0]) cube([thick, s2, thick]);
    
    translate([s1, 0, 0]) cube([s1, thick, thick]);
}

translate([0, 0, 0]) key_1(10, 2);
translate([10, 0, 0]) key_1(10, 2);

module key_2(size, thick, height=undef) union() {
    hgt = (height == undef) ? thick : height;
    s0 = 0; s1 = size*1/3;  s2 = size*2/3;  s25 = (size-thick)/2;  s3 = size;
    translate([s0, s0, 0]) cube([thick, s3, hgt]);    
    translate([s0, s3-thick, 0]) cube([s2, thick, hgt]);

    translate([s2, s25, 0]) cube([thick, s25+thick, hgt]);
    translate([s1, s25, 0]) cube([s1, thick, hgt]);
    translate([s1, s0, 0]) cube([thick, s25, hgt]);

    translate([s1, s0, 0]) cube([s2, thick, hgt]);
}

translate([20, 0, 0]) key_2(10, 1, 2);
translate([30, 0, 0]) key_2(10, 2);

module key_3(size, thick, height=undef) union() {
    hgt = (height == undef) ? thick : height;
    s0 = 0; s1 = size*1/4;  s2 = size*2/4;
    s25 = (size-thick)/2;  s3 = size*3/4;  s4 = size;
    translate([s0, s0, 0]) cube([thick, s4, hgt]);    
    translate([s0, s4-thick, 0]) cube([s4, thick, hgt]);

    translate([s4-thick, s1, 0]) cube([thick, s3, hgt]);

    //translate(
    //translate([s1, s25, 0]) cube([s1, thick, hgt]);

    translate([s1, s0, 0]) cube([thick, s3, hgt]);

    translate([s1, s0, 0]) cube([s3, thick, hgt]);
}

module opposed_key_parts(level, left, right, thick, space) {
    // just the two opposite parts of a key.
    translate([left, s0, 0]) cube([thick, s4, hgt]);    
}

translate([40, 0, 0]) key_3(10, 1, 2);