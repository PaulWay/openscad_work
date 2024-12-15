module block_profile(block, side_indent_frac=0.5, both_sides=false) {
    // The 'silhouette' of the block profile on one side, that we can use in
    // linear and rotational extrusions.
    // The profile is divided into four heights - from the base it's flat on
    // the side to a quarter height, then the side indent is placed at half
    // height, then the side is rounded from three quarters onto the top.
    // both_sides=false:
    //  ___
    // |   \
    // |   (
    // |___|
    // both_sides=true:
    //   ______
    //  /      \
    //  )      (
    //  |______|
    assert(side_indent_frac > 0, "side_indent_frac must be greater than zero");
    assert(side_indent_frac <= 1, "side_indent_frac must not be greater than one");
    top_cir_rad = block.z/4;
    side_cir_rad = block.z/2;
    side_cir_x = block.z-side_cir_rad*side_indent_frac;
    if (both_sides) {
    } else {
        difference() {
            union() {
                square([block.x/2-top_cir_rad, block.z]);
                square([block.x/2, block.z-top_cir_rad]);
                translate([block.x/2-top_cir_rad, block.z-top_cir_rad])
                  circle(r=top_cir_rad);
            }
            translate([side_cir_x, side_cir_rad])
              circle(r=side_cir_rad)
        }
    }
}

module blocking_magnet(block, magnet) {
    // A magnet for blocking fabric, crochet and knitting on a metal base.
    // The block has a flat base, an indent around the middle, and a curved
    // top.  This is achieved by
}

