function between_pts(pt1, pt2, steps=2) =
    assert(steps>1, "There must be at least two steps")
    [
        let(stop=steps-1, step=(pt2-pt1)/stop)
        for(i=[0:stop]) [pt1.x+step.x*i, pt1.y+step.y*i, pt1.z+step.z*i]
    ];

$fn=10;

function circle_list(r, height, steps=$fn) = [
    for(i=[0:steps-1]) [r*cos(360*i/steps), r*sin(360*i/steps), height]
];
// for(pt=circle_list(10, 0)) translate(pt) sphere(1);

function trap_sin(angle) = (
    // The trapezoidal sine function only distributes points evenly for
    // squares.  When used on a rectangle it generates the same number
    // of points on the short and long sides.
    let(angl_ = ((angle<0) ? 360-(-angle) : angle)%360)
    (angl_ < 45) ? angl_/45 :
    (angl_ < 135) ? 1 :
    (angl_ < 225) ? (180-angl_)/45 :
    (angl_ < 315) ? -1 :
                    (angl_-360)/45
);
function trap_cos(angle) = trap_sin(angle+90);

function man_sin(angle, x, y) = (
    // The true Manhattan sine function takes into account the angle
    // from the origin to x,y - not sure how to explain this.
    let(
        angl_ = ((angle<0) ? 360-(-angle) : angle)%360,
        break_angle = atan2(y, x)
    )
    (angl_ < break_angle) ? angl_/break_angle :
    (angl_ < (180 - break_angle)) ? 1 :
    (angl_ < (180 + break_angle)) ? (180-angl_)/break_angle :
    (angl_ < (360 - break_angle)) ? -1 :
                          (angl_-360)/break_angle
);
function man_cos(angle, x, y) = man_sin(angle+90, y, x);

function rectangle_list(x, y, height, steps=$fn) = [
    // for(i=[0:steps-1]) [x*trap_cos(360*i/steps), y*trap_sin(360*i/steps), height]
    for(i=[0:steps-1]) [x*man_cos(360*i/steps, x, y), y*man_sin(360*i/steps, x, y), height]
];

// for(pt=rectangle_list(160, 120, 1, steps=97*2)) translate(pt) color("green") sphere(1);

function band_points(band, bands, steps) = [
    let(all_steps=bands*steps, bandsm1 = bands-1)
    // def face_for_division(division, divisions, layers=2):
    // def point(a, b):
    //     return ((a + division) * bands + b) % (divisions*bands)
    // # Each face has to be iterated clockwise from the perspective of someone
    // # outside the pipe looking into that face.
    // for i in range(bands):
    //     ni = (i + 1) % bands
    //     yield (point(0, i), point(1, i), point(1, ni), point(0, ni))
    //    [0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 4, 0, 7],
    each for(i=[0:steps*2-1]) [
        let(
            base=band*bands,
            ni = (i+1) % bandsm1,
            bs = bandsm1
        )
        [base+i, base+ni, base+(bs+ni), base+bs+i]
    ]
];
echo(bpoints=band_points(0, 5, 2));
echo(bpoints=band_points(1, 5, 2));

module polygon_ring_constructor(
    outer_1, outer_2, inner_2, inner_1, steps=2, interpolate_flats=false
) {
    // The exact meaning of each list, and whether points in 'outer' lists
    // are 'outside' points in 'inner' lists, isn't important; but points
    // in element I of the four lists in the given order MUST form a 
    listlen = len(outer_1);
    assert(len(outer_2)==listlen, "Outer list 2 must be the same length as outer list 1");
    assert(len(inner_2)==listlen, "Inner list 2 must be the same length as outer list 1");
    assert(len(inner_1)==listlen, "Inner list 1 must be the same length as outer list 1");
    points = [ for(i=[0:listlen-1]) each [
        each between_pts(outer_1[i], outer_2[i], steps),
        if(interpolate_flats)
            each between_pts(outer_2[i], inner_2[i], steps),
        each between_pts(inner_2[i], inner_1[i], steps),
        if(interpolate_flats)
            each between_pts(inner_1[i], outer_1[i], steps),
    ]];
    for(pt=outer_1) translate(pt) color("red") sphere(1);
    for(pt=outer_2) translate(pt) color("yellow") sphere(1);
    for(pt=inner_2) translate(pt) color("green") sphere(1);
    for(pt=inner_1) translate(pt) color("blue") sphere(1);
    faces = [
        // [0, 1, 2, 3], [4, 5, 6, 7],
        // [0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 0, 4, 7],
        // [49*4+0, 49*4+1, 1, 0],
        // for(i=[0:listlen-1]) each band_points(i, steps, listlen)
        // each band_points(0, listlen, steps),
        // each band_points(1, listlen, steps),
        [5, 6, 10, 9], [6, 7, 11, 10], [7, 8, 12, 11], [8, 5, 9, 12]
    ];
    // echo(points=points);
    polyhedron(points=points, faces=faces);
}

steps=5; height=50;
polygon_ring_constructor(
    //rectangle_list(120+3, 160+3, 0, steps=steps),
    // rectangle_list(120, 160, 0, steps=steps),
    circle_list(140, 0, steps=steps),
    circle_list(140+3, 0, steps=steps),
    circle_list(150+3, height, steps=steps),
    circle_list(150, height, steps=steps)
);
