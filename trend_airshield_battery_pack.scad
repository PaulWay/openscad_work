body_length=78;
body_width=58;
body_height=26.1;
body_fillet_radius=9.5;
base_width=71;
base_thick=2.2;
step_width=63.7;
step_thick=5;  // from bottom, not from top of base

// base
cube([body_length, base_width, base_thick]);
// step
translate([0, (base_width-step_width)/2, base_thick]) 
  cube([body_length, step_width, step_thick]);
// body
translate([0, (base_width-body_width)/2, base_thick]) hull() {
    # cube([body_length, body_width, body_height-body_fillet_radius]);
    // note that if body_fillet_radius*2 > body_height, cylinder will
    // stick out below body and we have no fix for that right now.
    translate([0, body_fillet_radius, body_height-body_fillet_radius])
      rotate([0, 90, 0]) cylinder(h=body_length, r=body_fillet_radius);
    translate([0, body_width-body_fillet_radius, body_height-body_fillet_radius])
      rotate([0, 90, 0]) cylinder(h=body_length, r=body_fillet_radius);
}
