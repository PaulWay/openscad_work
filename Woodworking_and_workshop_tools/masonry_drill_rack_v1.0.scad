
difference() {
    cube([100, 30, 20]);
    // 3mm
    translate([ 3+0*2+5, 30/2-0, 5]) cylinder(d=3.5, h=20);
    translate([ 3+0*2+5, 30/2-0, 5]) cylinder(d=3.5, h=20);
    // 4mm
    translate([ 7+1*2+5, 30/2-6, 5]) cylinder(d=4.5, h=20);
    translate([ 7+1*2+5, 30/2-0, 5]) cylinder(d=4.5, h=20);
    translate([ 7+1*2+5, 30/2+6, 5]) cylinder(d=4.5, h=20);
    // 5mm
    translate([12+2*2+5, 30/2-7, 5]) cylinder(d=5.5, h=20);
    translate([12+2*2+5, 30/2-0, 5]) cylinder(d=5.5, h=20);
    translate([12+2*2+5, 30/2+7, 5]) cylinder(d=5.5, h=20);
    // 6mm
    translate([18+3*2+5, 30/2-0, 5]) cylinder(d=6.5, h=20);
    // 7mm
    translate([25+4*2+5, 30/2-0, 5]) cylinder(d=7.5, h=20);
    // 8mm
    translate([33+5*2+5, 30/2-0, 5]) cylinder(d=8.5, h=20);
    // 9mm
    translate([42+6.5*2+5, 30/2-0, 5]) cylinder(d=9.5, h=20);
    // 10mm
    translate([52+8*2+5, 30/2-0, 5]) cylinder(d=10.5, h=20);
    // 12mm
    translate([64+10*2+5, 30/2-0, 5]) cylinder(d=9.5, h=20);
}