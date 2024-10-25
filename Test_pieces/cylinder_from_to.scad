
module cylinder_from_to(from, to, d=undef, r=undef) {
    height=sqrt((to.x-from.x)^2 + (to.y-from.y)^2 + (to.z-from.z)^2);
    // z rotation is simply looking down on the XY plane, but Y rotation
    // has to be relative to the plane parallel to the Z axis that both
    // from and to rest on, so the 'adjacent' distance for the arctan
    // is the 
    y_rot = atan2(sqrt((to.x-from.x)^2 + (to.y-from.y)^2), to.z-from.z);
    z_rot = atan2(to.y-from.y, to.x-from.x);
    echo(y_rot=y_rot, z_rot=z_rot);
    assert (d!=undef || r != undef, "Must define one of 'd' or 'r'");
    assert (!(d!=undef && r != undef), "Either define 'd' or 'r', not both");
    radius = (d != undef) ? d/2 : r;
    translate(from) rotate([0, y_rot, z_rot]) cylinder(r=radius, h=height);
}

$fn = 20;
// cylinder_from_to([2, 5, -1], [10, 10, 10], d=2);
// translate([10, 10, 10]) sphere(d=2);
