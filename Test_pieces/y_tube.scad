include <pw_primitives.scad>;

module bendy_y(diameter, height, separation) union() {
    // A Y in a tube of inner diameter and thickness, with a total height
    // and the two tubes separation apart at their nearest points.
    // This is basically going to be two 's' bends, starting from the
    // middle bottom and going up-left and up-right.  The centre of the
    // tube is therefore separation/2 + diameter/2 apart at the top.
    centre_sep = separation/2 + diameter/2;
    // the midpoint of the 's' is the midpoint of the line joining the
    // bottom and top.  This is the hypotenuse of a right-angled triangle
    // from top to centre to bottom.  Therefore we can calculate this
    // distance and the angle from bottom to head outward to the top center.
    tri_dist = sqrt(pow(height, 2) + pow(centre_sep, 2));
    tri_angle = atan2(centre_sep, height);
    // the midpoint of the 's' is also where the two equal bends meet, and
    // therefore the angle must be the same - i.e the circle here is at
    // right angles to the hypotenuse.
    // the outer radius of this toroid connects the bottom and the mid, or the
    // mid and the top.  Therefore this is an isoceles triangle whose equal sides are
    // the radius and that is subtended by an angle of tri_angle*2 (?).
    // Therefore it is two right-angle triangles of angle tri_angle and opposite
    // side tri_dist/4.  The hypotenuse is the radius.
    outer_rad = (tri_dist/4) / sin(tri_angle); outer_hyp = (tri_dist/4) / tan(tri_angle);
    // right bend
    translate([outer_rad, 0, 0]) rotate([0, 0, 180-tri_angle*2])
      torus(outer_rad+diameter/2, diameter/2, tri_angle*2);
    // we need a thin cylinder in the middle so that each bend is entirely contiguous
    translate([centre_sep/2, height/2, 0]) rotate([-90, 0, -tri_angle*2])
      translate([0, 0, -0.01]) cylinder(d=diameter, h=0.1);
    translate([centre_sep-outer_rad, height, 0]) rotate([0, 0, -tri_angle*2])
      torus(outer_rad+diameter/2, diameter/2, tri_angle*2);
    // left bend
    translate([-outer_rad, 0, 0])
      torus(outer_rad+diameter/2, diameter/2, tri_angle*2);
    translate([-centre_sep/2, height/2, 0]) rotate([-90, 0, tri_angle*2])
      translate([0, 0, -0.01]) cylinder(d=diameter, h=0.1);
    translate([-(centre_sep-outer_rad), height, 0]) rotate([0, 0, 180])
      torus(outer_rad+diameter/2, diameter/2, tri_angle*2);
}

module tube_y(diameter, thickness, height, separation) difference() {
    bendy_y(diameter, height, separation);
    translate([0, -0.01, 0]) bendy_y(diameter-thickness, height+002, separation+thickness);
}

$fn=45;
//tube_y(60, 4, 100, 20);
tube_y(56, 3.6, 100, 30);
translate([0, 5, 0]) rotate([90, 0, 0]) pipe_rt(30, (56+3.6)/2, 3.6/2);
translate([+(56+30)/2, 95, 0]) rotate([-90, 0, 0]) pipe_rt(30, (56+3.6)/2, 3.6/2);
translate([-(56+30)/2, 95, 0]) rotate([-90, 0, 0]) pipe_rt(30, (56+3.6)/2, 3.6/2);

module straight_y(single_dia, duple_dia, thickness, height, separation) union() {
    // because cylinders go up into the Z, this also goes up into the Z.
    centre_sep = separation/2 + duple_dia/2;
    outer_rad = separation/2 + duple_dia;
    cylinder(d=1, h=height);
    translate([-separation/2, 0, height]) color("green") rotate([0, 90, 0])
      cylinder(h=separation, d=2);
    translate([-centre_sep, 0, height]) color("lightgreen") rotate([0, 90, 0])
      cylinder(h=centre_sep*2, d=1);
    translate([-centre_sep, 0, height+1]) color("darkred") cylinder(h=1, d=duple_dia);
    tri_angle = atan2(centre_sep, height);
    top_offset = duple_dia*sin(tri_angle)/2;
    tri_dist = sqrt(pow(height-top_offset, 2) + pow(centre_sep, 2));
    fudge = top_offset/2;
    // translate([0, 0, -bot_offset]) cylinder(h=bot_offset, d=single_dia);
    intersection() {
        rotate([0, -tri_angle, 0]) cylinder(h=tri_dist+0.1, d1=single_dia, d2=duple_dia);
        translate([-outer_rad, -single_dia/2, 0]) cube([outer_rad, single_dia, height]);
    };
    translate([fudge, 0, height])
      rotate([90, 180, 0]) torus(outer_rad, duple_dia/2, tri_angle);
    intersection() {
        rotate([0, +tri_angle, 0]) cylinder(h=tri_dist+0.1, d1=single_dia, d2=duple_dia);
        translate([0, -single_dia/2, 0]) cube([outer_rad, single_dia, height]);
    };
    echo("top_offset:", top_offset);
    translate([-fudge, 0, height])
      rotate([90, tri_angle, 0]) torus(outer_rad, duple_dia/2, tri_angle);
}

* difference() {
    straight_y(60, 32, 4, 50, 20);
    // # translate([0, 10, -epsilon]) straight_y(56, 26, 4, 50+epsilo2, 22);
}