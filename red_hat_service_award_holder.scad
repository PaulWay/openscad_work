$fn=45;

difference() {
    // the main block
    cube([80, 23+2*3, 24]);
    // main space for award
    translate([80/2, 3, 103/2+5]) rotate([-90, 0, 0]) cylinder(h=23, d=103);
    // surround
    translate([80/2, -0.01, 103/2+7]) rotate([-90, 0, 0]) cylinder(h=23+3.01*2, d=103-4);
}