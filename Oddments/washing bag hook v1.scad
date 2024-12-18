include <../libs/pw_primitives.scad>;

hook_height = 30;
hook_thick = 15;
inner_rad = 13;  chamfer_rad = 5;
short_end_len = 30;
long_end_len = 50;
loop_holder_len = 30;
loop_holder_wid = 5;
loop_holder_height = 12;
loop_holder_offset = 2;
loop_chamfer = 1.5;

outer_hook_len = inner_rad+hook_thick;
loop_height = (hook_height+loop_holder_height)/2;
loop_end_y = -long_end_len+chamfer_rad-loop_chamfer;
join_height = (hook_height-loop_holder_height)/2;

$fn=40;
// the actual bend
chamfered_rectangular_torus(inner_rad+hook_thick, inner_rad, hook_height, chamfer_rad, angle=180);
// the short end
translate([-(hook_thick+inner_rad), -(short_end_len-epsilon), hook_height]) rotate([-90, 0, 0])
  rounded_box(hook_thick, hook_height, short_end_len, chamfer_rad);
// the long end
translate([+(inner_rad), -(long_end_len-epsilon), hook_height]) rotate([-90, 0, 0])
  rounded_box(hook_thick, hook_height, long_end_len, chamfer_rad);
// the outer bulge to catch the hook bit
translate([outer_hook_len+loop_holder_offset, loop_end_y-loop_chamfer, loop_height+loop_chamfer])
  rotate([-90, 0, 0])
  rounded_box(loop_holder_wid+loop_chamfer, loop_holder_height+loop_chamfer*2,
    loop_holder_len+loop_chamfer*2, loop_chamfer, remove_top_face=false);
// the join between loop and hook
translate([outer_hook_len-1, loop_end_y, loop_height]) rotate([0, 90, 0])
  filleted_cube(loop_holder_height, loop_holder_len, loop_holder_offset+2, loop_chamfer);