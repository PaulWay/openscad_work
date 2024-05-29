include <../libs/pw_primitives.scad>;

$fn = 180;

sliv_height = 12;
sliv_width = 40;
angle = atan2(sliv_width, sliv_height);
// angle= 70;
sliv_radius = 100;
outer_rad = 497/2;
inner_rad = 150/2;

hole_dia = 2.8;
hole_dep = 5;

function sqr(x) = pow(x, 2);

module sliver(angle, radius, height, width) {
    c_height = width / sin(angle);
    y_dist = sqrt(sqr(radius) - sqr(sliv_radius-height));
    intersection() {
        translate([0, 0, height]) mirror([1, 0, 0]) rotate([0, angle, 0]) 
          translate([radius, 0, -c_height]) cylinder(h=c_height, r=radius);
        translate([0, -y_dist, 0]) cube([width, 2*y_dist, height]);
    }
}

inner_x_off = 14;
inner_y_off = sqrt(sqr(inner_rad) - sqr(inner_rad-inner_x_off));
sliv_inner_angle = acos((inner_rad-inner_x_off)/inner_rad);
echo("sliv inner angle:", sliv_inner_angle);
h_holes_z = 1.5 + hole_dia/2;

// inner sliver
* difference() {
    sliver(angle, sliv_radius, sliv_height, sliv_width);
    // inner curve
    translate([inner_x_off-inner_rad, 0, -0.01]) cylinder(h=sliv_height, r=inner_rad);
    // horizontal bolt holes
    translate([-inner_rad, 0, h_holes_z]) rotate([0, 0, sliv_inner_angle/4]) 
      translate([inner_rad+inner_x_off-0.8, 0, 0]) rotate([0, 90, 0]) 
      cylinder(h=hole_dep, d=hole_dia);
    translate([-inner_rad, 0, h_holes_z]) rotate([0, 0, -sliv_inner_angle/4]) 
      translate([inner_rad+inner_x_off-0.8, 0, 0]) rotate([0, 90, 0]) 
      cylinder(h=hole_dep, d=hole_dia);
    // vertical bolt holes
    # translate([inner_x_off+5, 10, -0.01]) cylinder(h=hole_dep, d=hole_dia);
    # translate([inner_x_off+5, -10, -0.01]) cylinder(h=hole_dep, d=hole_dia);
}

outer_x_off = 0;
outer_h_angle = 5;

// outer sliver
* difference() {
    intersection() {
        sliver(angle, sliv_radius, sliv_height/4*3, sliv_width);
        translate([outer_rad, 0, 0]) cylinder(h=sliv_height, r=outer_rad);
    }
    // horizontal bolt holes
    translate([outer_rad, 0, h_holes_z]) rotate([0, 0, outer_h_angle])
      translate([0.01-outer_rad, 0, 0]) rotate([0, 90, 0])
      cylinder(h=hole_dep, d=hole_dia);
    translate([outer_rad, 0, h_holes_z]) rotate([0, 0, -outer_h_angle])
      translate([0.01-outer_rad, 0, 0]) rotate([0, 90, 0])
      cylinder(h=hole_dep, d=hole_dia);
    // vertical bolt holes
    translate([outer_x_off+5, 10, -0.01]) cylinder(h=hole_dep, d=hole_dia);
    translate([outer_x_off+5, -10, -0.01]) cylinder(h=hole_dep, d=hole_dia);
}

toroid_sliver_w = sliv_height / 1.8;
h_toroid_sliver_w = toroid_sliver_w / 2;
toroid_angle = 10;

translate([-inner_rad, 0, 0]) difference() {
    quarter_torus_bend_snub_end(inner_rad, toroid_sliver_w, toroid_angle, true);
    // horizontal bolt holes
    translate([0, 0, h_toroid_sliver_w]) rotate([0, 0, toroid_angle-2])
      translate([inner_rad-epsilon*3, 0, 0]) rotate([0, 90, 0])
      cylinder(h=hole_dep, d=hole_dia);
    translate([0, 0, h_toroid_sliver_w]) rotate([0, 0, +2])
      translate([inner_rad-epsilon*3, 0, 0]) rotate([0, 90, 0])
      cylinder(h=hole_dep, d=hole_dia);
    // vertical bolt holes
    translate([inner_rad+h_toroid_sliver_w, 0, -0.01])
      cylinder(h=hole_dep, d=hole_dia);
    rotate([0, 0, 10]) translate([inner_rad+h_toroid_sliver_w, 0, -epsilon])
      cylinder(h=hole_dep, d=hole_dia);
}