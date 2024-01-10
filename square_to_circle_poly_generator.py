import math


def trap_sin(alpha):
    """
    The trapezoid equivalent of the sin() function (in degrees).
    """
    alpha = (360+alpha if alpha < 0 else alpha) % 360  # convert to 0-360 range
    if alpha < 45:
        return alpha / 45
    elif alpha >= 45 and alpha < 135:
        return 1
    elif alpha >= 135 and alpha < 225:
        return (180-alpha) / 45
    elif alpha >= 225 and alpha < 315:
        return -1
    elif alpha >= 315:
        return (alpha-360) / 45


def trap_cos(alpha):
    return trap_sin(alpha+90)


def circ_sin(alpha):
    return math.sin(alpha/180*math.pi)

def circ_cos(alpha):
    return math.cos(alpha/180*math.pi)


def interpolate(x1, y1, z1, x2, y2, z2, layers=2):
    dx = x2 - x1
    dy = y2 - y1
    dz = z2 - z1
    for i in range(layers):
        frac = i / (layers - 1)
        yield (x1 + dx * frac, y1 + dy * frac, z1 + dz * frac)


def points_at_angle(angle, height, thickness, circ_diam, sq_x, sq_y, layers=2):
    """
    The cross-section through the circle-square dougnnut at this angle.
    This kid of converts the polar coordinates in circular and manhattan
    geometries into x-y in the regular cartesian plane.  The square is on the
    X-Y plane and the circle is height above it.  'layers' is the number of
    horizontal subdivisions between the top and bottom points that 'smooth
    out' the transition from square to circle, using linear interpolation.
    (Otherwise, because the rectangle between top and bottom is actually
    divided into two triangles, the face can look somewhat serrated.)
    """
    c_sin_r = circ_sin(angle) * circ_diam/2
    c_cos_r = circ_cos(angle) * circ_diam/2
    c_sin_rt = circ_sin(angle) * (circ_diam/2+thickness)
    c_cos_rt = circ_cos(angle) * (circ_diam/2+thickness)
    t_sin_x = trap_sin(angle) * sq_x/2
    t_cos_y = trap_cos(angle) * sq_y/2
    t_sin_xt = trap_sin(angle) * (sq_x/2+thickness)
    t_cos_yt = trap_cos(angle) * (sq_y/2+thickness)

    # outer bottom band to outer top band (inclusive)
    for pt in interpolate(t_sin_xt, t_cos_yt, 0, c_sin_rt, c_cos_rt, height, layers):
        yield pt
    # inner top band to inner bottom band (inclusive)
    for pt in interpolate(c_sin_r,  c_cos_r, height, t_sin_x,  t_cos_y, 0, layers):
        yield pt


def face_for_division(division, divisions, layers=2):
    """
    The face definitions for this 'division' of the square-to-circle pipe.
    We take advantage of the fact that the points are laid out in 'bands'
    around the pipe; the bottom inner band is 0 .. (divisions-1), the bottom
    outer band is divisions .. (divisions*2-1), and so forth.  We connect:
    - the layers between the bottom and top outer bands,
    - the top outer band to the top inner band,
    - the (descending) layers between the top and bottom inner bands, and
    - the bottom inner band to the bottom outer band,
    We also take advantage of the fact that if this division is the last, it
    'wraps around' to the zeroeth division.
    """
    bands = layers * 2
    def point(a, b):
        return ((a + division) * bands + b) % (divisions*bands)
    # Each face has to be iterated clockwise from the perspective of someone
    # outside the pipe looking into that face.
    for i in range(bands):
        ni = (i + 1) % bands
        yield (point(0, i), point(1, i), point(1, ni), point(0, ni))


def polyhedron(height, thickness, circ_diam, sq_x, sq_y, divisions, layers=2):
    """
    Generate the polyhedron definition for a circle-to-square pipe,
    combining the definition of all the points and the definition of all the
    faces.
    """
    points = []
    faces = []
    for division in range(divisions):
        angle = 360 / divisions * division
        for point_t in points_at_angle(angle, height, thickness, circ_diam, sq_x, sq_y, layers):
            points.append(point_t)
        for faces_t in face_for_division(division, divisions, layers):
            faces.append(faces_t)
    def point_str(pt, i):
        return '    [' + ', '.join(f"{coord:8.4f}" for coord in pt) + f'],  // point {i}\n'
    def face_str(ft, i):
        return '    [' + ', '.join(f"{coord:3d}" for coord in ft) + f'],  // face {i}\n'
    points_str = '[\n' + ''.join(point_str(pt, i) for i, pt in enumerate(points)) + ']'
    faces_str = '[\n' + ''.join(face_str(ft, i) for i, ft in enumerate(faces)) + ']'
    print(f"polyhedron({points_str}, {faces_str});\n")


polyhedron(100, 5, 150, 120, 150, 90, layers=20)
