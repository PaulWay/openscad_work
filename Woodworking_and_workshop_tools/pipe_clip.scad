include <../libs/pw_primitives.scad>;

module push_in_pipe_clip(
    height, outer_dia, inner_dia,
    throat_dia=0, back_len=0, back_thick=0, screw_hole_dia=0
) difference() {
    // A clip to hold a pipe or cylinder against a flat wall.  Main specifications
    // are height of clip and outer and inner diameters.  Other measurements can be
    // calculated if not given:
    // * throat_dia: the width of the entry to the clip
    // * back_len: the total length of the back.  Must be able to accommodate the
    //    two screw holes without having a bendy screwdriver
    // * back_thick: the thickness of the back plate
    // * screw_hole_dia: the shaft thickness of the (countersunk) screws
    assert(inner_dia < outer_dia, "Inner must be smaller than outer");
    throat_dia = (throat_dia==0) ? inner_dia*0.9 : throat_dia;
    screw_hole_dia = (screw_hole_dia==0) ? (height-2) / 2 : screw_hole_dia;
    back_len = (back_len==0) ? outer_dia + screw_hole_dia*4 : back_len;
    back_thick = (back_thick==0) ? (outer_dia-inner_dia)/2 : back_thick;
    assert(throat_dia < inner_dia, "Throat must be smaller than inner diameter");
    assert(back_len > outer_dia + screw_hole_dia*2, "Back must be able to fit screw holes");
    support_thick = outer_dia-inner_dia;
    outer_rad = outer_dia/2;  inner_rad = inner_dia/2;  throat_rad = throat_dia/2;
    back_half = back_len/2;
    union() {
        // the main clip
        cylinder(h=height, d=outer_dia);
        // the back, with two countersink holes taken out
        txl(x=-outer_rad, y=-back_half) difference() {
            cube([back_thick, back_len, height]);
             translate([-0.01, screw_hole_dia+1, height/2]) rot(y=90)
               countersunk_bolt_hole(screw_hole_dia, screw_hole_dia*2, back_thick+0.02);
             translate([-0.01, back_len-screw_hole_dia-1, height/2]) rot(y=90)
               countersunk_bolt_hole(screw_hole_dia, screw_hole_dia*2, back_thick+0.02);
        };
        // the support
        txl(x=-(inner_rad+0.01), y=-inner_rad) cube([support_thick, inner_dia, height]);
    }
    txl(z=-0.01) union() {
        cylinder(h=height+0.02, d=inner_dia);
        txl(y=-throat_rad) cube([outer_rad, throat_dia, height+0.02]);
    }
}

function pythag(x, y) = sqrt(x*x+y*y);

$fn=50;
* push_in_pipe_clip(30, 64, 56, back_thick=8, screw_hole_dia = 6);

module two_part_pipe_clamp(height, pipe_dia, thickness, screw_hole_dia, part="over") {
    // A pipe clamp that has one part that screws to a backing plate, and another part
    // which bolts onto that which holds the pipe in place.
    assert ((part == "over" || part == "under"), "'part' parameter must be 'over' or 'under'");
    base_holes = "two screw";
    // base_holes = "one bolt";
    lug_eps = (pythag((pipe_dia+thickness), thickness) - (pipe_dia+thickness))*2;
    base_thick = (base_holes == "one bolt") ? 10 : thickness*2;
    pipe_rad = pipe_dia / 2;  pipe_outer_rad = pipe_rad + thickness;
    base_rad = pipe_rad * 3 / 4;
    // The main part outer is just mirrored underneath, so do this with a mirror vector
    mirror_vec = ((part == "over") ? [0, 0, 0] : [0, 1, 0]);
    mirror(mirror_vec) difference() {
        union() {
            // the main bracket
            pipe_rt_segment(pipe_rad, thickness, height, 180);
            // the LH (-X) lug
            translate([-pipe_outer_rad+lug_eps, 0, height/2]) rotate([-90, 90, 0])
              cylinder_segment(thickness, height/2, 180);
            // the RH (+X) lug
            translate([pipe_outer_rad-lug_eps, 0, height/2])rotate([-90, -90, 0])
              cylinder_segment(thickness, height/2, 180);
            // the base, if this is the base part
            if (part == "under") difference() {
                translate([-base_rad, pipe_rad/2, 0])
                  cube([base_rad*2, pipe_rad/2+base_thick, height]);
                translate([0, 0, -epsilon]) cylinder(h=height+epsilo2, d=pipe_dia);
            }
        }
        translate([0, -epsilon, height/2]) union() {
            // the LH lug screw hole
            translate([-(pipe_outer_rad+height/4), 0, 0]) rotate([-90, 0, 0])
              cylinder(h=thickness+epsilo2, d=screw_hole_dia);
            // the RH lug screw hole
            translate([pipe_outer_rad+height/4, 0, 0]) rotate([-90, 0, 0])
              cylinder(h=thickness+epsilo2, d=screw_hole_dia);
            if (part == "under") {
                if (base_holes == "two screw") {
                    echo("Screw holes are", +pipe_rad*2/2.2, "apart");
                    translate([+pipe_rad/2.2, pipe_rad+thickness*3, 0]) rotate([90, 0, 0])
                      flat_head_bolt_hole(
                        screw_hole_dia, thickness*3, screw_hole_dia*2, thickness*2);
                    translate([-pipe_rad/2.2, pipe_rad+thickness*3, 0]) rotate([90, 0, 0])
                      flat_head_bolt_hole(
                        screw_hole_dia, thickness*3, screw_hole_dia*2, thickness*2);
                } else if (base_holes == "one bolt") {
                    translate([0, pipe_rad+11, 0]) rotate([90, 0, 0])
                      flat_head_bolt_hole(8, 5, 18, 15);
                }
            }
        }
    }
    // Then we have the underneath mounting block
}

two_part_pipe_clamp(part="over", 30, 55.9, 3, 4);
translate([0, -5, 0]) two_part_pipe_clamp(part="under", 30, 55.9, 3, 4);