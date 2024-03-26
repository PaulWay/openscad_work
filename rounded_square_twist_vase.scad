include <pw_primitives.scad>;

module twist_vase(base_height, vase_height, corner_rad, twist) union() {
    translate([0, 0, base_height]) 
      linear_extrude(height = vase_height, twist = twist, slices = vase_height) {
        difference() {
            offset(r = corner_rad) children();
            offset(r = corner_rad - vase_thick) children();
        }
    }
    base_angle=(base_height*twist)/vase_height;
    rotate([0, 0, base_angle]) 
      linear_extrude(height=base_height, twist=base_angle, slices=base_height) { 
        offset(r=corner_rad) children();
    }
}

base_height = 5;
vase_height = 100;
vase_width = 50;  vase_thick = 4;  vase_outer_r = 15;
twist = 45;


// rounded square
* twist_vase(base_height, vase_height, vase_outer_r, twist)
  square(vase_width, center=true);

twist_vase(base_height, vase_height, 10, -120)
  hexagon(40);