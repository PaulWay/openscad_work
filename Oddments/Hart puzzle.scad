include <../libs/pw_funcs.scad>;
include <../libs/pw_primitives.scad>;

function fn() = (
    $fn>0 ? ($fn>=3?$fn:3) : ceil(max(min(360/$fa,$fs),5))
);
function wiggle(step) = (step%2 == 0) ? 0 : 0.001;
function line(from, to, steps=undef, stepwidth=undef) = [
    let(
        diff=to-from,
        steps_ = (steps==undef ? (
            stepwidth==undef ? fn() : sqrt(diff.x^2 + diff.y^2) / stepwidth
        ) : steps),
        inc=diff/steps_
    )
    for(step=[0:steps_])
        [from.x + inc.x*step + wiggle(step), from.y + inc.y*step + wiggle(step)]
];

function arc(r, from_a=-90, to_a=+90) = [
    let(dir=(from_a<to_a) ? 1 : -1)
    for(ang=[from_a:fn()*dir:to_a]) [r*cos(ang), r*sin(ang)]
];

module divsquare(vec, stepwidth=2) polygon([
    each line([0, 0], [0, vec.y], stepwidth=stepwidth),
    [vec.x, vec.y], [vec.x, 0]
]);

module halfsquare(r, stepwidth=2) polygon([
    each line([0, -r], [0, +r], stepwidth=stepwidth),
    [r, +r], [r, -r]
]);

module halfcirc(r, stepwidth=2) polygon([
    each line([0, +r], [0, -r], stepwidth=stepwidth),
    each arc(r)
]);

module tetrahedron(sidelen) {
    height = sidelen*sin(60);
    width = sidelen/2;
    polyhedron(
        [   [0, 0, 0], [sidelen, 0, 0],
            [width, -width, height], [width, +width, height]],
        [   [0, 2, 1], [0, 1, 3], [0, 3, 2], [1, 2, 3] ]
    );
}

module r_tetrahedron(sidelen, r, within_tetra=false) {
    // Like a tetrahedron but using a hull to get rounded corners.
    // With `within_tetra` left as false, the spheres are positioned
    // so that the edges of the rounded tetrahedron touch the edges
    // of the original tetrahedron, but the faces will stick out.
    // With `within_tetra` set to true, the spheres are positioned so
    // that the faces are entirely within the tetrahedron; this means
    // the rounded sides don't touch the X axis.
    z_off = r*(within_tetra ? 2 : 1);
    wid_off = r*(within_tetra ? 2.3333333 : 1);
    height = sidelen*sin(60) - z_off;
    sidelen2 = sidelen / 2;
    width = sidelen2 - wid_off;
    hull() {
        translate([wid_off, 0, z_off]) sphere(r);
        translate([sidelen-wid_off, 0, z_off]) sphere(r);
        translate([sidelen2, -width, height]) sphere(r);
        translate([sidelen2, +width, height]) sphere(r);
    }
}

module octahedron(height) {
    // An octahedron of given height centred on the origin.  This means
    // that all points are exactly half the height from the origin.
    // The distance from tip to opposite tip is `height`, sides are
    // sqrt(2)*height long.
    hheight = height / 2;
    polyhedron(
        [
            [0, 0, -hheight],
            [-hheight, 0, 0], [0, +hheight, 0],
            [+hheight, 0, 0], [0, -hheight, 0],
            [0, 0, +hheight]
        ], [
            [0, 2, 1], [0, 3, 2], [0, 4, 3], [0, 1, 4],
            [5, 1, 2], [5, 2, 3], [5, 3, 4], [5, 4, 1],
        ]
    );
}

* rotate([45, 0, 0]) translate([0, 0, 50]) 
octahedron(100);

module octahedron_s(sidelen) {
    // An octahedron defined by its side length.  Its height is
    // sidelen/sqrt(2).
    halflen = sidelen / 2;
    hheight = sidelen * sin(45);
    polyhedron(
        [
            [halflen, -hheight, halflen],
            [0, 0, 0], [sidelen, 0, 0],
            [sidelen, 0, sidelen], [0, 0, sidelen],
            [halflen, +hheight, halflen]
        ], [
            [0, 2, 1], [0, 3, 2], [0, 4, 3], [0, 1, 4],
            [5, 1, 2], [5, 2, 3], [5, 3, 4], [5, 4, 1],
        ]
    );
}

module r_octahedron_s(sidelen, r) {
    // A rounded octahedron of a given side length, with the bottom edge
    // being on the X axis from the origin to +sidelen and the 'top' edge
    // being +sidelen in Z above that.  Each side forms an equilateral
    // triangle, and the 'side' points are half the sidelen along X and Z.
    // The 'height' is derived from the triangle from the origin to +X+Z,
    // which is base length sidelen*sqrt(2); half of this forms the base
    // of a 45 degree right-angled triangle of height side/
    // The sphere needs to sit a radius 'back' from the edge; so while the
    // actual rounded edge of the shape doesn't touch the un-rounded edge
    // of the shape, the rounded shape is entirely within the un-rounded
    // shape.

    ir = r * sin(60);
    sr = sidelen - r;
    hs = sidelen/2; y = hs*sqrt(2);

    hull() {
        translate([ir, 0, r]) sphere(r);
        translate([sr, 0, r]) sphere(r);
        translate([sr, 0, sr]) sphere(r);
        translate([ir, 0, sr]) sphere(r);
        translate([hs, +y-r, hs]) sphere(r);
        translate([hs, -y+r, hs]) sphere(r);
    }
}

module hollow_r_octahedron_s(sidelen, r, thick) difference() {
    assert(sidelen>thick*2, "Side must be bigger than thickness");
    r_octahedron_s(sidelen, r);
    translate([thick, 0, thick]) r_octahedron_s(sidelen-thick*2, r);
}

module r_cylinder(diameter, height, r) minkowski() {
    angle = atan2(diameter, height);
    z = r*cos(angle);
    rotate([0, angle, 0]) translate([-diameter/2, 0, z])
      cylinder(h=height, d=diameter-r*2);
    sphere(r=r);
}

module r_cube(sidelen, r, within_cube=false) {
    // A rounded cube, rotated on the X axis to be like the tetrahedron
    // and octahedron models.
    // If `within_cube` is left as false, the bottom edge will be on the X
    // axis but the sides will be sidelen+r*2 apart.  If `within_cube` is
    // set to true then the sides are sidelen apart but the side length is
    // shorter and the cube no longer touches the X axis.
    off = r * (within_cube ? sqrt(2) : 1);
    side1 = r; side2 = sidelen - r;
    hheight = sidelen/2 * sqrt(2);  fheight = sidelen * sqrt(2) - off;
    hwidth = hheight - off; 
    hull() {
        translate([side1, 0, side1]) sphere(r);
        translate([side2, 0, side1]) sphere(r);
        translate([side1, +hwidth, hheight]) sphere(r);
        translate([side1, -hwidth, hheight]) sphere(r);
        translate([side2, +hwidth, hheight]) sphere(r);
        translate([side2, -hwidth, hheight]) sphere(r);
        translate([side1, 0, fheight]) sphere(r);
        translate([side2, 0, fheight]) sphere(r);
    }
}

module hollow_r_cube(sidelen, r, thick, within_cube=false) difference() {
    r_cube(sidelen, r, within_cube);
    if (thick < sidelen/2) translate([thick, 0, thick])
      r_cube(sidelen-thick*2, r, within_cube);
}

//     linear_extrude(100, convexity=6, twist=twist, slices=200)
//       translate([0, -60, 0]) divsquare([60, 120]);
// linear_extrude(100, convexity=2, twist=180, slices=100) halfcirc(r=60);

module quadroctohedron(side) {
    // A weird shape joining two squares rotated by 45 degrees
    h = side/2;
    v = h * sqrt(2);
    polyhedron(points=[
        [-h, -h, -h], [h, -h, -h], [h, h, -h], [-h, h, -h],
        [0, -v, h], [v, 0, h], [0, v, h], [-v, 0, h]
    ], faces=[
        [0, 1, 2, 3],
        [0, 4, 1], [1, 5, 2], [2, 6, 3], [3, 7, 0],
        [1, 4, 5], [2, 5, 6], [3, 6, 7], [0, 7, 4],
        [7, 6, 5, 4],
    ]);
}

module r_hexagon_solid(radius_=0, height=0, side2side=0, r=undef, pos=1) {
    // pos=1 == centres of spheres at corners - complete overlap of hexagon
    // pos=2 == spheres touch corners of hexagon - faces still outside hexagon
    // pos=3 == faces touch edges of hexagon - corners completely within
    assert (height > 0, "Height must be set");
    assert (r != undef, "Corner r must be set");
    assert (!(side2side==0 && radius_==0), "Side2side or radius must be set");
    assert (!(side2side>0 && radius_>0), "Only one of side2side or radius can be set");
    radius = (side2side > 0) ? side2side / sqrt(3) : radius_;  // sin(60) = sqrt(3)/2;
    h_mod = (pos==1 ? 0 : pos==2 ? sin(45)*r : r);
    r_mod = radius - h_mod;
    hull() rotate_distribute(6) union() {
        translate([r_mod, 0, h_mod]) sphere(r);
        translate([r_mod, 0, height-h_mod]) sphere(r);
    }
}

// r_hexagon_solid(25, 50, 5, pos=3);

module r_quadroctahedron(side, r) {
    // A rounded version of the quadroctahedron
}

module hart_puzzle(height, twist=360, diam=100, offset=0.1) difference() {
    // Create a twist-together puzzle in the style of George Hart's
    // original at Thingiverse.  We take the children and subtract a
    // twisted semi-square on the positive X axis, of given diameter
    // and twist.  Make sure that your object is the same height,
    // and is no more than diam from the Z axis at any point.  For
    // best results make sure that:
    // a) the bottom of the object just touches the X axis
    // b) the object is symmetrical around the Z axis
    // c) the overall twist (mod 360) equals the amount of twist that would
    //    make your object equal an inverted copy of itself.  For tetrahedrons
    //    this is 90 degrees, for cubes and octahedra it's 180 degrees. 
    children();
    linear_extrude(height, convexity=6, twist=twist, slices=height)
      translate([-offset, 0, 0]) halfsquare(diam);
}

//hart_puzzle(50.002, twist=360+45)
//translate([0, 0, 25.001]) quadroctohedron(50);

// hart_puzzle(50*sqrt(2), 720, diam=50, offset=+0.1)
// rotate([-45, 0, 90]) translate([0, -25, 0]) hexagon_solid(height=50, side2side=50);
* hart_puzzle(50*sqrt(2), 720, diam=50, offset=+0.1)
rotate([-45, 0, 90]) translate([0, -25, 0])
  r_hexagon_solid(height=50, side2side=50, r=5, pos=2);

$fn=$preview ? 40 : 80;
full_turns = 2; half_turns = 0;
twist = 360*full_turns + 180*half_turns;

* hart_puzzle(100, twist, 100) {
    translate([-50, -50, 0.01]) cube(99.98);
}

height=70;  thick=10;  rad=5;
* hart_puzzle(height, twist, height*1.1) {
    translate([-height/2, 0, 0]) h_r_octahedron_s(height, rad, thick);
}

//translate([0, 0, 100*$t]) rotate([180*$t, 0, 180*(half_turns+1)]) 
//rotate([0, 0, 181]) 
* translate([0, 0, height*$t]) rotate([0, 0, -twist*$t+180]) color("blue")
hart_puzzle(height, twist, height*1.1) {
    // txl(x=-50) r_octahedron_s(100, 2);
    // translate([-50, -50, 0.01]) cube(99.98);
    translate([-height/2, 0, 0]) h_r_octahedron_s(height, rad, thick);
}

cu_sidelen = 50;  cu_thick = 25; // cu_sidelen/5;
hart_puzzle(cu_sidelen * sqrt(2), -twist, cu_sidelen*2, offset=0.5)
  translate([-cu_sidelen/2, 0, ]) hollow_r_cube(cu_sidelen, 3, cu_thick);
