myfont = "Neuropol";

intersection() {
    translate([0, 100, 0]) rotate([90, 0, 0])
      linear_extrude(100, convexity=10) text("J", size=80, font=myfont);
    // translate([0, 100, 0]) 
    rotate([90, 0, 90])
      linear_extrude(100, convexity=10) text("B", size=74, font=myfont);
}