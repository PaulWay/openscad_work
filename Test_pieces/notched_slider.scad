body_len = 40;  body_wid = 20;  body_thick = 2;

slider_len = 50;  slider_wid = 10;  slider_thick = 4;
slider_notch_every = 5;

tab_len = 25;  tab_wid = slider_wid;  tab_x_off = 5;
tab_sep_wid = 2;
tab_cut_len = tab_len + tab_sep_wid;  tab_cut_wid = tab_wid + tab_sep_wid * 2;
tab_y_off = (body_wid - tab_cut_wid) / 2;
tab_block_z = 2;  tab_block_mode = "cyl";

$fn = $preview ? 20 : 40;

if (tab_block_mode == "cyl") {
    translate([tab_x_off + tab_len - tab_block_z, tab_y_off + tab_sep_wid, body_thick])
    rotate([-90, 0, 0]) cylinder(h=tab_wid, r=tab_block_z);
}

linear_extrude(body_thick) difference() {
    square([body_len, body_wid]);
    translate([tab_x_off, tab_y_off]) difference() {
        square([tab_cut_len, tab_cut_wid]);
        translate([0, tab_sep_wid]) square([tab_len, tab_wid]);
    }
}

