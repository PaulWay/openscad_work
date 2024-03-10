offset = 215/3;  centre = offset/2;  corner_rad = 20;
cupcake_dia = 60;  thick=2;
// edge_off = ((centre*sqrt(2) - (corner_rad * sqrt(2) - corner_rad)) - (cupcake_dia/2))/2;
// echo("edge_off", edge_off);
edge_off = 10.2;

leg_base_dia = min(12, edge_off*2);  leg_top_dia = 5;  leg_height = 15 - thick;

x_num = 3;
y_num = 2;

module rounded_plate(length, width, height, radius) {
    dia = radius*2;
    minkowski() {
        cylinder(h=height/3, r=radius);
        translate([radius, radius, 0]) cube([length-dia, width-dia, 2*height/3]);
    }
};

function edge_offset(n, n_num, off) = (n == 0 ? off : 0) - (n == n_num ? off : 0);

edge_legs_only = false;
$fn = 45;
union() {
    difference() {
        rounded_plate(x_num * offset, y_num * offset, thick, corner_rad);
        // cutouts for cupcakes
        for (x = [0:x_num-1]) {
            for (y = [0:y_num-1]) {
                x_off = x * offset + centre;
                y_off = y * offset + centre;
                translate([x_off, y_off, -0.01]) cylinder(d=cupcake_dia, h=thick+0.02);
            };
        };
    }
    // legs for support
    for (x = [0:(edge_legs_only ? x_num : 1):x_num]) {
        for (y = [0:(edge_legs_only ? y_num : 1):y_num]) {
            x_off = x * offset + edge_offset(x, x_num, edge_off);
            y_off = y * offset + edge_offset(y, y_num, edge_off);
            translate([x_off, y_off, thick-0.01]) 
              cylinder(d1=leg_base_dia, d2=leg_top_dia, h=leg_height);
        };
    };
}