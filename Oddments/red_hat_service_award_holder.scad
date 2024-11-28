/*
Red Hat Service Award ('puck') holder.

Model by Paul Wayper, copyright January 2024.

Licensed for reuse under the Creative Commons 4.0 By-SA license:

https://creativecommons.org/licenses/by-sa/4.0/
*/

award_width = 24;  // 23 for old five-year puck
award_diam = 103;  award_rad = award_diam/2;
side_thick = 3;  base_thick = 5;  step_thick = 2;
length = 80;
// Calculate height to fit disc diameter within given length;
height = award_rad - sqrt(award_rad^2 - (length/2)^2) + base_thick; 

$fn=$preview ? 40 : 80;

difference() {
    // the main block
    cube([length, award_width+side_thick*2, height]);
    // main space for award
    translate([length/2, 3, award_rad + base_thick]) rotate([-90, 0, 0])
      cylinder(h=award_width, d=award_diam);
    // surround
    translate([length/2, -0.01, award_rad + base_thick + step_thick]) rotate([-90, 0, 0])
      cylinder(h=award_width+(side_thick+0.01)*2, d=award_diam-4);
}