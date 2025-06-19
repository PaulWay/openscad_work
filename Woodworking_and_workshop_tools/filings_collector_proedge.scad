include <../libs/pw_primitives.scad>;

module filings_collector_base(
    base_len, base_wid, base_high, magnet_len, magnet_wid, magnet_high, magnet_sep,
    margin=0.2
) {
    /*
     * The base for the filings collector, which sits under the Robert Sorby
     * sharpening system.  This has the magnets, and the cover (below) catches
     * the filings and can then be removed easily.  The margin allows for some
     * leeway getting the magnets into the base.
     */
    assert(base_high >= magnet_high, "base must not be lower than magnet height");
    // Which orientation is going to hold more magnets?
    magnet_lstep = magnet_len+magnet_sep;  magnet_wstep = magnet_wid+magnet_sep;
    // SW = magnet length goes in X, width goes in Y
    // NS = magnet length goes in Y, width goes in X
    orientation = (
        floor(base_len/magnet_lstep) * floor(base_wid/magnet_wstep) >
        floor(base_len/magnet_wstep) * floor(base_wid/magnet_lstep)
    ) ? "EW" : "NS";
    // Now set up our variables for the chosen orientation.
    magnet_x = (orientation == "NS" ? magnet_wid : magnet_len) + margin;
    magnet_y = (orientation == "NS" ? magnet_len : magnet_wid) + margin;
    magnet_xstep = (orientation == "NS" ? magnet_wstep : magnet_lstep);
    magnet_ystep = (orientation == "NS" ? magnet_lstep : magnet_wstep);
    // The offset has to not include the last 'fencepost gap'; because of this
    // there is always an offset in both directions.
    magnet_xnum = floor(base_len / magnet_xstep);
    magnet_ynum = floor(base_wid / magnet_ystep);
    magnet_xoff = (base_len - (magnet_xnum * magnet_xstep - magnet_sep)) / 2 - margin;
    magnet_yoff = (base_wid - (magnet_ynum * magnet_ystep - magnet_sep)) / 2 - margin;
    echo(orientation=orientation, magnet_xnum=magnet_xnum, magnet_ynum=magnet_ynum);
    echo(magnet_xoff=magnet_xoff, magnet_yoff=magnet_yoff);
    difference() {
        cube([base_len, base_wid, base_high]);
        translate([magnet_xoff, magnet_yoff, -0.01]) union() {
            for (xpos = [0:magnet_xnum-1]) {
                for (ypos = [0:magnet_ynum-1]) {
                    translate([xpos*magnet_xstep, ypos*magnet_ystep, 0])
                      cube([magnet_x, magnet_y, magnet_high]);
                }
            }
        }
    }
}

module filings_collector_top(
    base_len, base_wid, height, side_thick, under_high, top_high,
    side_type="straight", fill_type="none", margin=0.2
) {
    /*
     * The top of the collector to fit on the base above.
     * This is actually larger than the 'base' it fits on, by side_thick plus
     * margin on each side.
     * The side_type argument controls the sides' profile:
     * - 'straight' = vertical sides.
     * - 'diag' = sides sloping out.
     * - 'rdiag' = sides sloping in.
     * - 'ridged' = a series of ridges along the longer axis
     * - 'diamond' = a series of diamonds
     * All of the types except 'open' try to make a collector that can be
     * printed top down with no supports.
     */
    assert(height > under_high + top_high, "Must be taller than undercut + wall height");
    // The main base, cutout underneath
    base_high = height - top_high;
    under_len = base_len + margin*2;
    under_wid = base_wid + margin*2;
    full_len = under_len + side_thick*2;
    full_wid = under_wid + side_thick*2;
    mid_len = base_len + side_thick*2;
    mid_wid = base_wid + side_thick*2;
    difference() {
        cube([full_len, full_wid, base_high]);
        translate([side_thick, side_thick, -epsilon])
          cube([under_len, under_wid, under_high+epsilon]);
    }
    // Then the sides:
    txl(z=base_high-epsilon)  // put all tops on top of the base
    if (side_type=="straight")
      linear_extrude(top_high, convexity=4) difference() {
        square([full_len, full_wid]);
        txl(x=side_thick, y=side_thick) square([mid_len, mid_wid]);
    }
    else if (side_type=="diag") difference() {
        cube([full_len, full_wid, top_high]);
        hull() {
            txl(x=side_thick, y=side_thick) cube([mid_len, mid_wid, 1]);
            txl(z=side_high+epsilon) cube([full_len, full_wid, 1]);
        }
    }
    else if (side_type=="rdiag") difference() {
        cube([full_len, full_wid, top_high]);
        // base thickness is half of top thickness
        rmid_len = full_len - side_thick;  rmid_wid = full_wid - side_thick;
        hull() {
            translate([side_thick/2, side_thick/2, -1+epsilon])
              cube([rmid_len, rmid_wid, 1]);
            translate([side_thick, side_thick, top_high+epsilon])
              cube([base_len, base_wid, 1]);
        }
    }
    // Then the fill
    if (fill_type=="ridges") {
    }
}

// mirror([0, 0, 1]) filings_collector_base(80, 60, 5, 18, 5, 5, 3);
filings_collector_top(80, 60, 10, 4, 2, 5, side_type="rdiag");