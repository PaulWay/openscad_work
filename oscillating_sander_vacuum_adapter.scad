module torus(outer, inner) 
    rotate_extrude() {
        translate([outer-inner, 0, 0]) circle(r=inner);
    }

module pipe_rt(height, radius, thickness)
    difference() {
        cylinder(height, radius, radius);
        translate([0, 0, -0.05]) cylinder(height+0.1, radius - thickness, radius - thickness);
    }

module pipe_oi(height, o_radius, i_radius)
    difference() {
        cylinder(h=height, r=o_radius);
        translate([0, 0, -0.05]) cylinder(h=height+0.1, r=i_radius);
    }

module cone_rt(height, bottom_radius, top_radius, thickness)
    difference() {
        cylinder(height, bottom_radius, top_radius);
        translate([0, 0, -0.05]) 
          cylinder(height+0.1, bottom_radius - thickness, top_radius - thickness);
    }

module cone_oi(height, bottom_o_radius, top_o_radius, bottom_i_radius, top_i_radius)
    difference() {
        cylinder(height, bottom_o_radius, top_o_radius);
        translate([0, 0, -0.05]) 
          cylinder(height+0.1, bottom_i_radius, top_i_radius);
    }

// AEG sander fitting diameters
d1=34.25; r1=d1/2;
d2=37.4;  r2=d2/2;
d3=55.0;  r3=d3/2;
d4=60.5;  r4=d4/2;
d5=64.5;  r5=d5/2;
d6=68.75; r6=d6/2;
// AEG sander fitting lengths
l1=6.1;
l2=11.5;
l3=15.0;
l4=20.0;
l5=30.0;
twist=1; // set to -1 for other direction
// Derived fitting measurements
t1=r2-r1;   // Thickness of wall
br=2.5;     // Locking ball radius
ba=15;      // Locking ball channel angle
// Hose attachment diameters
dhi=34; rhi=dhi/2; 
dho=38; rho=dho/2;
spike_thick=1;  // Extra protrusion of 'spike' holding hose in place.
halen=30;
// Middle measurements
midlen=30;

$fn=64;
// AEG fitting
module aeg_hose_fitting_fitting() {
    translate([0, 0, halen+midlen]) union() {
        pipe_oi(l5, r2+t1, r2);
        // pipe_oi(3, r4, r2+t1);
        difference() {
            pipe_oi(l4, r6, r4);
            // +x side
            translate([0, 0, l2]) rotate([0, 0, 0]) union() {
                translate([r4, 0, 0]) cylinder(h=l4-l2+0.1,r=br);
                translate([r4, 0, 0]) sphere(r=br);
                rotate_extrude(angle=ba*twist) { translate([r4, 0, 0]) circle(r=br); }
                rotate([0, 0, ba*twist]) translate([r4, 0, 0]) sphere(r=br);
            }
            // -x side
            translate([0, 0, l2]) rotate([0, 0, 180]) union() {
                translate([r4, 0, 0]) cylinder(h=l4-l2+0.1,r=br);
                translate([r4, 0, 0]) sphere(r=br);
                rotate_extrude(angle=ba*twist) { translate([r4, 0, 0]) circle(r=br); }
                rotate([0, 0, ba*twist]) translate([r4, 0, 0]) sphere(r=br);
            }
        }
    }
    // Hose fitting
    cone_oi(halen/2, rho, rho+spike_thick, rhi, rhi);
    translate([0, 0, halen/2]) pipe_oi(halen/2, rho, rhi);
    // Middle
    translate([0, 0, halen]) cone_oi(midlen, rho, r6, rhi, r2);
}

module shopvac_silicone_hose_fitting() {
    translate([0, 0, 60]) cone_oi(30, 57, 56.5, 50, 54);
    translate([0, 0, 30]) cone_oi(30, 53, 57, 44, 50);
    translate([0, 0, 0]) cone_oi(30, 49, 53, 46, 44);
}

shopvac_silicone_hose_fitting();