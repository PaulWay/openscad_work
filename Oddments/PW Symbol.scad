module PW_Symbol() difference() {
    // The interlocking 'PW' symbol used by Paul Wayper.
    // All dimensions are arbitrary and aesthetic.
    // The outside of the PW symbol
    polygon([
        [0, 0], [0.25, 0.75], [0.6, 0.75], [0.6, 1],
        [1, 1], [0.75, 0.25], [0.4, 0.25], [0.4, 0]
    ]);
    // Because the P has an included 'stroke', we cut it out by removing
    // two overlapping pieces - one the back of the P and one the loop
    // around the 
    polygon([
        [0.05, 0.05], [0.30, 0.7], [0.35, 0.7], [0.35, 0.05]
    ]);
    polygon([
        [0.3, 0.7], [0.6, 0.7], [0.6, 0.55], [0.3, 0.5], 
        [0.3, 0.575], [0.5, 0.6], [0.5, 0.65], [0.3, 0.65],
    ]);
    // The inside of the W
    polygon([
        [0.95, 0.95], [0.72, 0.30], [0.4, 0.30], [0.4, 0.47],
        [0.475, 0.48], [0.475, 0.4], [0.525, 0.4], [0.525, 0.49],
        [0.6, 0.5], [0.6, 0.4], [0.65, 0.4], [0.65, 0.95]
    ]);
}

// translate([0, 0, -1]) color("green") cube([10, 10, 1]);
// scale(10) linear_extrude(0.2) PW_Symbol();

module PW_Symbol_square_incised(scale) {
    let(
        x0=0, x1=scale.x*1/8, x2=scale.x*2/8,
        x3=scale.x*3/8, x4=scale.x*4/8, x5=scale.x*5/8,
        x6=scale.x*6/8, x7=scale.x*7/8, x8=scale.x,
        y0=0, y1=scale.y*1/8, y2=scale.y*2/8,
        y3=scale.y*3/8, y4=scale.y*4/8, y5=scale.y*5/8,
        y6=scale.y*6/8, y7=scale.y*7/8, y8=scale.y,
        z0=0, z8=scale.z,
    )
    polyhedron(
        points = [
            // surrounding box - 0, 1, 2, 3 (acw from top)
            [x0, y0, z0], [x8, y0, z0], [x8, y8, z0], [x0, y8, z0],
            // dividing line between P and W - 4, 5, 6, 7
            [x2, y0, z0], [x2, y4, z0], [x6, y4, z0], [x6, y8, z0],
            // middle of P - 8, 9
            [x2, y6, z0], [x4, y6, z0],
            // middle stroke of W - 10, 11
            [x4, y2, z0], [x4, y4, z0],
            // end stroke of W - 12, 6
            [x6, y2, z0],
            // P - 13, 14, 15, 16, 17
            [x1, y1, z8], [x1, y7, z8], [x5, y7, z8], [x5, y5, z8], [x1, y5, z8],
            // W - left down stroke - 18, 19
            [x3, y3, z8], [x3, y1, z8],
            // W - mid down stroke - 20, 21
            [x5, y3, z8], [x5, y1, z8],
            // W -  right up stroke - 22, 23
            [x7, y1, z8], [x7, y7, z8]
        ],
        faces = [
            // back
            [0, 1, 2, 3],
            // P
            [0, 13, 4], [0, 3, 14, 13], [3, 7, 15, 14],
            [7, 6, 16, 15], [6, 5, 17, 16], [5, 4, 13, 17],
            [8, 9, 16, 17], [8, 17, 14], [9, 8, 14, 15], [9, 15, 16],
            // W
            [4, 19, 22, 1], [4, 5, 18, 19], [5, 11, 18], [11, 10, 19, 18],
            [10, 21, 19], [10, 11, 20, 21], [11, 6, 20], [6, 12, 21, 20],
            [7, 23, 22, 12], [7, 2, 23], [2, 1, 22, 23]
        ],
        convexity=6
    );
}

// PW_Symbol_square_incised([10, 10, 1]);