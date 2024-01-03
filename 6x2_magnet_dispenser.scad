include <pw_primitives.scad>;

$fn=45;

eps = 0.01;
tolerance = 0.2;

text_len = 5; text_thick = 1;
magnet_dia = 6;
magnet_thick = 2;
slider_len = 100;
slider_wid = 10;
slider_thick = 4;
slider_hole_offset = 80;
switcher_x_offset = 5;  switcher_x_extra = 1; switcher_z_offset = 0.5;
switcher_wid = magnet_dia + switcher_x_extra*2;
switcher_thick = magnet_thick + switcher_z_offset;
body_len = 50;
body_x_wall = 5; body_z_wall = 4;
body_wid = slider_wid+body_x_wall*2;
body_thick = slider_thick+switcher_thick+body_z_wall*2;
body_chamfer = 3;
tube_x_offset = body_wid/2+magnet_dia; tube_y_offset = 30;
tube_thick = 30;  tube_outer_dia = 12;  tube_inner_dia = magnet_dia+tolerance*2;
switcher_len = body_wid - switcher_x_offset + text_len;
slider_z_offset = body_z_wall + switcher_thick + tolerance;
peg_dia = 2.5;  peg_height = 2;
peg_x_offset = 0.5; peg_y_offset = 2;
peg_x = slider_wid/2 - peg_x_offset + peg_dia;
peg_y = body_len/2 - peg_y_offset - peg_dia;

// pegs inside the corners of a box from -x,-y to x,y
module pegs(x, y, r, h) {
    translate([ x,  y, 0]) cylinder(r=r, h=h);
    translate([-x,  y, 0]) cylinder(r=r, h=h);
    translate([ x, -y, 0]) cylinder(r=r, h=h);
    translate([-x, -y, 0]) cylinder(r=r, h=h);
}


// body - base
union() {
    difference() {
        chamfered_cube(body_wid, body_len, body_thick, body_chamfer, chamfer_y=false);
        // The slider channel
        translate([body_x_wall, -eps, slider_z_offset]) 
          cube([slider_wid+tolerance, body_len+eps*2, slider_thick+tolerance*2]);
        // The channel for the magnet switcher
        translate([switcher_x_offset, tube_y_offset, body_z_wall]) 
          // rotated: switch x/y
          cube([switcher_len, switcher_wid+tolerance, switcher_thick+tolerance+eps]); 
        // Remove the top of the body
        translate([-eps, -eps, slider_z_offset+slider_thick+tolerance*2-eps]) 
          cube([body_wid+eps*2, body_len+eps*2, body_z_wall+tolerance]);
    }
    // The pegs - centred on centre of body
    translate([body_wid/2, body_len/2, slider_z_offset+slider_thick]) 
      pegs(peg_x, peg_y, peg_dia/2+tolerance, peg_height);
}

// the body - upper
translate([-30, 0, 0]) difference() {
    // the base and outer tube
    translate([0, 0, -(slider_z_offset+slider_thick+tolerance*2)]) union() {
        translate([body_wid/2, tube_y_offset+tube_outer_dia/2, 0]) 
          cylinder(h=tube_thick, d=tube_outer_dia);
        chamfered_cube(body_wid, body_len, body_thick, body_chamfer, chamfer_y=false);
    }
    // Everything below the upper
    translate([-eps, -eps, -body_thick]) 
      cube([body_wid+eps*2, body_len+eps*2, body_thick]);
    // The feeder tube
    translate([body_wid/2, tube_y_offset+tube_outer_dia/2, -eps]) 
      cylinder(h=tube_thick+1, d=tube_inner_dia);
    // the pegs, removed
    translate([body_wid/2, body_len/2, -eps]) 
      pegs(peg_x, peg_y, peg_dia/2, peg_height+tolerance+eps);
}

// reversible magnet holder - slide into the side, pull out to flip upside down
// translate([switcher_x_offset, tube_y_offset+switcher_wid+tolerance, body_z_wall]) 
//   rotate([0, 0, -90]) 
translate([-50, 0, 0])
difference() {
    // the slide and N
    union() {
        cube([switcher_wid, switcher_len, switcher_thick]);
        translate([switcher_wid/2, switcher_len-text_len, switcher_thick-eps]) 
          linear_extrude(text_thick) text(
            "N", size=5, font="Liberation Sans:style=Regular", 
            halign="center", valign="center"
          );
    };
    // the magnet hole
    translate([switcher_wid/2, slider_wid/2, switcher_thick-magnet_thick+0.01]) 
      cylinder(d=magnet_dia, h=magnet_thick);
    // the bottom text
    translate([switcher_wid/2, switcher_len-text_len, -0.01]) 
      linear_extrude(text_thick) text(
        "S", size=5, font="Liberation Sans:style=Regular", 
        halign="center", valign="center"
      );
}

// the slider
translate([30, 0, 0]) difference() {
    cube([slider_wid, slider_len, slider_thick]);
    translate([slider_wid/2, slider_hole_offset+magnet_dia/2, magnet_thick]) 
      cylinder(h=magnet_thick+eps, d=magnet_dia+tolerance);
}