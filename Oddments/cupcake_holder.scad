include <../libs/pw_primitives.scad>;

$fn=90;

module cupcake_holder(height, top_dia, bot_dia, top_off, thick, option=1) {
    // a cupcake holder with bottom and top circular diameter and minimum wall
    // height.  That is the height at the which adjacent cupcake holders will
    // touch at their closest point in an optimal packing.  Walls may continue
    // upward (option 2) or flatten out and be supported (option 1).  The sides
    // have a horizontal thickness of thick (outside the top and bottom inner
    // diameters) and the base has a vertical thickness of thick.
    top_o_dia = top_dia + thick; bot_o_dia = bot_dia + thick*2;
    total_wid = top_o_dia;
    centre = total_wid/2;
    side_angle = atan2((top_dia - bot_dia)/2, height);
    hexa_rad = (top_o_dia/2) / cos(30) + top_off/2;
    // hexa_height * (top_dia/2 - bot_dia/2) = height * (hexa_rad - bot_dia/2)
    hexa_height = (hexa_rad - bot_o_dia/2) / tan(side_angle);
    wall_thick = thick / cos(side_angle);
    cone_top_r = (option==2) ? (hexa_rad+wall_thick*2) : top_o_dia/2;
    cone_height = (option==2) ? hexa_height : height;
    translate([centre, centre, 0]) union() {
        // translate([0, 0, height+1]) color("lightgreen") cylinder(h=1, d=top_dia);
        // the base
        cylinder(h=thick, r=bot_dia/2+thick);
        // the inner cone
        if (option == 1) {
            hollow_cone_rt(height, bot_o_dia/2, top_o_dia/2, thick);
        } else if (option == 2 || option == 3) {
            intersection() {
                hollow_cone_rt(cone_height, bot_o_dia/2, cone_top_r, thick);
                rotate([0, 0, 30]) hexagon_solid(hexa_rad, hexa_height-25);
            }
        }
    }
    if (option == 1) {
        // surround, in hexagon
        translate([centre, centre, height-thick]) difference() {
            rotate([0, 0, 30]) hexagon_solid(hexa_rad, thick);
            translate([0, 0, -epsilon]) cylinder(h=thick+epsilo2, d=top_dia);
        }
    }
    if (option == 1) {
        // supports
        hexa_sin = hexa_rad * cos(60);
        translate([centre, centre-hexa_rad, 0]) rotate([0, 0, 120])
          cylinder_segment(height, 5, 120); 
        translate([0, centre-hexa_sin, 0]) rotate([0, 0, 60])
          cylinder_segment(height, 5, 120); 
        translate([0, centre+hexa_sin, 0]) rotate([0, 0, 0])
          cylinder_segment(height, 5, 120); 
        translate([centre, centre+hexa_rad, 0]) rotate([0, 0, 300])
          cylinder_segment(height, 5, 120); 
        translate([centre+hexa_rad, centre+hexa_sin, 0]) rotate([0, 0, 240])
          cylinder_segment(height, 5, 120); 
        translate([centre+hexa_rad, centre-hexa_sin, 0]) rotate([0, 0, 180])
          cylinder_segment(height, 5, 120); 
    }
}

hex_arrange(2, 2, 90)
cupcake_holder(30, 75, 55, 15, 2, 2);
