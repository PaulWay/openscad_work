length = 11.3;
width = 3;
height = 48;
latch_width = 2.3;
latch_height = 7;
slot_width = 2;
support_length = 30;
back_height = 30;
end_width = 57;
screw_shaft = 3;

$fn=50;

module countersunk_head(shaft_width, height) {
    union() {
        if (height>shaft_width) translate([0, 0, -0.01])
          cylinder(h=(height+0.02-shaft_width), d=shaft_width);
        translate([0, 0, (height-shaft_width)]) 
          cylinder(h=screw_shaft+0.02, d1=shaft_width, d2=shaft_width*2);
    }
}

module latch(
  length, width, height, latch_width, latch_height, slot_width, 
  support_length, back_height
) {
    // this is on its side, so the width goes into +X,
    // height goes into +Y, and length goes into +Z
    support_height=back_height-length;
    difference() {
        union () {
            // the length of the latch
            cube([width, height, length]);
            // the support that attaches to the bridge between the two latches
            cube([width*2, height-(latch_height+slot_width), back_height]);
        };
        // countersunk screw holes
        translate([0, 8, 8]) rotate([0, 90, 0])
          countersunk_head(screw_shaft, width*2);
        translate([0, 8, back_height-8]) rotate([0, 90, 0])
          countersunk_head(screw_shaft, width*2);
    };
    // the angled latch
    translate([0, height-latch_height, 0]) difference() {
        cube([width+latch_width, latch_height, length]);
        translate([width+latch_width, 0, -0.01])
         rotate([0, 0, atan2(latch_width, latch_height)]) 
         cube([latch_width, sqrt(pow(latch_width,2) + pow(latch_height,2)), length+0.02]);
    };
}


translate([0, 0, back_height]) mirror([0, 0, 1]) union() {
    latch(length, width, height, latch_width, latch_height, slot_width, 
      support_length, back_height);
    translate([end_width, 0, 0]) mirror([1, 0, 0]) latch(
      length, width, height, latch_width, latch_height, slot_width, 
      support_length, back_height);
    translate([0, 0, back_height-width])
      cube([end_width, (height-(latch_height+slot_width)), width]);
};