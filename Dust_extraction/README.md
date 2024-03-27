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

