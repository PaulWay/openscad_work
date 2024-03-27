// $fa = 8;
$fs = 0.25;

length = 28.2;
width = 19.35;
height = 15;
wall_thick = 3;
base_overlap = 2;
base_height = 2.1;
rivet_hole_dia = 8;
rivet_hole_len_offset = 5;
rivet_hole_wid_offset = 8.55-base_height;

union() {
    // the part inserted into the table leg
    translate([base_overlap, base_overlap, base_height]) difference() {
        cube([length, width, height]);
        // the internal cavity
        translate([wall_thick, wall_thick, wall_thick])
          cube([length-wall_thick*2, width-wall_thick*2, height-wall_thick+0.01]);
        // the rivet hole in the side
        translate([rivet_hole_len_offset, -0.01, height-rivet_hole_dia])
          // rotate([-90, 0, 0])
          // cylinder(d=rivet_hole_dia, h=width+0.02);
          cube([rivet_hole_dia, width+0.02, rivet_hole_dia+0.01]);
    }
    // the base
    cube([length+base_overlap*2, width+base_overlap*2, base_height+0.01]);
}