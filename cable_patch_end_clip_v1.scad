
module latch(
  length, width, height, latch_width, latch_height, slot_width, 
  support_length, back_height
) {
    // this is on its side, so the width goes into +X,
    // height goes into +Y, and length goes into +Z
    support_height=back_height-length;
    cube([width, height, length]);
    cube([width*2, height-(latch_height+slot_width), length]);
    translate([0, height-latch_height, 0]) difference() {
        cube([width+latch_width, latch_height, length]);
        translate([width+latch_width, 0, -0.01])
         rotate([0, 0, atan2(latch_width, latch_height)]) 
         cube([latch_width, sqrt(pow(latch_width,2) + pow(latch_height,2)), length+0.02]);
    };
    translate([width, width, length]) rotate([0, -90, 0]) difference() {
          linear_extrude(height=width, center=false, convexity=1, twist=0)
          polygon(points=[[0, 0], [0, support_length], [support_height, 0]]);
        // countersunk screw holes
        translate([7, 6, -0.01]) rotate([0, 0, 0])
          cylinder(h=3+0.02, d1=5+(3*2), d2=5);
    }
}

latch(11.5, 3, 48, 2.3, 7, 2, 30, 30);
translate([57, 0, 0]) mirror([1, 0, 0]) latch(11.5, 3, 48, 2.3, 7, 2, 30, 30);
difference() {
    cube([57, 3, 30]);
    // cutout for cables
    translate([57/2, -0.01, 0]) rotate([-90, 0, 0]) 
      cylinder(h=3+0.02, r=20);
    // countersunk screw holes
    translate([57-10, -0.01, 20]) rotate([-90, 0, 0])
      cylinder(h=3+0.02, d1=5, d2=5+(3*2));
    translate([+10, -0.01, 20]) rotate([-90, 0, 0])
      cylinder(h=3+0.02, d1=5, d2=5+(3*2));
}