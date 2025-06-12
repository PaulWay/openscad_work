module filings_collector_base(
    base_len, base_wid, base_high, magnet_len, magnet_wid, magnet_high, magnet_sep,
) {
    /*
     * The base for the filings collector, which sits under the Robert Sorby
     * sharpening system.  This has the magnets, and the cover (below) catches
     * the filings and can then be removed easily.
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
    magnet_x = (orientation == "NS" ? magnet_wid : magnet_len);
    magnet_y = (orientation == "NS" ? magnet_len : magnet_wid);
    magnet_xstep = (orientation == "NS" ? magnet_wstep : magnet_lstep);
    magnet_ystep = (orientation == "NS" ? magnet_lstep : magnet_wstep);
    // The offset has to not include the last 'fencepost gap'; because of this
    // there is always an offset in both directions.
    magnet_xnum = floor(base_len / magnet_xstep);
    magnet_ynum = floor(base_wid / magnet_ystep);
    magnet_xoff = (base_len - (magnet_xnum * magnet_xstep - magnet_sep)) / 2;
    magnet_yoff = (base_wid - (magnet_ynum * magnet_ystep - magnet_sep)) / 2;
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

module filings_collector

mirror([0, 0, 1]) filings_collector_base(80, 60, 5, 20, 5, 5, 3);