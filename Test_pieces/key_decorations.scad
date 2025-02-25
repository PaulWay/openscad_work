module line_from_to(from, to, thick, height) {
    assert (to.z == from.z, "from and to must be at the same Z height");
    diff = to - from;
    angle = atan2(diff.y, diff.x);
    length = sqrt(diff.x*diff.x + diff.y*diff.y);
    translate(from) rotate([0, 0, angle]) cube([length, thick, height])
}

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

translate([40, 0, 0]) key_3(10, 1, 2);

module opposed_key_parts(level, levels) {
    /*
    The two 'opposed' sides of a key are actually the part starting at the
    bottom left and going to the top left, and the part starting from the
    bottom right and going 'back' into the key to end one 'width' away from
    the start of the key.  I.e. the second part is from the 'next' key, and
    joins this and the next key together.
    The space is divided into [levels x levels].  Each square that the key
    passes through half fills that square in.
    */
    if (level < levels) union() {
        line_from_to([, 0, 0], [0, levels, 0], 1, 1);
        line_from_to([levels, -1, 0], [1, 1, 0], 1, 1);
        rotate([0, 0, -90]) opposed_key_parts(level+1, levels);
    }
}
/*
space = 0..7 x 0..7 - lines on even numbers only except last line

bounds 8, 6, 0 - line 0, 0 - 0, 6 ->
  line 6, 0 - 6, 6 ->
    line 6, 6 - 6, 2 ->
      line 6, 2 - *4, 2* ->
      line *4, 2* - 4, 4
    <- line 4, 4 - 2, 4
  <- line 2, 4 - 2, 0
bounds 8, 6, 0 - <- line 2, 0 - 7, 0

*/
