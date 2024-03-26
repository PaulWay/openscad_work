openscad_work
=============

**Paul's OpenSCAD models and libraries.**

Hi!  Welcome to my OpenSCAD library.  Please feel free to use any of these
models - they are all licensed under the Creative Commons 4.0 Attribution
Non-Commercial license.  This means you can use it, but if you modify it you
need to name me, and you cannot sell these designs or things based on them.

Most of these models are parameterised - they are based on constants that can
be adjusted.

All models licensed under the Creative Commons 4.0 BY-NC-SA license -
attribution required, share-alike, non-commercial use only.

Primitive and building block libraries
--------------------------------------

These are the basic functions I use for most of my other modelling.

**File: `pwlib_boards.scad`**

Functions to generate cases for PCBs.

**File: `pw_primitives.scad`**

Functions:

 -  `rounded_cube(x, y, z, chamfer_rad)`

**File: `gears.scad`**

A borrowed gears library.  Source: https://github.com/chrisspen/gears

Basic tools
-----------

**File: `vacuum_adaptor.scad`**

For adapting a vacuum hose to an inlet of a different size.

**File: `water_shutoff_handle_v1.scad`**

For putting over the thin metal handle on the shutoff valve on our water
meter, to give better leverage.

Cardboard perforator
--------------------

**File: `cardboard_packing_roller.scad`**

The bits and pieces to construct a machine that can perforate a piece of
standard box cardboard such that it can then be scrunched up and used as
packing for things being sent by post.

Dust extraction
---------------

**File: `cone_adapter.scad`**

An adapter to go from the 100mm PVC pipe I use for my dust extraction system
to Marius Hornberger's excellent flexible (but 90mm) dust extractor parts.

**File: `cyclone_separator_base.scad`**

An attempt at making a cyclonic dust separator in OpenSCAD.  Not very good.

**File: `dust_extractor_adapter.scad`**
**File: `square_to_circle_poly_generator.py`**

The `square_to_circle_poly_generator.py` program generates a `polyhedron` that
smoothly blends a rectangle into a circle across a given height.

The `dust_extractor_adapter.scad` file integrates a basic version of this
with the inlet and outlet parts that would attach to my Carbatec 2HP dust
extractor outlet.

**File: `dust_extractor_rectangular_adapter.scad`**

This is an alternate idea for an outlet adapter for the Carbatec dust
extractor, where the 'pipe' stays rectangular but curves around from vertical
to horizontal in 22.5 or 30 degree steps.

**File: `dust_separator_inlet.scad`**

Another idea for a dust separator, based on the horizontal cyclonic separator
idea.  This would allow the tube from the Carbatec to go into the horizontal
separator tube at 45 degrees, to form the cyclone without extra vanes.

**File: `impeller_basic.scad`**

A basic attempt at designing a compressor impeller in OpenSCAD.

**File: `lathe_extractor_fan_v1.0.scad`**

A fan blades and housing, designed to attach to the housing and drive shaft
of a Vicmarc VL240 lathe.  This adds a modest extra source of dust capture
and movement on the lathe itself, without other equipment.

**File: `spiral_dust_collector_support_slivers_v1.scad`**

Experimenting with parts to support the spiral in a cyclonic separator
replacement for my current inefficient Carbatec separator.

EV Charging
-----------

Parts for holding EV charger connectors and EVSEs.

**File: `charger_cable_holder_v1.scad`**

The basic part for a piece that the base of an EV charger connector could
sit in.

GridFinity tools
----------------

I use the GridFinity reworked OpenSCAD library for actual baseplates and
boxes.  These are the tools I've made to place the magnets in them.

**File: `6x2_magnet_all_in_one.scad`**
**File: `6x2_magnet_dispenser.scad`**
**File: `6x2_magnet_placer_v1.scad`**
**File: `6x2_magnet_placer_v2.scad`**

Oddments
--------

Things I've made that don't really have a good home anywhere else.

**File: `cable_patch_end_clip_v1.scad`**
**File: `cable_patch_end_clip_v2.scad`**

Clips for a 12-port Cat-5 patch bay that don't get in the way of the cables
to be attached.

**File: `cupcake_holder_plate.scad`**
**File: `cupcake_holder.scad`**

Two different systems for pieces that go in a standard food container and
prevent cupcakes or muffins from moving around and destroying themselves when
in transit.

**File: `downpipe_mount.scad`**

A piece that lifts the mount for the downpipe to our eastern water tank up so
that the pipe itself sits higher than the sieve.

**File: `garden_bed_hose_guide.scad`**

A piece that could be printed in two parts that locked together, such that it
could sit on the side of a garden bed wall and guide a hose without kinking.

**File: `organza_bag_funnel.scad`**

A basic funnel, designed for filling the specific organza bags I use to sell
camphor laurel and huon pine shavings.

**File: `red_hat_service_award_holder.scad`**

For those in Red Hat who have received their five and ten year 'puck', this
is a much more stable base for it.  The award won't fall out easily and it
fits it perfectly.  Best printed in red, obviously.

**File: `rob_food_processor_lid.scad`**

A replacement lid for a friend's food processor.

**File: `rounded_square_twist_vase.scad`**

Using the example of the `offset` 2D function and twist in `linear_extrude`
to make some interesting simple vases.  Best with rainbow, bi-colour or
tri-colour filament.

**File: `thundersky_battery_handle_v1.scad`**

A handle to fit on ThunderSky / Winston Energy 60AH LiFePO4 cells, so that
the pack can be lifted as a whole.  Currently contains the `pinch` function
for operating on lists of 2D points.

**File: `tickety_boo_sign.scad`**

For indicating to other people whether everything is tickety-boo or not.

**File: `tile_cutter_anvil.scad`**

A replacement anvil for the tile cutter my partner uses for breaking mosaic
tiles.

**File: `trailer_towball_filler.scad`**

A part that can fit in a trailer towball hitch, and be locked in place, so
that no-one else can tow the trailer.

**File: `trevor table foot v1.0.scad`**

A replacement for a table foot for a friend.

**File: `urban_500_mount.scad`**

A mount for the Urban 500 bicycle light.

PCB cases
---------

Cases I've made for putting various small PCBs in.

**File: `badger_temp_sensor_case.scad`**

For the Badger 2040 W badge with Raspberry Pi 2040 plus eInk screen.

**File: `caberqu C2C tester case.scad`**

For the caberQU C2C USB C cable tester.

**File: `diagonal_box.scad`**

For a board I can't seem to find any more.

**File: `LCA 2021 conference badge case.scad`**

For the LCA 2021 hardware BOF conference badge.  Very incomplete.

**File: `quad_usb_box_base.scad`**
**File: `quad_usb_box.scad`**

The parts for a four-port USB charger board enclosure.

Test pieces
-----------

Mainly used when I'm trying out ideas before I put them in my libraries.

**File: `conduit_angle_bend.scad`**
**File: `conduit_angle_bend_toroidal.scad`**

Work on angled bends that can attach to standard PVC piping.

**File: `spring_tests.scad`**

Testing out both straight and circular 'springs' that use a zig-zag
construction.  Best printed so that each layer goes along the zig-zag, rather
than the zig-zag going up and down across layers.

**File: `tap_handle.scad`**

Experimenting with modules that can make tap handles with a shaft and a
number of 'lobes'.

**File: `y_tube.scad`**

A Y join in a pipe, made out of toroid segments.

Woodworking and workshop tools
------------------------------

**File: `masonry_drill_rack_v1.0.scad`**

A basic block to store the masonry drills I have.

**File: `oscillating_sander_vacuum_adapter.scad`**

An adapter that fits on the side of the AEG oscillating power sander and
directly connects to a vacuum hose for a workshop vacuum cleaner.

**File: `trend_airshield_battery_pack.scad`**

Still early experiments on making a replacement for the Trend AirShield Pro
battery.  The idea is to build in a LiPo pouch cell, a USB charger board, and
possibly a regulated 3.6V output board.

**File: `vicmarc_chuck_gauge_v1.scad`**

Simple pieces that show the inside and outside dimensions of Vicmarc lathe
chuck jaws, at their minimum and maximum extend (i.e. narrowest and widest).
Includes writing the dimensions and the chuck 'number'.
