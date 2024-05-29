include <../libs/pw_primitives.scad>;

eps = 0.01;
sphere_r = 5;
cube_x = 20;
cube_y = 40;
cube_z = 50;

$fn=45;

// experiment in making a chamfered edge at the top of a solid, say a
// cube, that can then be 'cut out' of a surface to provide a guide
// when inserting tools, say.
// The logic is to build a 'negative object' around the orignal shape,
// but curved using a minkowski join with a sphere at the top, then this
// is removed from a cube larger than the original by the radius of the
// sphere.  Without an effective 'offset' tool on 3D objects, its hard
// to do this without knowing the size and shape of the original object.
* difference() {
    cube([cube_x+sphere_r*2, cube_y+sphere_r*2, cube_z-eps]);
    translate([0, 0, 0]) minkowski(convexity=3) {
        difference() {
            cube([cube_x+sphere_r*2, cube_y+sphere_r*2, cube_z-sphere_r]);
            translate([sphere_r, sphere_r, -eps]) 
              cube([cube_x, cube_y, cube_z]);
        }
        sphere(r=sphere_r);
    };
}

length = 250;
thickness = 5;
i_width = 120; o_width = i_width + thickness*2;
i_height = 160; o_height = i_height + thickness*2;
cyl_diam = 500; cyl_rad = cyl_diam / 2;

// A rectangular 160x120 tube going tangentially into the
// side of a 500mm diameter cylinder.
* difference() {
    translate([0, 0, o_height]) rotate([0, 90, 0]) 
      rectangular_tube(i_height, i_width, thickness, length);
    translate([length, cyl_rad + thickness, -eps]) 
      cylinder(h=o_height+eps*2, d=cyl_diam);
}

// Circular feed-in tube of OD 160mm going tangentially into the
// side of a 500mm diameter cylinder.
* translate([160/2, 0, 160/2]) difference() {
    rotate([-90, 0, 0]) pipe_rt(250, 160/2, 5/2);
    translate([500/2+2.5-160/2, 0, -160/2]) cylinder(h=160, d=500);
}

// a section of 150mm pipe with angled vanes inside it to spin the
// airflow.
* union() {
    pipe_rt(100, 155/2, 5/2);
    translate([0, 0, 95]) pipe_rt(20, 160/2, 5/2);
    translate([0, 0, 90]) hollow_cone_rt(5, 155/2, 160/2, 5/2);
    difference() {
        linear_extrude(100, twist=45) union() {
            translate([-75+00, 0]) square([20.1, 2]);
            translate([+75-20, 0]) square([20.1, 2]);
            translate([0, -75+00]) square([2, 20.1]);
            translate([0, +75-20]) square([2, 20.1]);
        }
        translate([0, 0, -eps]) cylinder(h=20, d1=150, d2=110);
        translate([0, 0, 80]) cylinder(h=20+eps, d1=110, d2=150);
    }
}

// 45-degree rectangular feed-in to top of 150mm diameter tube.
// rectangular tube of same cross-sectional area as 150mm tube
// but half the height is 75 x 235 mm; here we use 80 x 240.
* union() {
    // the feed-in tube, minus the cylinder it's intersecting,
    // but only up to the cylinder.
    difference() {
        rotate([0, 0, 45]) translate([0, 0, 155]) 
          rotate([0, 90, 0]) rectangular_tube(80, 240, 2.5, 400);
        translate([-(240/sqrt(2)+10), 0, epsilon]) cube([240/sqrt(2), 240*sqrt(2), 155]);
        translate([0, 0, 155/2]) rotate([-90, 0, 0]) cylinder(h=430, d=150);
    };
    // the outlet tube, minus the rectangle intersecting it.
    difference() {
        translate([0, 0, 155/2]) rotate([-90, 0, 0]) pipe_rt(430, 155/2, 5/2);
        intersection() {
            rotate([0, 0, 45]) translate([0, 2.5, 152.5-80]) 
              cube([360, 240, 80]);
            cube([155, 430, 155]);
        }
    }
    // the end cap
    translate([0, 430-epsilon, 155/2]) rotate([-90, 0, 0]) cylinder(h=5, d=155);
}

// A rectangular duct resize from 160x120 to 240x80 in 200mm, plus 
union() {
    translate([-126/2, -166/2, 0]) rectangular_tube(126, 166, 3, 20);
    translate([0, 0, 20]) difference() {
        rectangular_cone(120/2+3, 160/2+6, 240/2+6, 80/2+6, 200);
        translate([3, 3, -epsilon]) rectangular_cone(120/2, 160/2, 240/2, 80/2, 200+epsilo2);
    }
}