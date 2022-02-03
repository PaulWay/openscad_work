include <pw_primitives.scad>;

outer_r = 120;
inner_r = 50;
wall_thick = 5;
join_height = 10;
join_thick = 3;
slot_width = 10;

// This allows a garden hose, pumpkin vine, or other tube to go over the edge
// of a raised garden bed, wall, or similar vertical surface with a thin
// edge that may otherwise bend, kink or break the hose.
// To print without supports it is made as a half piece that can be printed
// twice and snapped together.  A central set of tangs fit into mortises to
// provide structure and strength so that the piece holds together.  In order
// to do this, the tangs and mortises must be rotationally symmetrical - i.e.
// so that when the piece is rotated around the Y axis, the left hand (-X)
// tangs fit into the right hand (+X) mortises and vice versa.  That means
// that a tang / mortise join needs to be directly opposite the slot for the
// bed wall.  In addition, these joins must prevent the piece from
// twisting around the Z axis such that the guide clamps on the bed edge.  To
// do _that_, we need to have two tang / mortise joins somewhere else
// symmetrical - I've chosen 90 / 270 degrees.  The tangs are 1 degree thinner
// than the mortises to allow for print inaccuracy.

difference() {
    // the main cylinder, plus the joining tangs
    union() {
        cylinder(h=inner_r, r=(outer_r-inner_r));
        rotate([0, 0, 90])
            cylinder_segment(inner_r+join_height, inner_r/2+join_thick, 89);
        rotate([0, 0, 270])
            cylinder_segment(inner_r+join_height, inner_r/2+join_thick, 90);
    }
    // minus the torus around the outside
    translate([0, 0, inner_r]) torus(outer_r, inner_r-wall_thick);
    // and the inner hole
    translate([0, 0, -0.01]) cylinder(h=inner_r+join_height+0.02, d=inner_r);
    // and the mortises for the joining tang
    translate([0, 0, inner_r-join_height]) rotate([0, 0, 0])
        cylinder_segment(join_height+1, inner_r/2+join_thick, 90);
    translate([0, 0, inner_r-join_height]) rotate([0, 0, 179])
        cylinder_segment(join_height+1, inner_r/2+join_thick, 91);
    // and the slot to let it fit onto the side of the tank
    translate([-slot_width/2, -(outer_r-inner_r), -0.01])
        cube([slot_width, 0.01+outer_r-inner_r, inner_r+0.02+join_height]);
}
