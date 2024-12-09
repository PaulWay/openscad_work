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

module divsquare(vec, stepwidth=1) polygon([
    //each line([0, 0], [0, vec.y], stepwidth=stepwidth),
    //each line([0, vec.y], [vec.x, vec.y], stepwidth=stepwidth),
    //each line([vec.x, vec.y], [vec.x, 0], stepwidth=stepwidth),
    //each line([vec.x, 0], [0, 0], stepwidth=stepwidth)
    each line([0, 0], [0, vec.y], stepwidth=stepwidth),
    [vec.x, vec.y], [vec.x, 0]
]);

//translate([0, 0, 35]) rotate([45, 90, 0]) 
// rotate([40.9, 0, 0]) 
full_twists = 1; half_twists = 1;
twist = full_twists * 360 + half_twists * 180;
difference() {
    // translate([-35, 0, 0.01]) rotate([45, 0, 0]) cube([70, 70, 70]);
    // translate([-50, 0, 0]) tetrahedron(100);
    // translate([0, -50, 0]) rotate([0, 0, 90]) 
    translate([-50, 0, 0]) 
    octahedron_s(100);
    # linear_extrude(100, convexity=6, twist=-twist, slices=200)
      translate([0, -60, 0]) divsquare([70, 120]);
}

module tetrahedron(sidelen) {
    height = sidelen*sin(60);
    width = sidelen/2;
    polyhedron(
        [   [0, 0, 0], [sidelen, 0, 0],
            [width, -width, height], [width, +width, height]],
        [   [0, 2, 1], [0, 1, 3], [0, 3, 2], [1, 2, 3] ]
    );
}

module octahedron_h(height) {
    halflen = sidelen / 2;
    othlen = (sidelen * sin(60)) / 2;
    echo(halflen=halflen, othlen);
    polyhedron(
        [
            [0, 0, 0],
            [-othlen, -othlen, halflen], [-othlen, +othlen, halflen],
            [+othlen, +othlen, halflen], [+othlen, -othlen, halflen],
            [0, 0, sidelen]
        ], [
            [0, 2, 1], [0, 3, 2], [0, 4, 3], [0, 1, 4],
            [5, 1, 2], [5, 2, 3], [5, 3, 4], [5, 4, 1],
        ]
    );
}

module octahedron_s(sidelen) {
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
