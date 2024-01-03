
module gauge(min_id, min_od, max_id, max_od, jaw_step, height, width, chk_no) {
    // max on x axis so [0,0], [max_od,0], [max_id, width], [0, width],
    // ... but centred on max_od/2
    max_min_offset = (max_od - min_od)/2;
    // these two may be different, because:
    max_jaw = (max_od - max_id)/2;  // is dictated by middle of arc
    min_jaw = (min_od - min_id)/2;  // is dictated by inner jaw
    linear_extrude(height) polygon([
        [0, 0], [max_jaw, 0],
        [max_jaw, jaw_step], [max_od-max_jaw, jaw_step],
        [max_od-max_jaw, 0], [max_od, 0],
        [max_od, jaw_step], [min_od+max_min_offset, width-jaw_step],
        [min_od+max_min_offset, width], [min_od+max_min_offset-min_jaw, width],
        [min_od+max_min_offset-min_jaw, width-jaw_step], [max_min_offset+min_jaw, width-jaw_step],
        [max_min_offset+min_jaw, width], [max_min_offset, width],
        [max_min_offset, width-jaw_step], [0, jaw_step],
    ]);
    translate([max_od/2, width-(jaw_step+1), height-0.01]) linear_extrude(1) text(
        str("Min: ID ", min_id, " OD ", min_od), size=4.5,
        font="Liberation Sans:style=Regular",
        halign="center", valign="top"
    );
    translate([max_od/2, jaw_step+1, height-0.01]) linear_extrude(1) text(
        str("Max: ID ", max_id, " OD ", max_od), size=5,
        font="Liberation Sans:style=Regular",
        halign="center", valign="bottom"
    );
    translate([max_od/2, width/2, height-0.01]) linear_extrude(1) text(
        str("Chuck ", chk_no, " (pw)"), size=5,
        font="Noto Serif:style=Regular",
        halign="center", valign="center"
    );
}

// gauge(33, 45, 73, 85, 6, 5, 40, 2);
// gauge(41, 53, 76, 92, 6, 5, 40, 3);
// gauge(73, 83, 103, 127, 6, 5, 40, 4);
// gauge(110, 127, 148, 177, 6, 5, 40, 5);
gauge(150, 172, 188, 220, 6, 5, 40, 6);