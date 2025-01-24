Test pieces
-----------

Mainly used when I'm trying out ideas before I put them in my libraries.

**File: `arch_inner.scad`**

A module to produce a 2D 'gothic' curved arch given a height and width; used
for linear extrusion.

**File: `conduit_angle_bend.scad`**
**File: `conduit_angle_bend_toroidal.scad`**

Work on angled bends that can attach to standard PVC piping.  Now basically
uses the `conduit_angle_bend` module from `libs/pw_primitives.scad`.

**File: `cylinder_from_to.scad`**

Testing being able to create a cylinder from and to two arbitrary XYZ
locations.  This is useful for forming cylindrical lattices and other
shapes formed of linked cylinders that are not easily defined in terms
of their rotations or translations in relation to each-other.

**File: `decorative_arcs.scad**`

The ideas for a utility library for putting decorative patterns on the outside
of objects, or for inscribing them into objects.  Make your objects look
nicer and distinctive!

**File: `pulley.scad`**

Ideas for creating pulleys and blocks.

**File: `shredder_blade.scad`**

Tests for constructing a shredder blade in plastic.

**File: `spring_tests.scad`**

Testing out both straight and circular 'springs' that use a zig-zag
construction.  Best printed so that each layer goes along the zig-zag, rather
than the zig-zag going up and down across layers.

**File: `tap_handle.scad`**

Experimenting with modules that can make tap handles with a shaft and a
number of 'lobes'.

**File: `y_tube.scad`**

Two 'Y' joins for pipes:

- `tube_y(diameter, thickness, height, separation)`
  - A Y join in a pipe, made out of toroid segments.  This joins one pipe
    (on the XY plane) of outer `diameter` with two pipes that are `height`
    above the XY plane and are `separation` apart (i.e. the minimum distance
    between the two circles, not distance between centres).  The pipe walls
    are of `thickness`.
  - This is for use when you care about reducing the friction and turbulence
    but where the air velocities will be different.
- `straight_y_tube(single_dia, duple_dia, thickness, height, separation)`
  - A Y join in a pipe, made out of sheared cylinders.  Similar to the
    `tube_y` above, this joins one pipe of outer diameter `single_dia` on the
    XY plane with two that are of diameter `duple_dia` and `height` above the
    XY plane, `separation` apart.  The pipe walls are of `thickness`.
  - This is for where you care about maintaining the air velocity but don't
    care so much about friction or turbulence.

This also works up the modules:

- `bendy_y(diameter, height, separation)`
  - The solid version of the `tube_y` module.
- `cylinder_xyzs(x1, y1, x2, y2, height, r)`
  - A cylinder of radius `r` whose bottom and top are parallel to the XY
    plane but sheared to go from `[x1, y1, 0]` to `[x2, y2, height]`.
  - Recently moved to `libs/pw_primitives.scad`
- `cone_xyzs(x1, y1, x2, y2, height, r1, r2)`
  - A cone of bottom radius `r1` and top radius `r2`, sheared to go from
    `[x1, y1, 0]` to `[x2, y2, height]`.
