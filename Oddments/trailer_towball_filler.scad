// include <../libs/pw_primitives.scad>;

$fn=50; 

union() {
    translate([0, 0, 50]) intersection() {
        sphere(d=50);
        cube([50, 50, 42], center=true);
    };
    cylinder(h=30, d=30);
    translate([0, 0, 10]) cylinder(h=10, d1=50, d2=30);
    cylinder(h=10, d=50);
};