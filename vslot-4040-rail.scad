include <BOSL2/std.scad>


function leg_of_isosceles_triangle(hypo=0) = sqrt(pow(hypo, 2) / 2);


profile_thick = 1.8 + 0.05;

rail_outside_width_1 = 9.16 - 0.1;
rail_inner_width = 11 - 0.2;
rail_inner_base_depth = 2 - 0.05;

module rail(length=10) {
  rail_outside_left = leg_of_isosceles_triangle(
                      hypo=leg_of_isosceles_triangle(
                              hypo=rail_outside_width_1));
  union() {
    left(rail_outside_left)
    yrot(45, [0,0,0])
    prismoid( size1=[leg_of_isosceles_triangle(hypo=rail_outside_width_1), length],
              size2=[0, length],
              shift=[-leg_of_isosceles_triangle(hypo=rail_outside_width_1)/2, 0],
              h=leg_of_isosceles_triangle(hypo=rail_outside_width_1),
              anchor=LEFT+BOTTOM);
    left(profile_thick)
    cuboid( [2, length, rail_inner_width], anchor=RIGHT);

//     difference() {
//       left(rail_outside_left + profile_thick + rail_inner_base_depth + 0.9)
//       yrot(45, [0,0,0])
//       prismoid( size1=[leg_of_isosceles_triangle(hypo=rail_inner_width), length],
//                 size2=[0, length],
//                 shift=[-leg_of_isosceles_triangle(hypo=rail_inner_width)/2, 0],
//                 h=leg_of_isosceles_triangle(hypo=rail_inner_width),
//                 anchor=LEFT+BOTTOM);
// 
//       left(profile_thick + 4.3)
//       cuboid([10, 20 + 0.001, 10], anchor=RIGHT);
//     }
  }
}

module rail_4040(length=10) {
  up(10)
  rail(length=length);
  down(10)
  rail(length=length);
}

// rail_4040(length=20);
// cuboid([2, 20, 40], anchor=LEFT);
