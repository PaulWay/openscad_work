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
    side_cir_rad = (block.z-top_cir_rad)/2;
    side_cir_x = block.y+side_cir_rad*(1-side_indent_frac);
    if (both_sides) {
        difference() {
            translate([-block.y/2, 0, 0]) union() {
                translate([top_cir_rad, 0]) 
                  square([block.y-top_cir_rad*2, block.z]);
                square([block.y, block.z-top_cir_rad]);
                translate([top_cir_rad, block.z-top_cir_rad])
                  circle(r=top_cir_rad);
                translate([block.y-top_cir_rad, block.z-top_cir_rad])
                  circle(r=top_cir_rad);
            }
            translate([side_cir_x/2, side_cir_rad])
              circle(r=side_cir_rad);
            translate([-side_cir_x/2, side_cir_rad])
              circle(r=side_cir_rad);
        }
    } else {
        difference() {
            union() {
                square([block.y/2-top_cir_rad, block.z]);
                square([block.y/2, block.z-top_cir_rad]);
                translate([block.y/2-top_cir_rad, block.z-top_cir_rad])
                  circle(r=top_cir_rad);
            }
            translate([side_cir_x/2, side_cir_rad])
              circle(r=side_cir_rad);
        }
    }
}

$fn = $preview ? 45 : 90; 
block = [40, 20, 10];
magnet = [18, 5, 5];
side_indent_frac = 0.1;

module blocking_magnet(block, magnet, side_indent_frac=0.2) difference() {
    // A magnet for blocking fabric, crochet and knitting on a metal base.
    // The block has a flat base, an indent around the middle, and a curved
    // top.  This is achieved by
    mid_width = block.x - block.y;
    assert(mid_width>0, "Block must be longer than wide");
    assert(block.x>magnet.x, "Block X must be longer than magnet");
    assert(block.y>magnet.y, "Block Y must be wider than magnet");
    assert(block.z>magnet.z, "Block Z must be higher than magnet");
    assert(side_indent_frac>0, "Side must have some indent (> 0)");
    assert(side_indent_frac<0.5, "Side indent must not overhang (< 0.5)");
    rotate([0, 0, 90]) union() {
        translate([0, mid_width/2, 0]) rotate_extrude(angle=180)
          block_profile(block, side_indent_frac);
        translate([0, mid_width/2, 0]) rotate([90, 0, 0])
          linear_extrude(mid_width, convexity=2)
          block_profile(block, side_indent_frac, both_sides=true);
        translate([0, -mid_width/2, 0]) rotate([0, 0, 180]) rotate_extrude(angle=180)
          block_profile(block, side_indent_frac);
    }
    translate([0, 0, magnet.z/2 - 0.01])
        cube(magnet, center=true);
};

blocking_magnet(block, magnet, side_indent_frac);