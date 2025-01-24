include <../libs/pw_primitives.scad>;

module bendy_y(diameter, height, separation) union() {
    // A Y in a tube of inner diameter and thickness, with a total height
    // and the two tubes separation apart at their nearest points.
    // This is basically going to be two 's' bends, starting from the
    // middle bottom and going up-left and up-right.
    // The downside is that, because we can't change the minor diameter of a
    // toroid, the outlets have to be the same diameter as the inlets.
    //  The centre of the
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
      torus(outer_rad+diameter/2, diameter/2, angle=tri_angle*2);
    // we need a thin cylinder in the middle so that each bend is entirely contiguous
    translate([centre_sep/2, height/2, 0]) rotate([-90, 0, -tri_angle*2])
      translate([0, 0, -0.01]) cylinder(d=diameter, h=0.1);
    translate([centre_sep-outer_rad, height, 0]) rotate([0, 0, -tri_angle*2])
      torus(outer_rad+diameter/2, diameter/2, angle=tri_angle*2);
    // left bend
    translate([-outer_rad, 0, 0])
      torus(outer_rad+diameter/2, diameter/2, angle=tri_angle*2);
    translate([-centre_sep/2, height/2, 0]) rotate([-90, 0, tri_angle*2])
      translate([0, 0, -0.01]) cylinder(d=diameter, h=0.1);
    translate([-(centre_sep-outer_rad), height, 0]) rotate([0, 0, 180])
      torus(outer_rad+diameter/2, diameter/2, angle=tri_angle*2);
}

module tube_y(diameter, thickness, height, separation) difference() {
    bendy_y(diameter, height, separation);
    translate([0, -0.01, 0]) bendy_y(diameter-thickness, height+0.02, separation+thickness);
}

$fn=45;
//tube_y(60, 4, 100, 20);
* union() {
    tube_y(56, 3.6, 100, 30);
    translate([0, 5, 0]) rotate([90, 0, 0]) pipe_rt(30, (56+3.6)/2, 3.6/2);
    translate([+(56+30)/2, 95, 0]) rotate([-90, 0, 0]) pipe_rt(30, (56+3.6)/2, 3.6/2);
    translate([-(56+30)/2, 95, 0]) rotate([-90, 0, 0]) pipe_rt(30, (56+3.6)/2, 3.6/2);
}

module cylinder_xyzs(x1, y1, x2, y2, height, r) {
    // A cylinder, going from [x1, y1, 0] to [x2, y2, height].  The
    // cylinder is sheared and translated, so its top and bottom
    // are still parallel to the XY plane.
    translate([x1, y1, 0]) multmatrix([
        [1, 0, (x2-x1)/height, 0],
        [0, 1, (y2-y1)/height, 0],
        [0, 0, 1, 0]
    ]) cylinder(h=height, r=r);
}

module cone_xyzs(x1, y1, x2, y2, height, r1, r2) {
    // A cylinder, going from [x1, y1, 0] to [x2, y2, height].  The
    // cylinder is sheared and translated, so its top and bottom
    // are still parallel to the XY plane.
    translate([x1, y1, 0]) multmatrix([
        [1, 0, (x2-x1)/height, 0],
        [0, 1, (y2-y1)/height, 0],
        [0, 0, 1, 0]
    ]) cylinder(h=height, r1=r1, r2=r2);
}

module straight_y_tube(single_dia, duple_dia_, thickness, height, separation) union() {
    // This makes a single tube split in two.  You may not care about eddies
    // and friction, but you do care about the cross-sectional areas of the
    // inlet and outlet tubes being the same.  If 'duple_dia_' is set to
    // 'undef', it will be calculated as the diameter with half the area of
    // the single_dia circle.
    // Because cylinders go up into the Z, this also goes up into the Z.
    duple_dia = (duple_dia_ != undef) ? duple_dia_ : sqrt(single_dia^2 / 2);
    centre_sep = separation/2 + duple_dia/2;
    single_irad = single_dia/2; single_orad = single_irad+thickness;
    duple_irad = duple_dia/2; duple_orad = duple_irad+thickness;
    // Main split using sheared cones
    difference() {
        union() {
            cone_xyzs(0, 0, -centre_sep, 0, height, single_orad, duple_orad);
            cone_xyzs(0, 0, centre_sep, 0, height, single_orad, duple_orad);
        }
        txl(z=-0.01) union() {
            cone_xyzs(0, 0, -centre_sep, 0, height+epsilo2, single_irad, duple_irad);
            cone_xyzs(0, 0, centre_sep, 0, height+epsilo2, single_irad, duple_irad);
        }
    }
}

//txl(x=100) 
union() {
    txl(z=20) straight_y_tube(60, 42, 2, 100, 20);
    pipe_rt(20, (62+2)/2, 2);
    txl(x=-31, z=120) pipe_rt(20, (44+2)/2, 2);
    txl(x=31, z=120) pipe_rt(20, (44+2)/2, 2);
}