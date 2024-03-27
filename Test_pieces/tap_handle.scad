$fn = 60;

module one_handle(length, width, hub_width=0, centre_width=0, centre_pos = 0, end_squish=1) {
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

module rotate_distribute(number) {
    for(i = [0 : number]) {
        rotate([0, 0, 360*i/number]) children();
    }
}

module torus(outer_dia, inner_dia, x_stretch=1, angle=360) {
    rotate_extrude(angle=angle, convexity=2) 
        translate([outer_dia, 0, 0]) scale([x_stretch, 1, 1]) circle(inner_dia/2);
    
}

n = 5;
union() {
    beta = (180 - (360/n))/2;
    outer_dist = 2*20*sin(180/n);
    translate([0, 0, 15]) group() {
        sphere(d=6);
        torus(outer_dist-2.5, 10, x_stretch=0.5);
        rotate_distribute(5) union() {
            one_handle(20, 10, hub_width=5, centre_pos=-0.5, end_squish=1.5);
            * translate([20, 0, 0]) rotate([0, 0, beta]) translate([-outer_dist, 0, 0])
              rotate([0, 90, 0]) cylinder(h=outer_dist, d=5);
        }
    }
    cylinder(h=15, d=6);
}