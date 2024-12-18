function polar_to_cart(points) = [
    for (point = points)
    [point[0]*cos(point[1]), point[0]*sin(point[1])]
];

function pc(pt) = [pt[0]*cos(pt[1]), pt[0]*sin(pt[1])];

function inc(inc, step) = (inc*step) + (step % 2 == 0 ? 0 : 0.001);
function line(from, to, steps=10, last_fencepost=true) = [
    let(
        diff=to-from,
        inc=diff/(last_fencepost ? steps : steps+1)
    )
    for(step=[0:steps]) [from.x + inc(inc.x, step), from.y + inc(inc.y, step)]
];

$fn=100;
    
star_points = [
    each line(pc([5, 10]), pc([20, 25])), each line(pc([20, 35]), pc([5, 45])),
    each line(pc([5, 55]), pc([20, 70])), each line(pc([20, 80]), pc([5, 90])),
    each line(pc([5, 100]), pc([20, 115])), each line(pc([20, 125]), pc([5, 135])),
    each line(pc([5, 145]), pc([20, 160])), each line(pc([20, 170]), pc([5, 180])),
    each line(pc([5, 190]), pc([20, 205])), each line(pc([20, 215]), pc([5, 225])),
    each line(pc([5, 235]), pc([20, 250])), each line(pc([20, 260]), pc([5, 270])),
    each line(pc([5, 280]), pc([20, 295])), each line(pc([20, 305]), pc([5, 315])),
    each line(pc([5, 325]), pc([20, 340])), each line(pc([20, 350]), pc([5, 0])) 
];
// linear_extrude(20, twist=20) polygon(star_points);
//intersection() {
difference() {
    translate([0, 0, 0.01]) cylinder(h=50-0.02, r1=25, r2=5);
    linear_extrude(50, convexity=6, twist=90)
      offset(r=0.5) polygon(star_points);  // vary offset between intersection and difference
}

//offset(r=1) polygon([[0, 0], [10, 0], [0, 20]]);