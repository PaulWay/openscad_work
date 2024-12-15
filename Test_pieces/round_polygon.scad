module round_poly(points, radius) {
    offset(r=radius) offset(r=-radius*2) offset(r=radius)
    polygon(points);
}

$fn=$preview?20:40;

round_poly([[0, 0], [-10, 40], [20, 70], [30, 10]], 3);
