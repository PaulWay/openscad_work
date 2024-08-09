include <../libs/pw_funcs.scad>;

$fa = 2;
linear_extrude(10) difference() {
    polygon([
        each polar_to_cart(p_arcline(50, 70, 180)),
        each p_translate(polar_to_cart(p_scale(p_arc(10, 180), [-1, -1])), [-60, 0]),
        each p_translate(polar_to_cart(p_translate(p_arcline(50, 70, 180), [0, 180])), [0, 0]),
        each p_translate(polar_to_cart(p_scale(p_arc(10, 180), [1, -1])), [60, 0]),
    ]);
    square(20, center=true);
}