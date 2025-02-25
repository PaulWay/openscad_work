include <../libs/pw_primitives.scad>;

hex_side2side = 104;  hex_side2r = hex_side2side / 2;
hex_thick = 73;  shaft_thick = 28.8;  shaft_x_off = 5;
// block_len = 135;  block_wid = 79;  block_high = 110;

side_thick = 3;
block_len = hex_side2side / sin(60) + side_thick * 4;
block_wid = hex_thick + side_thick * 2;
block_high = hex_side2side + side_thick * 2;
// block_y_off = (block_wid + hex_thick) / 2;
block_y_off = hex_thick + side_thick;
// shaft_y_off = (block_wid - hex_thick) / 2 + epsilo2;
shaft_y_off = side_thick + epsilo2;
block_z_cen = block_high/2;  

difference() {
    cube([block_len, block_wid, block_high]);
    // the two hexagons of the weight
    translate([shaft_x_off, block_y_off, block_z_cen]) rot(x=90)
      hexagon_solid(height=hex_thick, side2side=hex_side2side);
    translate([block_len-shaft_x_off, block_y_off, block_z_cen]) rot(x=90)
      hexagon_solid(height=hex_thick, side2side=hex_side2side);
    // the two shafts
    translate([shaft_x_off, -epsilon, block_z_cen]) rot(x=-90)
      cylinder(h=shaft_y_off, d=shaft_thick);
    translate([block_len-shaft_x_off, -epsilon, block_z_cen]) rot(x=-90)
      cylinder(h=shaft_y_off, d=shaft_thick);
}