include <pw_primitives.scad>;

// lid is upside-down so we can print the 'top' first rather than use support.

$fn=90;

union() {
    // lid
    cylinder(d=70, h=4);
    // sides - measured from the top of the lid, rather than the bottom.
    // height, radius, thickness
    ring_rt(24, 57/2, 4);
}