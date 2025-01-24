include <../libs/pw_primitives.scad>;
include <../../gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

$fn=$preview ? 40 : 80;

body_dia = 30;  body_rad = body_dia/2;
sphere_end_height = 13;  sphere_cut_z = body_rad - sphere_end_height + 1;
body_height = 30;
cone_height = 20;
top_dia = 15;
total_height = body_height+cone_height;
hex_slot_height = 20;  hex_slot_z = total_height - hex_slot_height;
hex_slot_rad = 7.6/2;
groove_dia = 14;  groove_offset = body_rad;

module hex_bit_holder() difference() {
    union() {
        difference() {
            translate([0, 0, sphere_end_height]) sphere(d=body_dia);
            translate([-body_rad, -body_rad, -sphere_cut_z])
              cube([body_dia, body_dia, sphere_cut_z]);
        }
        translate([0, 0, sphere_end_height])
          cylinder(h=body_height-sphere_end_height, d=body_dia);
        translate([0, 0, body_height-epsilon])
          cylinder(h=cone_height, d1=body_dia, d2=top_dia);
    }
    
    translate([0, 0, hex_slot_z])
      hexagon_solid(hex_slot_rad, hex_slot_height+epsilon);
    rotate_distribute(6) rotate([8, 0, 0])
      translate([0, groove_offset+groove_dia/2, 0])
      cylinder(d=groove_dia, h=total_height);
}
// translate([0, 0, 49]) cylinder(d=6, h=2);  // test 6x2mm magnet
hex_bit_holder();

style_hole = 3; // [0:no holes, 1:magnet holes only, 2: magnet and screw holes - no printable slit, 3: magnet and screw holes - printable slit]
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// internal fillet for easy part removal
enable_scoop = true;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// enable upper lip for stacking other bins
enable_lip = true;
length = 42;

* color("tomato") {
gridfinityInit(1, 1, height(4, gridz_define, enable_lip, enable_zsnap), 0, 42) {
    linear_extrude(50) offset(r=0.5) projection(cut=false)
    cut_move(x=0, y=0, w=1, h=1) hex_bit_holder();
}
gridfinityBase(1, 1, 42, 1, 1, style_hole);

}
