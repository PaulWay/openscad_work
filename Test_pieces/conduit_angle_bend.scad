include <../libs/pw_primitives.scad>;

bend_angle = 45;
thickness = 3;
// bend_radius = 150;
// pipe_dia = 56;
bend_radius = 250;
pipe_dia = 160;
pipe_radius = (pipe_dia)/2;
join_length = 40;
overlap_len = 5;

translate([-(80-51)/2-11.5, 30, 0]) conduit_angle_bend(
    80, 52/2, 45, 2, 30,
    join_a=true, join_b=true, flare_a=false, flare_b=true
);

$fa=5;
//////////////////////////////////////////////////////////////
// Tests to see that all ends of the conduit_angle_bend are in
// the right places, angles and sizes.
//////////////////////////////////////////////////////////////

module one_group(flare_a, flare_b, curved_a, curved_b) union() {
    x_off = (flare_a ? 300 : 0) + (curved_a ? 600 : 0);
    y_off = (flare_b ? 250 : 0) + (curved_b ? 500 : 0);
    translate([x_off+  0, y_off+180, 0]) linear_extrude(5) text(
        str("flare_a ", (flare_a?"yes":"no"), ", flare_b ", (flare_b?"yes":"no"),
        ", curved_a ", (curved_a?"yes":"no"), ", curved_b ", (curved_b?"yes":"no")
        ), size=7
    );
    if (!(flare_a || flare_b || curved_a || curved_b)) {
    translate([x_off+  0, y_off+  0, 0]) conduit_angle_bend(100, 30, 45, 3, 10,
        join_a=false, join_b=false, flare_a=flare_a, flare_b=flare_b,
        curved_a=curved_a, curved_b=curved_b);}
    if (!(flare_b || curved_b)) {
    translate([x_off+100, y_off+  0, 0]) conduit_angle_bend(100, 30, 45, 3, 10,
        join_a=true, join_b=false, flare_a=flare_a, flare_b=flare_b,
        curved_a=curved_a, curved_b=curved_b);}
    if (!(flare_a || curved_a)) {
    translate([x_off+  0, y_off+100, 0]) conduit_angle_bend(100, 30, 45, 3, 10,
        join_a=false, join_b=true, flare_a=flare_a, flare_b=flare_b,
        curved_a=curved_a, curved_b=curved_b);}
    translate([x_off+100, y_off+100, 0]) conduit_angle_bend(100, 30, 45, 3, 10,
        join_a=true, join_b=true, flare_a=flare_a, flare_b=flare_b,
        curved_a=curved_a, curved_b=curved_b);
}

* union() {
    one_group(false, false, false, false);
    one_group(true, false, false, false);
    one_group(false, true, false, false);
    one_group(true, true, false, false);
    one_group(false, false, true, false);
    one_group(true, false, true, false);
    one_group(false, true, true, false);
    one_group(true, true, true, false);
    one_group(false, false, false, true);
    one_group(true, false, false, true);
    one_group(false, true, false, true);
    one_group(true, true, false, true);
    one_group(false, false, true, true);
    one_group(true, false, true, true);
    one_group(false, true, true, true);
    one_group(true, true, true, true);
}