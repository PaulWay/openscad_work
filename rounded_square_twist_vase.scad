base_height = 5;
vase_height = 60;
twist = 45;
base_angle=(base_height*twist)/vase_height;

translate([0, 0, base_height]) 
  linear_extrude(height = vase_height, twist = twist, slices = vase_height) {
    difference() {
       offset(r = 10) {
           square(20, center = true);
       }
       offset(r = 8) {
          square(20, center = true);
       }
    }
 }
 rotate([0, 0, base_angle]) 
   linear_extrude(height=base_height, twist=base_angle, slices=base_height) { 
     offset(r=10) { square(20, center=true); };
 }