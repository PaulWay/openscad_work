$fn = 32;

blade_thick =  2;

cylinder(h=50, r1=20, r2=5);
cylinder(h=40, r1=30, r2=7.5);
cylinder(h=30, r1=40, r2=10);
cylinder(h=20, r1=50, r2=12.5);

for (a=[0:40:360]) {
    rotate([-10, 0, a]) translate([0, -10, -1]) difference() {
        cube([80, blade_thick, 50]);
        translate([70, -0.01, 70]) rotate([-90, 0, 0]) 
          cylinder(h=blade_thick + 0.02, r=50);
    }
}