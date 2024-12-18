include <../libs/pw_primitives.scad>;

band_inner_d = 67.2;  band_outer_d = 70;  top_chamfer_d = 64;
top_chamfer = (top_chamfer_d - band_outer_d)/2;
top_height = 21.6;  band_chamfer_h = 19.4;  band_height = 12;  band_raise = 5;
neck_inner_d = 60.5;  screw_inner_d = 58.5;  screw_d = (neck_inner_d+screw_inner_d)/2;
screw_h = 19;  screw_inset_h = 3;
seal_retain_od = 49; seal_retain_id = 45;  seal_retain_h = 3;

module screw(height, inner_d, outer_d, turns=0, thread_h=0, flip=false) {
    assert (!(turns == 0 && thread_h == 0), "Must set either turns or thread_h");
    assert ((turns > 0 && thread_h > 0), "Only set one of turns or thread_h");
    turns = (thread_h > 0) ? height/thread_h : turns;
    screw_d = (inner_d+outer_d)/2;  screw_offset = outer_d - inner_d;
    mirror([flip?1:0, 0, 0]) linear_extrude(height, twist=turns*360)
      translate([screw_offset/4, 0, 0]) circle(d=screw_d);
};

// test thread
// mirror([0, 0, -1]) difference() {
//     cylinder(d=band_inner_d, h=10);
//     txl(z=-0.01) screw(screw_h, screw_inner_d, neck_inner_d, thread_h=4);
// }
$fn=$preview ? 60 : 120;
// translated and mirrored because I modelled this as if it was sitting on the flask.
txl(z=top_height) mirror([0, 0, -1]) 
difference() {
    // The basic outer shape
    chamfered_cylinder(
      top_height, d=top_chamfer_d, chamfer=top_chamfer, bot_chamfer=false);
    // The band for the outer silicone grip ring
    txl(z=band_raise) pipe_rt(
        height=band_height, radius=band_outer_d/2+0.01, thickness=1);
    // a chamfer so we don't have to print with supports
    txl(z=band_raise-0.99) hollow_cone_rt(
        1, band_outer_d/2+1.01, band_outer_d/2+0.01, thickness=1);
    translate([0, 0, -0.01]) difference() {
        union() {
            // The screw plus internal body
            screw(screw_h, screw_inner_d, neck_inner_d, thread_h=4);
            // initial inset for the base
            cylinder(h=screw_inset_h, d=neck_inner_d);
        }
        // the silicone seal ring retainer - removed from the internal cutout
        translate([0, 0, screw_h-seal_retain_h+0.01]) union () {
            pipe_oi(seal_retain_h, seal_retain_od/2, seal_retain_id/2);
            pipe_oi(seal_retain_h, neck_inner_d/2, screw_inner_d/2);
        }
    }
}