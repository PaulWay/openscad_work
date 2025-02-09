include <../libs/pw_primitives.scad>;

inlet_length = 116;  // not quite?
inlet_width = 100;  // not quite?

plate_corner_r = 5;
top_p_length = 155;  top_p_l = top_p_length - plate_corner_r*2;
top_p_width = 155;  top_p_w = top_p_width - plate_corner_r*2;
top_p_thick = 5;  top_p_t_eps = top_p_thick +0.03;
t_bolt_hole_edge_off = 7;  // to edge of hole
t_bolt_hole_dia = 5;
t_bolt_hole_x = top_p_length/2 - t_bolt_hole_edge_off - t_bolt_hole_dia/2;
t_bolt_hole_y = top_p_width/2 - t_bolt_hole_edge_off - t_bolt_hole_dia/2;
through_hole_x_off = 9.5;  // to center
through_hole_y_off = 34;
through_hole_dia = 9;
through_hole_x = top_p_length/2 - through_hole_x_off;
through_hole_y = top_p_width/2 - through_hole_y_off;

funnel_thick = 3;  funnel_height = 150;

module shredder_inlet_outlet_template() union() {
    // center inlet hole
    square([inlet_length, inlet_width], center=true);
    // holes to put bolt holes
    translate([-b_bolt_hole_x, -b_bolt_hole_y]) circle(d=b_bolt_hole_dia);
    translate([-b_bolt_hole_x, +b_bolt_hole_y]) circle(d=b_bolt_hole_dia);
    translate([+b_bolt_hole_x, -b_bolt_hole_y]) circle(d=b_bolt_hole_dia);
    translate([+b_bolt_hole_x, +b_bolt_hole_y]) circle(d=b_bolt_hole_dia);
    // holes to avoid shredder bolts
    translate([-through_hole_x, -through_hole_y]) circle(d=b_through_hole_dia);
    translate([-through_hole_x, +through_hole_y]) circle(d=b_through_hole_dia);
    translate([+through_hole_x, -through_hole_y]) circle(d=b_through_hole_dia);
    translate([+through_hole_x, +through_hole_y]) circle(d=b_through_hole_dia);
};

module rounded_rect(x, y, rad) {
    // a rectangle fitting inside x, y, with rounded corners.
    xmr2 = x - rad*2;  ymr2 = y - rad*2;
    offset(rad) square([xmr2, ymr2], center=true);
};

$fn = $preview ? 20 : 50;
// inlet funnel
module inlet_funnel() union() {
    // base plate
    linear_extrude(top_p_thick) difference() {
        rounded_rect(top_p_length, top_p_width, plate_corner_r);
        shredder_inlet_outlet_template();
    }
    // inlet funnel
    linear_extrude(funnel_height) difference() {
        offset(funnel_thick) square([inlet_length, inlet_width], center=true);
        square([inlet_length, inlet_width], center=true);
    }
}

bot_p_corner_r = 5;
bot_p_length = 155;  bot_p_l = bot_p_length - bot_p_corner_r*2;
bot_p_width = 180;  bot_p_w = bot_p_width - bot_p_corner_r*2;
bot_p_thick = 5;  bot_p_t_eps = bot_p_thick +0.03;

bot_b_length = 180;  bot_b_l = bot_b_length - bot_p_corner_r*2;
bot_b_width = 126;  bot_b_w = bot_b_width - bot_p_corner_r*2;
bot_b_thick = 20;  bolt_p_b_off = bot_b_thick - bot_p_thick;

b_bolt_hole_x_off = 27;  // from outer edge of plate to centre
b_bolt_hole_y_off = 21;
b_bolt_hole_dia = 6;  b_bolt_head_dia = 12;
b_bolt_outer_dia = 10;
b_bolt_hole_x = bot_p_length/2 - b_bolt_hole_x_off;
b_bolt_hole_y = bot_p_width/2 - b_bolt_hole_y_off;

b_through_hole_dia = 10.5;

// basic outlet mount
module basic_outlet_plate() difference() {
    // base plate
    filleted_hexahedron(
      bot_b_length/2, bot_b_width/2, bot_p_length/2, bot_p_width/2, 
      bot_b_thick, bot_p_corner_r
    );
    // all the holes
    translate([0, 0, -0.01]) linear_extrude(bot_b_thick+0.02)
      shredder_inlet_outlet_template();
    translate([0, 0, -0.01]) linear_extrude(bolt_p_b_off) union() {
        // clearance holes for bolts to secure to shredder
        translate([-b_bolt_hole_x, -b_bolt_hole_y]) circle(d=b_bolt_outer_dia);
        translate([-b_bolt_hole_x, +b_bolt_hole_y]) circle(d=b_bolt_outer_dia);
        translate([+b_bolt_hole_x, -b_bolt_hole_y]) circle(d=b_bolt_outer_dia);
        translate([+b_bolt_hole_x, +b_bolt_hole_y]) circle(d=b_bolt_outer_dia);
    }
};

container_height = 154;  container_rim_low_height = 142;
container_length = 210;
container_top_width = 148;  container_in_width = 130;
container_top_in_width = 133;
container_bot_width = 117;
container_lip_wid_2 = (container_top_width - container_top_in_width) / 2;
container_bot_wid_2 = (container_top_width - container_bot_width) / 2;
container_top_thick = 11;  container_top_rad = 10;
container_plate_width = container_top_width + container_top_thick * 2;

module box_template() {
    hctw = container_top_width/2; hctiw = container_top_in_width/2;
    hcbw = container_bot_width/2;
    linear_extrude(10) polygon([
        // across the top
        [-hctw, container_height], [+hctw, container_height],
        // down the rhs
        [+hctw, container_rim_low_height], [+hctiw, container_rim_low_height],
        // across the bottom
        [+hcbw, 0], [-hcbw, 0],
        [-hctiw, container_rim_low_height], [-hctw, container_rim_low_height],
    ]);
}

b_bolt_head_z_off = 5;  b_bolt_head_thick = 10;

// p2w_bolt_x_off = 85;  // nicer placing but have to reprint
p2w_bolt_x_off = b_bolt_hole_x;
p2w_bolt_y_off = (container_top_width + container_top_thick)/2;
// top outlet plate - mostly centred coordinates
module box_loader_outlet_plate() difference() {
    linear_extrude(container_top_thick, convexity=4) difference() {
        rounded_rect(container_length, container_plate_width, container_top_rad);
        // rotate([0, 0, 90]) 
        shredder_inlet_outlet_template();
    };
    // wall mortises
    translate([0, +upright_wall_y_off, mortise_z_off])
      cube([mortise_length, upright_wall_top_thick, container_top_thick+0.02],
        center=true);
    translate([0, -upright_wall_y_off, mortise_z_off])
      cube([mortise_length, upright_wall_top_thick, container_top_thick+0.02],
        center=true);
    // head holes for shredder mounts (underside, but on top here)
    translate([0, 0, b_bolt_head_z_off]) 
      linear_extrude(b_bolt_head_thick, convexity=4) union() {
        // holes to put bolt holes
        translate([-b_bolt_hole_x, -b_bolt_hole_y]) circle(d=b_bolt_head_dia);
        translate([-b_bolt_hole_x, +b_bolt_hole_y]) circle(d=b_bolt_head_dia);
        translate([+b_bolt_hole_x, -b_bolt_hole_y]) circle(d=b_bolt_head_dia);
        translate([+b_bolt_hole_x, +b_bolt_hole_y]) circle(d=b_bolt_head_dia);
    }
    // holes for bolts to sides
    translate([0, 0, -0.01]) 
      linear_extrude(container_top_thick+0.02, convexity=4) union() {
        // holes to put bolt holes
        translate([-p2w_bolt_x_off, -p2w_bolt_y_off]) circle(d=b_bolt_hole_dia);
        translate([-p2w_bolt_x_off, +p2w_bolt_y_off]) circle(d=b_bolt_hole_dia);
        translate([+p2w_bolt_x_off, -p2w_bolt_y_off]) circle(d=b_bolt_hole_dia);
        translate([+p2w_bolt_x_off, +p2w_bolt_y_off]) circle(d=b_bolt_hole_dia);
    }
}

full_support_height = container_height + 2;
upright_wall_top_thick = 10;
upright_wall_lip_thick = upright_wall_top_thick + container_lip_wid_2;
upright_wall_base_thick = upright_wall_top_thick + container_bot_wid_2;
upright_wall_y_off = (container_plate_width - upright_wall_top_thick) / 2 + 0.01;
mortise_length = 80;  mortise_tol = +0.5;
mortise_neg_length = (container_length - mortise_length) / 2 + mortise_tol;
mortise_z_off = (container_top_thick/2);
upright_wall_mortise_h_off = (
  container_height + container_top_thick - upright_wall_top_thick
);
plate_bolt_hole_len = 40;
plate_bolt_nut_hgt = 30;
plate_bolt_nut_len = 12; plate_bolt_nut_wid = 5;
plate_bolt_nut_y_off = container_height - plate_bolt_nut_hgt;

// bolts to hold side to baseplate
s_bolt_hole_x_off = 20;  // from outer edge of plate to centre
s_bolt_hole_x = container_length/2 - s_bolt_hole_x_off;
base_bolt_shaft_d = 6;
base_bolt_shaft_len = 10;
base_bolt_head_d = 20;
base_bolt_head_len = container_rim_low_height - container_top_thick;
s_bolt_hole_z = upright_wall_base_thick - base_bolt_shaft_d;
cutout_x = 50;
cutout_dia = 20;

// side upright plate - 'height' here is +Y
module box_loader_side_plate(container_length) difference() {
    // side profile, extruded and then moved back to centred X coordinates
    txl(x=container_length/2) 
    rot(y=-90) linear_extrude(container_length, convexity=4) polygon([
        // origin is base outer of LHS - inner is +X, height is +Y
        [0, 0], [0, container_height+container_top_thick],
        [upright_wall_top_thick, container_height+container_top_thick],
        [upright_wall_top_thick, container_rim_low_height],
        [upright_wall_lip_thick, container_rim_low_height],
        [upright_wall_base_thick, 0],
    ]);
    // group subtractions when length not just a template
    if (container_length > 10) union() {
        // mortise removes
        translate([-container_length/2-0.01, upright_wall_mortise_h_off, -0.01])
        cube([mortise_neg_length, upright_wall_top_thick+0.01,
          container_top_thick+0.02]);
        translate([container_length/2+0.01-mortise_neg_length,
          upright_wall_mortise_h_off, -0.01])
        cube([mortise_neg_length, upright_wall_top_thick+0.01,
          container_top_thick+0.02]);
        // holes to fit bolt to shredder to and hold top and side together
        translate([-p2w_bolt_x_off, container_height +1.01, container_top_thick/2])
          rot(x=90) cylinder(h=plate_bolt_hole_len, d=b_bolt_hole_dia);
        translate([+p2w_bolt_x_off, container_height +1.01, container_top_thick/2])
          rot(x=90) cylinder(h=plate_bolt_hole_len, d=b_bolt_hole_dia);
        // holes to push nuts into that hold the bolts
        translate([-p2w_bolt_x_off, plate_bolt_nut_y_off, container_top_thick/2])
          cube([plate_bolt_nut_len, plate_bolt_nut_wid, upright_wall_base_thick],
            center=true);
        translate([+p2w_bolt_x_off, plate_bolt_nut_y_off, container_top_thick/2])
          cube([plate_bolt_nut_len, plate_bolt_nut_wid, upright_wall_base_thick],
            center=true);
        // holes to attach side to base plate
        translate([-s_bolt_hole_x, -0.01, s_bolt_hole_z])
          rot(x=-90) flat_head_bolt_hole(
            base_bolt_shaft_d, base_bolt_shaft_len,
            base_bolt_head_d, base_bolt_head_len
          );
        translate([+s_bolt_hole_x, 0, s_bolt_hole_z])
          rot(x=-90) flat_head_bolt_hole(
            base_bolt_shaft_d, base_bolt_shaft_len,
            base_bolt_head_d, base_bolt_head_len
          );
        // cutout?
        txl(z=upright_wall_base_thick) hull() {
            txl(x=+cutout_x, y=-0.01) rot(x=-90)
              cylinder(d=cutout_dia, h=base_bolt_head_len);
            txl(x=-cutout_x, y=-0.01) rot(x=-90)
              cylinder(d=cutout_dia, h=base_bolt_head_len);
        }
    };
}

* union() {
    txl(y=container_plate_width/2 +1) rot(x=90)
      box_loader_side_plate(container_length);
    txl(y=-container_plate_width/2 -1) rot(x=-90) rot(z=180)
      box_loader_side_plate(container_length);
    color("green") txl(z=container_height +1) box_loader_outlet_plate();
    color("white") translate([-100, 0, 0]) rotate([90, 0, 90]) box_template();
}

box_loader_outlet_plate();
// box_loader_side_plate(container_length);