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


def points_at_angle(angle, height, thickness, circ_diam, sq_x, sq_y):
    """
    The cross-section through the circle-square dougnnut at this angle.
    This kid of converts the polar coordinates in circular and manhattan
    geometries into x-y in the regular cartesian plane.  The square is on the
    X-Y plane and the circle is height above it.
    """
    c_sin_r = circ_sin(angle) * circ_diam/2
    c_cos_r = circ_cos(angle) * circ_diam/2
    c_sin_rt = circ_sin(angle) * (circ_diam/2+thickness)
    c_cos_rt = circ_cos(angle) * (circ_diam/2+thickness)
    t_sin_x = trap_sin(angle) * sq_x/2
    t_cos_y = trap_cos(angle) * sq_y/2
    t_sin_xt = trap_sin(angle) * (sq_x/2+thickness)
    t_cos_yt = trap_cos(angle) * (sq_y/2+thickness)

    return (
        (t_sin_x,  t_cos_y, 0),
        (t_sin_xt, t_cos_yt, 0),
        (c_sin_rt, c_cos_rt, height),
        (c_sin_r,  c_cos_r, height),
    )

def face_for_division(division, divisions):
    """
    The face definitions for this 'division' of the square-to-circle pipe.
    We take advantage of the fact that the points are laid out in 'bands'
    around the pipe; the bottom inner band is 0 .. (divisions-1), the bottom
    outer band is divisions .. (divisions*2-1), and so forth.  We connect:
    - the bottom inner band to the bottom outer band,
    - the bottom outer band to the top outer band,
    - the top outer band to the top inner band, and
    - the top inner band to the bottom inner band.
    We also take advantage of the fact that if this division is the last, it
    'wraps around' to the zeroeth division.
    """
    def point(a, b):
        return ((a + division) * 4 + b) % (divisions*4)
    # Each face has to be iterated clockwise from the perspective of someone
    # outside the pipe looking into that face.
    return (
        # bottom face
        (point(0, 0), point(1, 0), point(1, 1), point(0, 1)),
        # outer face
        (point(0, 1), point(1, 1), point(1, 2), point(0, 2)),
        # top face
        (point(0, 2), point(1, 2), point(1, 3), point(0, 3)),
        # inner face
        (point(0, 3), point(1, 3), point(1, 0), point(0, 0)),
    )


def polyhedron(height, thickness, circ_diam, sq_x, sq_y, divisions):
    """
    Generate the polyhedron definition for a circle-to-square pipe,
    combining the definition of all the points and the definition of all the
    faces.
    """
    points = []
    faces = []
    for division in range(divisions):
        angle = 360 / divisions * division
        for point_t in points_at_angle(angle, height, thickness, circ_diam, sq_x, sq_y):
            points.append(point_t)
        for faces_t in face_for_division(division, divisions):
            faces.append(faces_t)
    def point_str(pt, i):
        return '    [' + ', '.join(f"{coord:8.4f}" for coord in pt) + f'],  // point {i}\n'
    def face_str(ft, i):
        return '    [' + ', '.join(f"{coord:3d}" for coord in ft) + f'],  // face {i}\n'
    points_str = '[\n' + ''.join(point_str(pt, i) for i, pt in enumerate(points)) + ']'
    faces_str = '[\n' + ''.join(face_str(ft, i) for i, ft in enumerate(faces)) + ']'
    print(f"polyhedron({points_str}, {faces_str});\n")


polyhedron(100, 5, 150, 120, 150, 90)
