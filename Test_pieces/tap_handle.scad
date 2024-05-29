include <../libs/pw_primitives.scad>;

$fn = 60;

module one_handle(length, width, hub_width=0, centre_width=0, centre_pos=0, end_squish=1) {
    // A single handle piece, with two cones and an end sphere.  The
    // end sphere is 'width' diameter, so the actual length is 
    // (length + width/2).  Add more end_squish to make the end sphere
    // more like a button.  If centre_width is zero, it is set to
    // width/2.  centre_pos can vary from -1 (right at the hub) to +1
    // (right at the end).
    centre_width = (centre_width == 0) ? width/2 : centre_width;
    hub_width = (hub_width == 0) ? width : hub_width;
    inner_len = length*(centre_pos+1)/2;
    outer_len = length - inner_len - 0.1;
    union() {
        translate([length, 0, 0]) scale([1/end_squish, 1, 1]) sphere(d=width);
        translate([inner_len, 0, 0]) rotate([0, 90, 0]) 
          cylinder(h=outer_len, d1=centre_width, d2=width);
        translate([0, 0, 0]) rotate([0, 90, 0]) 
          cylinder(h=inner_len, d1=hub_width, d2=centre_width);
    }
}

n = 5;
translate([0, 0, 34]) union() {
    beta = (180 - (360/n))/2;
    outer_dist = 2*25*sin(180/n);
    translate([0, 0, 15]) group() {
        sphere(d=8);
        torus(outer_dist+6, 10/2, x_stretch=0.5);
        rotate_distribute(n) union() {
            one_handle(outer_dist, 10, hub_width=8, centre_pos=-0.5, end_squish=1.5);
            * translate([20, 0, 0]) rotate([0, 0, beta]) translate([-outer_dist, 0, 0])
              rotate([0, 90, 0]) cylinder(h=outer_dist, d=5);
        }
    }
    cylinder(h=15, d=10);
}
rotate([90, 0, 0]) difference() {
    union() {
        sphere(d=70);
        cylinder(d=60, h=100, center=true);
    }
    translate([0, 0, -0.01]) cylinder(d=56, h=100.03, center=true);
}