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
    base_len, base_wid, base_high, side_thick, side_high, overlap_wid,
    type="open", margin=0.2
) {
    /*
     * The top of the collector to fit on the base above.
     * The type argument controls how the 'top' area is designed:
     * - 'open' = just an area with vertical sides.
     * - 'ridged' = a series of ridges along the longer axis
     * - 'diamond' = a series of diamonds
     * All of the types except 'open' try to make a collector that can be
     * printed top down with no supports.
     */
    side_wid = overlap_wid + margin;
    full_len = base_len + side_wid*2;
    full_wid = base_wid + side_wid*2;
    // The main base, cutout underneath
    difference() {
        cube([full_len, full_wid, overlap_wid + side_high]);
        translate([side_wid, side_wid, -epsilon])
          cube([base_len, base_wid, overlap_wid]);
    }
    // Then the top:
    if (type=="open") translate([odifference() {
        
    }
}

// mirror([0, 0, 1]) filings_collector_base(80, 60, 5, 18, 5, 5, 3);
filings_collector_top(80, 60, 5, 3, 4, 2);