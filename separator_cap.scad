include <pw_primitives.scad>;

ols = 100; // Outlet long side
oss = 50; // Outlet short side
oh = 100; // Outlet height
thick = 5;  // wall thickness
// Rotations by 45 degree shorten the side by 1/sqrt(2) or ~ 0.70711

ang_shorten = 1/sqrt(2);
ols_45 = ols * ang_shorten;
oss_45 = oss * ang_shorten;
outlet_rotation = [0, 90, 0];
outlet_translation = [0, 0, ols];

* union() {
    translate(outlet_translation) rotate(outlet_rotation) 
        hollow_cube(ols, oss, oh, thick);
    
    difference() {
        union() {
            hollow_cone_rt(
                height=ols_45,
                bottom_radius=ols_45+oss_45, 
                top_radius=oss_45, 
                thickness=thick*sqrt(2)
            );
            translate([0, 0, ols_45]) cylinder(
                h=thick, r1=oss_45, r2=oss_45-thick);
        }
        translate(outlet_translation) rotate(outlet_rotation) cube([ols, oss, oh]);
    }
}

difference() {
    translate([0, 0, 0]) rotate([0, 0, -45]) hollow_cube(ols, oss, oh, thick);
    # translate([0, -ols_45, ols_45+oss_45]) rotate([0, 90, 0])
      cylinder(h=ols, r=ols_45+oss_45);
}