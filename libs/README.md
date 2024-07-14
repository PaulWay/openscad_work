Primitive and building block libraries
--------------------------------------

These are the basic functions I use for most of my other modelling.

**File: `pwlib_boards.scad`**

Functions to generate cases for PCBs.

**File: `pw_funcs.scad`**

Functions:

- `dovetail_outer(x, y, spread, thick, clear=0.0, leftward=true)`
  - Generates a list of points for a linear_extruded polygon that forms the
    'outside' of a dovetail joint.
  - `x`, `y` - total size of the joint
  - `thick` - the thickness of the walls at the back of the dovetail
  - `spread` - the distance 'in' from each side the 'mouth' of the dovetail
    goes.  If `spread` is zero, there is no angle to the dovetail and it
    becomes a finger joint.
  - `clear` is the clearance (see below).
- `dovetail_inner(x, y, spread, thick, clear=0.0, leftward=true)`
  - Generates a list of points for a linear_extruded polygon that forms the
    'inside' of a dovetail joint of the given dimensions.  `clear` is the
    amount of clearance on each part - when `clear` is zero, they fit
    exactly; if set to 1 there would be 1mm of clearance between dovetail and
    outer.
- `arith_spiral(start_rad, end_rad, steps, angle=360)`
  - Generates a list of points that forms an arithmetic spiral - i.e. a fixed
    distance between arcs of the spiral.  This is only one side - you need to
    wrap this in with other points to form a 'solid' polygon that can be
    extruded.  Points start on the X axis and the arc goes anti-clockwise from
    there - you can make the angle negative to go in the other direction.  The
    start can be larger or smaller than the end.
  - `start_rad` - the radius distance from the centre at the start of the spiral
  - `end_rad` - the radius distance from the centre at the end of the spiral
  - `steps` - number of steps - a bit like the $fn parameter.
  - `angle` - total arc covered.  This can be greater than 360 if you want
    multiple revolutions of the spiral.

**File: `pw_primitives.scad`**

The basic modules I use to base a lot of my other modelling on.

Modules:

- **Arrangers**
  - `txl(x=0, y=0, z=0)`
    - an abbreviated translate, usually if you just want to move in one axis
  - `rot(x=0, y=0, z=0)`
    - an abbreviated rotate, usually if you just want to rotate about one axis
  - `hex_distribute(num_x, num_y, diameter)`
    - arrange children in a hexagonal lattice.  Every alternate Y row is
      offset by half the diameter, and the rows are offset such that the
      centres are always `diameter` apart (i.e. the distance in the Y axis
      between rows is `diameter*sin(60)`).
    - `num_x` - the number of children in the X direction
    - `num_y` - the number of children in the Y direction
    - `diameter` - the distance between each centre.
  - `rotate_distribute(number, angle=360, last_fencepost=false)`
    - arrange children by rotating them by successive increments.  Only the
      rotation is done; children must be translated off the origin in order to
      be in different positions.
  - `linear_distribute(start, step, end, tvec = [1, 0, 0])`
    - Distribute children in a for loop, but multiplying the translation
      vector `tvec` by the loop value.
- **Simple cubic modules**
  - `rounded_box(length, width, height, outer_r)`
  - `module rounded_box(length, width, height, outer_r)`
  - `module chamfered_cube(x, y, z, side, chamfer_x=true, chamfer_y=true, chamfer_z=true)`
  - `module rounded_cube(x, y, z, chamfer_rad)`
  - `module hexahedron(corners, convexity=1)`
- **Rings and Cones**
  - `cylinder_outer(h, d=undef, r=undef)`
  - `cylinder_mid(h, d=undef, r=undef)`
  - `circle_outer(d=undef, r=undef)`
  - `circle_mid(d=undef, r=undef)`
  - `chamfered_cylinder(height, d=undef, r=undef, chamfer=0)`
  - `ellipse(x, y)`
  - `ellipsoid(x, y, height)`
  - `elliptical_pipe(x, y, height, thick)`
  - `pipe_rt(height, radius, thickness)`
  - `pipe_oi(height, o_radius, i_radius)`
  - `hollow_cone_rt(height, bottom_radius, top_radius, thickness)`
  - `hollow_cone_oi(height, o_bot_radius, i_bot_radius, o_top_radius, i_top_radius)`
- **Cylinder segments**
  - `half_cylinder(height, radius)`
  - `cylinder_segment(height, radius, angle=360)`
  - `pipe_rt_segment(radius, thickness, height, angle)`
- **Toroids and pipe bends**
  - `torus(outer, inner, x_stretch=1, angle=360)`
  - `toroidal_pipe(bend_radius, pipe_i_radius, thickness, angle=360)`
  - `quarter_torus_bend_snub_end(outer_rad, width, angle, outer=true)`
  - `conduit_angle_bend(bend_radius, pipe_radius, bend_angle, thickness,
    join_length, join_radius=undef,
    join_a=true, join_b=true, flare_a=true, flare_b=true,
    curved_a=false, curved_b=false)`
- **Rectangular tubes and toroids**
  - `rectangular_pipe(width, height, thickness, length)`
  - `rectangular_tube(x, y, thickness, height)`
  - `rectangular_cone(x1, y1, x2, y2, height)`
  - `rectangular_torus(outer, inner, height, angle=360)`
  - `rectangular_pipe_bend_basic(width, height, thickness, inner_radius, bend_angle)`
  - `rectangular_pipe_bend(
    width, height, thickness, inner_radius, bend_angle, join_length,
    overlap_len, join_a=true, join_b=true, flare_a=true, flare_b=true,
    curved_a=false, curved_b=false
    )`
    - A curved rectangular pipe, rotating around the Z axis so X=width and
      Z=height.  This can produce straight or curved join segments at either
      end ('a' is the end at the XZ plane, 'b' is the other), either flared
      (i.e. accepting a pipe of this width and height) or not.
- **Springs**
  - `coil_spring(spring_r, wire_r, rise_per_rev, turns, step_deg)`
  - `flat_spring(length, width, height, gap_length, segments)`
  - `rect_circ_spring(in_radius, out_radius, angle, segments, height, thickness)`
- **Bolt shapes**
  - `countersunk_bolt_hole(shaft_d, shaft_len, head_d, head_len)`
  - `flat_head_bolt_hole(shaft_d, shaft_len, head_d, head_len)`
- **Triangles**
  - `equ_triangle(side)`
    - An equilateral triangle, with one point on the origin and one side along
      the X axis.
  - `arb_triangle(ab, bc, ac)`
    - An arbitrary triangle, given three side lengths.  Point A is at the
      origin, and point B is along the X axis (i.e. at `(ab, 0)`).  Point C
      has its X and Y coordinates calculated.
- **Hexagons**
  - `hexagon(radius)`
    - A 2D hexagon
  - `hexagon_solid(radius, height)`
    - A `linear_extrude`d hexagon.
  - `tapered_hexagon(radius1, radius2, height)`
    - A hexagon that goes from radius1 to radius2 as it goes up.

**File: `gears.scad`**

A borrowed gears library.  Source: https://github.com/chrisspen/gears

