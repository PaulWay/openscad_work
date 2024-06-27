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
    for (i=[0:steps-1])  let (fract = i/(steps-1))
    [
        (start_rad+(end_rad-start_rad)*fract)*sin(angle*fract),
        (start_rad+(end_rad-start_rad)*fract)*cos(angle*fract)
    ],
];

////////////////////////////////////////////////////////////////////////////////
// Polar functions
////////////////////////////////////////////////////////////////////////////////

// Translate a list of points from [r, theta] into [x, y]
function polar_to_cart(points) = [
    for (point = points)
    echo(point)
    [point[0]*sin(point[1]), point[0]*cos(point[1])]
];

// 'Scale' a list of polar coordinate points.  The first value will
// move the points inward or outward; the second will multiply their rotation
// the Z axis from the X axis (zero degrees).
function p_scale(points, scale_vec) = [
    for (point = points)
    [point[0]*scale_vec[0], point[1]*scale_vec[1]]
];

// Draw an arc in polar coordinates, at constant r distance from the origin,
// of a particular theta length from the X axis.  The arc is divided into
// a number of steps, either by the given value or the $fn or $fa values,
// so that it can be translated back into cartesian coordinates.
function p_arc(r, arc_len, steps=0) = [
    let (arc_frac=(steps>0) ? arc_len/steps : ($fn > 0) ? (360/$fn) : $fa)
    for (theta=0; theta <= arc_len; theta = theta + arc_frac) [r, theta]
];
