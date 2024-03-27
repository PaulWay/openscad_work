side_inner = 110;  side_outer = 113.5;
side_in_rad = side_inner / 2;  side_out_rad = side_outer / 2;
clearance = 20;
// 'width' = X, 'height/depth' = Y, 'up' = Z
side_in_height = 14.4; side_out_height = 10;  top_out_height = 9;
side_depth = side_in_height + top_out_height;

side_low_thick = 3;  side_top_thick = 5; 
handle_mid_thick = 3;  handle_end_thick = 5;
handle_height = 25 + clearance;  handle_up = 25;

function pinch_n(n, m, o, s) = n + (m-o)*s*(n==0?1:n/abs(n));

function pinch_vec(points, origin, slope) = [
    for(point = points)
    [pinch_n(point.x, point.y, origin.y, slope.x), pinch_n(point.y, point.x, origin.x, slope.y)]
];

// Designed to be centred.  Easier calculations?  More obvious?
handle_pts = [
    // Inside right
    [side_in_rad, -side_depth],
    [side_in_rad, -side_depth+side_in_height], [side_out_rad, -side_depth+side_in_height],
    [side_out_rad, 0], [side_in_rad, 0], [side_in_rad, handle_height],
    // Mid, under handle
    [0, handle_height],
    // Inside left
    [-side_in_rad, handle_height], [-side_in_rad, 0], [-side_out_rad, 0],
    [-side_out_rad, -side_depth+side_in_height], [-side_in_rad, -side_depth+side_in_height],
    [-side_in_rad, -side_depth],
    // Outside left
    [-side_out_rad-side_low_thick, -side_depth],
    [-side_out_rad-handle_end_thick, handle_height+handle_mid_thick],
    // Mid, over handle
    [0, handle_height+handle_mid_thick],
    // Back to the outside right
    [side_out_rad+handle_end_thick, handle_height+handle_mid_thick],
    [side_out_rad+side_low_thick, -side_depth]
];

linear_extrude(handle_up) {
    polygon(pinch_vec(handle_pts, [0, handle_height], [0.05, 0]));
}

translate([0, handle_height+handle_mid_thick/2, handle_up/2]) scale([1, 0.4, 1]) 
  rotate([0, 90, 0]) cylinder(h=side_inner, d=handle_up, center=true);