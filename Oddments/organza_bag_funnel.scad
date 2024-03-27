include <pw_primitives.scad>;

$fn=60;
intersection() {
    hollow_cone_rt(100, 30, 60, 2);
    rotate([0, 30, 0]) translate([-110, -75, -25])
        cube([150, 150, 90]);
}