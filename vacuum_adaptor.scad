$fn = 100;

module pipe(height, radius, thickness)
    difference() {
        cylinder(height, radius, radius);
        translate([0, 0, -0.05]) cylinder(height+0.1, radius - thickness, radius - thickness);
    }

module tapered_pipe(height, bottom_radius, top_radius, thickness)
    difference() {
        cylinder(height, bottom_radius, top_radius);
        translate([0, 0, -0.05]) 
          cylinder(height+0.1, bottom_radius - thickness, top_radius - thickness);
    }

module adapter(end_height, taper_height, bigger_radius, smaller_radius, wall_thickness)
    union() {
        pipe(end_height, bigger_radius, wall_thickness);
        translate([0, 0, end_height]) 
            tapered_pipe(taper_height, bigger_radius, smaller_radius, wall_thickness);
        translate([0, 0, end_height + taper_height])
            pipe(end_height, smaller_radius, wall_thickness);
    }

adapter(25, 40, 50, 25, 3);

//rotate_extrude() {
//    translate([2, 0, 0])
//    difference() {
//        circle(r=1);
//        circle(r=0.8);
//    };
//};