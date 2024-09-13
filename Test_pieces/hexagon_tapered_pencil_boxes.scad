use <../libs/pw_primitives.scad>;

* intersection() {
    union() {
        translate([60, 0, -2]) rotate([0, 5, 0]) difference() {
            tapered_hexagon(40, 50, 100-2);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
        translate([0, -35, -2]) rotate([3, 0, 0]) difference() {
            tapered_hexagon(40, 50, 100);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
        translate([0, 35, -2]) rotate([-3, 0, 0]) difference() {
            tapered_hexagon(40, 50, 100);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
        translate([-60, 0, -2]) rotate([0, -5, 0]) difference() {
            tapered_hexagon(40, 50, 100-2);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
    }
    translate([0, 0, 50]) cube([240, 170, 100], center=true);
}

intersection() {
    union() {
        translate([60, 0, -2]) rotate([0, 5, 0]) difference() {
            tapered_hexagon(40, 50, 100-2);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
        translate([0, -35, -2]) rotate([3, 0, 0]) difference() {
            tapered_hexagon(40, 50, 100);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
        translate([0, 35, -2]) rotate([-3, 0, 0]) difference() {
            tapered_hexagon(40, 50, 100);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
        translate([-60, 0, -2]) rotate([0, -5, 0]) difference() {
            tapered_hexagon(40, 50, 100-2);
            translate([0, 0, 5]) tapered_hexagon(40-6, 50-6, 100);
        }
    }
    translate([0, 0, 50]) cube([240, 170, 100], center=true);
}