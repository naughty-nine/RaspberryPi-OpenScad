//
//  rpi-common.scad
//  © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//
include <BOSL2/std.scad>

//
// Raspberry Pi Common Measurements and Modules
//
rpi_pcb_dim = [85, 56, 1.4];
rpi_pcb_corner_radius = 3;
rpi_hole_dia = 2.7;
rpi_hole_inset = 3.5;
rpi_hole_centers = [
  [rpi_hole_inset, rpi_hole_inset],
  [rpi_hole_inset+58, rpi_hole_inset],
  [rpi_hole_inset+58, rpi_hole_inset+49],
  [rpi_hole_inset, rpi_hole_inset+49]
];

module mainboard() {
  color("green")
  difference() {
    cuboid( rpi_pcb_dim, 
            rounding=rpi_pcb_corner_radius,
            edges=[LEFT+FRONT,RIGHT+FRONT,RIGHT+BACK,LEFT+BACK],
            $fn=48);
    move (x=-rpi_pcb_dim[0]/2,
          y=-rpi_pcb_dim[1]/2) {
      for(i=[0:1:3]) {
        move( x=rpi_hole_centers[i][0],
              y=rpi_hole_centers[i][1])
        cyl(d=rpi_hole_dia, l=rpi_pcb_dim[2]+.2, $fn=48);
      }
    }
  }
}

// mainboard();
