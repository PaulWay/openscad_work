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
* union() {
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
* difference() {
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

// top outlet plate
difference() {
    linear_extrude(container_top_thick) difference() {
        rounded_rect(container_length, container_width, container_top_rad);
        shredder_inlet_outlet_template();
    };
}

