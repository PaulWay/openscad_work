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
    // warning: always increments, i.e. goes anti-clockwise
    for(ang=[from_a:fn():to_a]) [r*cos(ang), r*sin(ang)]
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

module r_tetrahedron(sidelen, r) {
    // Like a tetrahedron but using a hull to get rounded corners.
    height = sidelen*sin(60);
    width = sidelen/2;
    hull() {
        translate([0, 0, 0]) sphere(r);
        translate([sidelen, 0, 0]) sphere(r);
        translate([width, -width, height]) sphere(r);
        translate([width, +width, height]) sphere(r);
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

module h_r_octahedron_s(sidelen, r, thick) difference() {
    assert(sidelen>thick*2, "Side must be bigger than thickness");
    r_octahedron_s(sidelen, r);
    translate([thick, 0, thick]) r_octahedron_s(sidelen-thick*2, r);
}

// rot(x=-45) rot(y=-45) 
* octahedron_s(100);

//     linear_extrude(100, convexity=6, twist=twist, slices=200)
//       translate([0, -60, 0]) divsquare([60, 120]);
// linear_extrude(100, convexity=2, twist=180, slices=100) halfcirc(r=60);

module hart_puzzle(height, twist=360, diam=100, offset=1) difference() {
    // Create a twist-together puzzle in the style of George Hart's
    // original at Thingiverse.  We take the children and subtract a
    // twisted semi-square on the positive X axis, of given diameter
    // and twist.  Make sure that your object is the same height,
    // and is no more than diam from the Z axis at any point.  For
    // best results
    children();
    translate([-offset, 0, 0])
      linear_extrude(height, convexity=6, twist=twist, slices=height)
      halfsquare(diam);
}

$fn=$preview ? 40 : 80;
full_turns = 1; half_turns = 1;
twist = 360*full_turns + 180*half_turns;
//difference() {
    // translate([-35, 0, 0.01]) rotate([45, 0, 0]) cube([70, 70, 70]);
    // translate([-50, 0, 2]) minkowski() {
    //     tetrahedron(98);
    //     sphere(2);
    // }
//    sidelen = (100*sqrt(2)/2);
//    rot(x=45) translate([2-sidelen/2, 2, 2]) minkowski() {
//        cube(sidelen-4);
//        $fn=30; sphere(2);
//    }
    // txl(x=-50) octahedron_s(100);
    // txl(x=-50) r_octahedron_s(100, 2);
* hart_puzzle(100, twist, 100) {
    translate([-50, -50, 0.01]) cube(99.98);
}

height=70;  thick=10;  rad=5;
hart_puzzle(height, twist, height*1.1) {
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
