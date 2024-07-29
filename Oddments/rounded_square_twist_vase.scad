include <../libs/pw_primitives.scad>;
include <../libs/pw_funcs.scad>;

module twist_vase(
    base_height, vase_height, corner_rad, twist, wall_thick=4
) union() {
    translate([0, 0, base_height]) 
      linear_extrude(height = vase_height, twist = twist, slices = vase_height) {
        difference() {
            offset(r = corner_rad) children();
            offset(r = corner_rad - wall_thick) children();
        }
    }
    base_angle=(base_height*twist)/vase_height;
    rotate([0, 0, base_angle]) 
      linear_extrude(height=base_height, twist=base_angle, slices=base_height) { 
        offset(r=corner_rad) children();
    }
}

$fa = 2;
base_height = 5;
vase_height = 100;
vase_width = 50;  vase_outer_r = 15;
twist = 45;


// rounded square
* twist_vase(base_height, vase_height, vase_outer_r, twist)
  square(vase_width, center=true);

* twist_vase(base_height, vase_height, 10, -120)
  hexagon(40);

// very rounded rectangle
* twist_vase(base_height, 120, 40, -90, 2)
  square([10, 50], center=true);

// fairly rounded triangle
twist_vase(4, 110, 10, 120, wall_thick=3)
  translate([-25, -(25*cos(60)), 0]) equ_triangle(50);
