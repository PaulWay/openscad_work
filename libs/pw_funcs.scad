////////////////////////////////////////////////////////////////////////////////
// Internal utility functions
////////////////////////////////////////////////////////////////////////////////

function fn() = (
    $fn>0 ? ($fn>=3?$fn:3) : ceil(max(min(360/$fa,$fs),5))
);

////////////////////////////////////////////////////////////////////////////////
// Parabolas
////////////////////////////////////////////////////////////////////////////////

function pos_parabola(max_x, min_x=0, a=1, b=0, c=0) = [
    // calculate a positive parabola from x=0 to x=max_x, of the formula
    // a*x^2 + b*x + c.
    for(x=[min_x:max_x]) [x, a*x^2 + b*x + c]
];

    // calculating points via constant length steps, not constant x:
    //} else {
        // (xn-x)^2 + (yn-y)^2 = 1
        // (xn-x)^2 + ((a*xn^2+b^xn+c)-(a*x^2+b^x+c))^2 = 1
        // (xn-x)^2 + (a*(xn^2-x^2)+b(xn-x))^2=1
        // Is this the right way?
        // for(x=0; x <= max_x; x)
    //}

////////////////////////////////////////////////////////////////////////////////
// Knurling maker
////////////////////////////////////////////////////////////////////////////////

function knurl_points(grooves, inner_r, outer_r, flats=false) = [
    // Makes a set of grooves in a circle, going between two radii.
    // Use this in something like:
    // linear_extrude(100, twist=360, convexity=2)
    //   polygon(points=knurl_points(10, 17, 20));
    // Then to get a set of grooves going the other way, intersect that with a
    // linear_extrude in the opposite direction.  For a smoother outer surface,
    // union them together rather than intersection.
    // if flats=true, the top and bottom are flat rather than v-shape.
    let (step = 360/(grooves*(flats ? 4 : 2)))
    for (pt = [0:grooves*(flats ? 4 : 2)])
        let (rad = (flats ? (pt % 4 < 2) : (pt % 2 == 0)) ? inner_r : outer_r)
        [rad * cos(pt*step), rad * sin(pt*step)]
];

////////////////////////////////////////////////////////////////////////////////
// Dovetail joint makers
////////////////////////////////////////////////////////////////////////////////

function dovetail_outer(x, y, spread, thick, clear=0.0, leftward=true) =
    // Generates a list of points for a linear_extrude which generates a
    // dovetail.  'leftward=true' has the opening on the left and the
    // taper 'pointing' left, false to the right (eventually).  Sometimes
    // you want the outer to clear a dovetail - in this case increase the
    // 'clear' parameter.
    assert(thick+spread*2 < y)
    let(ch=clear/2)
    let(x0 = leftward ? 0 : x, x1 = leftward ? x-thick+ch : thick-ch, x2 = leftward ? x : 0)
[
    [x0, 0], [x2, 0], [x2, y], [x0, y], // the back
    [x0, y-(thick+spread)+ch], [x1, y-thick+ch], // into the upper jaw
    [x1, thick-ch], [x0, thick+spread-ch], // down to the lower jaw
    [x0, 0] // and home again
];


function dovetail_inner(x, y, spread, thick, clear=0.0, leftward=true) =
    // Generates the 'inside' of a dovetail with the same dimensions.
    // This will *exactly* match dovetail_outer - usually you want to
    // add some clearance or tolerance.  This is provided in the handy
    // 'clear' parameter - this is definitely the tolerance along the
    // 'front' of the tail and the back of the opening, but probably a
    // bit more on the sides of the tail.
    let(ch=clear/2)
    let(x0 = leftward ? 0 : x, x1 = leftward ? x-thick-ch : thick+ch)
[
    [x0, thick+spread+ch], [x1, thick+ch],
    [x1, y-thick-ch], [x0, y-(thick+spread)-ch]
];

////////////////////////////////////////////////////////////////////////////////
// Spiral generators
////////////////////////////////////////////////////////////////////////////////

function arith_spiral(start_rad, end_rad, steps, angle=360) = [
    let (rad_inc = end_rad-start_rad)
    for (i=[0:steps-1])  let (fract = i/(steps-1))
    [
        (start_rad+rad_inc*fract)*cos(angle*fract),
        (start_rad+rad_inc*fract)*sin(angle*fract)
    ],
];

function geom_spiral(start_rad, end_rad, steps, angle=360) = [
    // A geometric spiral, starting at `start_rad` away from the
    // origin along the X axis, and rotating clockwise out to
    // `end_rad` through `steps` equal-angle steps from zero to
    // `angle`.
    let (
        sm1 = steps-1,
        rad_diff = end_rad-start_rad+1,
        pow_frac = rad_diff^(1/sm1)
    )
    for (i=[0:sm1])  let (fract = i/sm1)
    [
        (start_rad-1+pow_frac^i)*cos(angle*fract),
        (start_rad-1+pow_frac^i)*sin(angle*fract)
    ],
];

////////////////////////////////////////////////////////////////////////////////
// Linear functions
////////////////////////////////////////////////////////////////////////////////

function line(from, to, steps=undef, stepwidth=undef) = [
    // two dimensional line, with wiggle.
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

////////////////////////////////////////////////////////////////////////////////
// Polar functions
////////////////////////////////////////////////////////////////////////////////

// Translate a list of points from [r, theta] into [x, y]
function polar_to_cart(points) = [
    for (point = points)
    [point[0]*cos(point[1]), point[0]*sin(point[1])]
];

// 'Scale' a list of polar coordinate points.  The first value of the scale
// vector will scale the points inward or outward; the second will multiply
// their rotation around the Z axis from the X axis (zero degrees).  NOTE:
// Use negative theta scale values to reverse the direction of an arc.
function p_scale(points, scale_vec) = [
    for (point = points)
    [point[0]*scale_vec[0], point[1]*scale_vec[1]]
];

// 'Translate' a list of polar coordinate points.  The first value of the
// translation vector will move all points outward or inward by this much,
// and the second value will add to or subtract from their rotation around
// the Z axis.
function p_translate(points, trans_vec) = [
    for (point = points)
    [point[0]+trans_vec[0], point[1]+trans_vec[1]]
];

// Draw an arc in polar coordinates, at constant r distance from the origin,
// of a particular theta length from the X axis.  The arc is divided into
// a number of steps, either by the given value or the $fn or $fa values,
// so that it can be translated back into cartesian coordinates.  Because of
// the test in the for loop, this can only generate a set of points that go
// anti-clockwise.  If you want them to go clockwise instead, use p_scale()
// with a negative theta.
function p_arc(r, arc_len, steps=0) = [
    let (arc_frac=(steps>0) ? arc_len/steps : fn())
    for (theta=[0:arc_frac:arc_len]) [r, theta]
];

// An arc from arbitrary from and to angle - works going both anti-clockwise
// and clockwise (i.e. arc_to can be LESS than arc_from).
function p_arc_ft(r, arc_from, arc_to, steps=0) = 
let (
    diff = (arc_to-arc_from),
    arc_frac=diff/( (steps>0) ? steps : (abs(diff)/360)*fn() )
)
[
    for (theta=[arc_from:arc_frac:arc_to]) [r, theta]
];

function p_arcline(r1, r2, arc_len, steps=0) = 
let (
    stepsm1 = ((steps>0) ? steps : arc_len/fn()) - 1,
    arc_frac = arc_len/stepsm1,
    r_frac = (r2-r1)/stepsm1
)
[
    for (step=[0:stepsm1]) [r1+r_frac*step, arc_frac*step]
];

function p_arcline_ft(r1, r2, arc_from, arc_to, steps=0) = 
let (
    stepsm1 = ((steps>0) ? steps : (arc_to-arc_from)/fn()) - 1,
    arc_frac = (arc_to-arc_from)/stepsm1,
    r_frac = (r2-r1)/stepsm1
)
[
    for (step=[0:stepsm1]) [r1+r_frac*step, arc_from+arc_frac*step]
];

function p_radline(r1, r2, theta, steps=undef, stepwidth=undef) = 
let(
    diff=r2-r1,
    steps_ = (steps==undef ? (
        stepwidth==undef ? fn() : diff / stepwidth
    ) : steps),
    inc=diff/steps_
)
[ for(step=[0:steps_])
    [r1 + inc*step + wiggle(step), theta]
];

////////////////////////////////////////////////////////////////////////////////
// Point manipulation functions
////////////////////////////////////////////////////////////////////////////////

function wiggle(step) = (step%2 == 0) ? 0 : 0.001;

function invert(points, x=false, y=false, z=false) = [
    let(xfac = (x ? -1 : 1), yfac = (y ? -1 : 1), zfac = (z ? -1 : 1))
    for(point = points) [point.x*xfac, point.y*yfac, point.z*zfac]
];
