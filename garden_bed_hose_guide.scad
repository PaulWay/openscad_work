include <pw_primitives.scad>;

outer_r = 120;
inner_r = 50;
wall_thick = 5;
join_height = 10;
join_thick = 3;

difference() {
    // the main cylinder, plus the joining tang
    union() {
        cylinder(h=inner_r, r=(outer_r-inner_r));
        cylinder_segment(inner_r+join_height, inner_r/2+join_thick, 175);
    }
    // minus the torus around the outside
    translate([0, 0, inner_r]) torus(outer_r, inner_r-wall_thick);
    // and the inner hole
    translate([0, 0, -0.01]) cylinder(h=inner_r+join_height+0.02, d=inner_r);
    // and the mortise for the joining tang
    translate([0, 0, inner_r-join_height]) rotate([0, 0, 175]) 
        cylinder_segment(join_height, inner_r/2+join_thick, 185);
    // and the slot to let it fit onto the side of the tank
}