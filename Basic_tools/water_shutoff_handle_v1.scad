epsilon = 0.01; epislo2 = epsilon*2;
slot_width = 5;
slot_length = 63;
slot_height = 18;
slot_offset = 5;
circle_height = 3;
circle_width = 12;
circle_offset = 0;
base_width = 15;
base_length = 120;
pivot_off_handle = 0;
pivot_off_base = 5;
base_off_x = (base_length-(slot_length+pivot_off_base));
handle_dia = 25;
handle_len = base_length;
handle_off_x = (handle_len-(slot_length-pivot_off_handle));
handle_off_z = handle_dia/2;

difference() {
    union() {
        translate([0, -base_width/2, 0]) cube([base_length, base_width, slot_height]);
        translate([0, 0, handle_off_z]) rotate([0, 90, 0])
          cylinder(h=handle_len, d=handle_dia);
    }
    translate([slot_offset, -slot_width/2, -epsilon])
      cube([slot_length, slot_width, slot_height]);
    translate([circle_offset, 0, -epsilon]) cylinder(h=circle_height, d=circle_width);
}