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
b_bolt_hole_dia = 6;
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

container_height = 150;  container_rim_low_height = 140;
container_length = 210;
container_width = 148;  container_in_width = 130;
full_support_height = container_height + 2;
container_top_thick = 10;  container_top_rad = 10;

// top outlet plate - mostly centred coordinates
module box_loader_outlet_plate() difference() {
    linear_extrude(container_top_thick, convexity=4) difference() {
        rounded_rect(container_length, container_width, container_top_rad);
        shredder_inlet_outlet_template();
    };
    // wall mortises
    translate([0, +upright_wall_y_off, mortise_z_off])
      cube([mortise_length, upright_wall_top_thick, container_top_thick+0.02],
        center=true);
    translate([0, -upright_wall_y_off, mortise_z_off])
      cube([mortise_length, upright_wall_top_thick, container_top_thick+0.02],
        center=true);
}

upright_wall_top_thick = 10;
upright_wall_lip_thick = 15;
upright_wall_base_thick = 30;
upright_wall_y_off = (container_width - upright_wall_top_thick) / 2 + 0.01;
mortise_length = 80;  mortise_tol = +0.5;
mortise_neg_length = (container_length - mortise_length) / 2 + mortise_tol;
mortise_z_off = (container_top_thick/2);
upright_wall_mortise_h_off = (
  container_height + container_top_thick - container_top_thick
);
plate_bolt_hole_len = 50;
plate_bolt_nut_hgt = 40;
plate_bolt_nut_len = 12; plate_bolt_nut_wid = 5;
plate_bolt_nut_y_off = container_height - plate_bolt_nut_hgt;

// side upright plate - 'height' here is +Y
module box_loader_side_plate() difference() {
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
        translate([-b_bolt_hole_x, container_height+0.01, container_top_thick/2])
          rot(x=90) cylinder(h=plate_bolt_hole_len, d=b_bolt_hole_dia);
        translate([+b_bolt_hole_x, container_height+0.01, container_top_thick/2])
          rot(x=90) cylinder(h=plate_bolt_hole_len, d=b_bolt_hole_dia);
        // holes to push nuts into that hold the bolts
        translate([-b_bolt_hole_x, plate_bolt_nut_y_off, container_top_thick/2])
          cube([plate_bolt_nut_len, plate_bolt_nut_wid, upright_wall_base_thick],
            center=true);
        translate([+b_bolt_hole_x, plate_bolt_nut_y_off, container_top_thick/2])
          cube([plate_bolt_nut_len, plate_bolt_nut_wid, upright_wall_base_thick],
            center=true);
    };
}

txl(y=container_width/2 +1) rot(x=90) box_loader_side_plate();
txl(y=-container_width/2 -1) rot(x=-90) rot(z=180) box_loader_side_plate();
color("green") txl(z=container_height +1) box_loader_outlet_plate();