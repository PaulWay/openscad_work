// include <../libs/pw_primitives.scad>;

$fn=45;

eps = 0.01; eps2 = eps*2;
tol = 0.2;
magnet_wid = 6; magnet_height = 2;
body_wid = 15; body_len = 100; body_height = 10;
feeder_tube_height = 20; feeder_tube_wid = 12;
pusher_wid = magnet_wid;
pusher_chan_wid = magnet_wid + tol*2; pusher_chan_x = (body_wid-magnet_wid)/2-tol;
pusher_chan_height = magnet_height + tol*2; pusher_chan_z = 4;
end_slot_height = 1; end_slot_len = 10;
bot_angle = 30; bot_len = body_height/sin(bot_angle);
diag_front_x_off = (body_len-bot_len)+(body_height*sin(bot_angle))/2+tol;
washer_dia = 10; washer_height = 1; washer_z_off = 1;

// pegs at the corners of a box from -x,-y to x,y
module pegs(x, y, r, h) {
    translate([ x,  y, 0]) cylinder(r=r, h=h);
    translate([-x,  y, 0]) cylinder(r=r, h=h);
    translate([ x, -y, 0]) cylinder(r=r, h=h);
    translate([-x, -y, 0]) cylinder(r=r, h=h);
}

difference() {
    // the body
    union() {
        cube([body_wid, body_len-bot_len, body_height]);
        translate([body_wid/2, 70, body_height-eps])
          cylinder(h=feeder_tube_height, d=feeder_tube_wid);
    };
    // the feeder tube;
    translate([body_wid/2, 70, pusher_chan_z+eps]) 
      cylinder(h=feeder_tube_height+body_height, d=magnet_wid+tol*2);
    // the tube for the pusher
    translate([pusher_chan_x, -eps, pusher_chan_z]) 
      cube([pusher_chan_wid, body_len+eps2, pusher_chan_height+eps2]);
    // the channel for the pusher finger handle
    
    // the bottom angle
    // multmatrix([ 
    //   [1, 0, 0, -eps], 
    //   [0, 1, 0, (body_len-bot_len)+eps], 
    //   [0, sin(bot_angle), 1, -body_height] 
    // ]) union() {
}

translate([-30, body_height, 0]) rotate([90, 0, 0]) difference() {
    cube([body_wid, bot_len, body_height]);
    // the feeder tube
    translate([pusher_chan_x, -eps, pusher_chan_z]) 
      cube([pusher_chan_wid, body_len+eps2, pusher_chan_height+eps2]);
    // the stuff on an angle
    translate([-eps, (body_height*sin(bot_angle))/2+tol, 0]) rotate([bot_angle, 0, 0]) union() {
        // the main face
        translate([0, 0, -body_height]) cube([body_wid+eps2, bot_len, body_height]);
        // the slot to the magnet placer hole
        translate([pusher_chan_x, bot_len*(pusher_chan_z/body_height), -eps])
          hull() {
            translate([pusher_chan_wid/2, end_slot_len, 0]) 
              cylinder(h=end_slot_height, d=pusher_chan_wid);
            cube([pusher_chan_wid, 1, end_slot_height]);
        }
        // the slot for the washer
        translate([body_wid/2, 5+end_slot_len, washer_z_off+end_slot_height]) hull() {
            cylinder(h=washer_height, d=washer_dia);
            translate([0, washer_dia/2, 0]) cylinder(h=washer_height, d=washer_dia);
        }
    }
};

translate([30, 0, 0]) union() {
    difference() {
        cube([6, 100, 2]);
        translate([6/2, 100, -eps]) cylinder(h=2+eps2, d=6);
    };
}