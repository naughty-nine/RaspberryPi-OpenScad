//
//  rpi-modules.scad
//  © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//
include <BOSL2/std.scad>
include <rpi-modules.scad>

//
//  R-pi
//
rpi_width = 85;
rpi_depth = 56;
rpi_board_height = 1.4;
rpi_corner_radius = 3;
rpi_hole_dia = 2.7;
rpi_hole_inset = 3.5;
rpi_hole_inset_right = 85 - 58 - 3.5;
rpi_hole_center_offsets = [
  [-rpi_width/2+rpi_hole_inset, -rpi_depth/2+rpi_hole_inset],
  [rpi_width/2-rpi_hole_inset_right, -rpi_depth/2+rpi_hole_inset],
  [rpi_width/2-rpi_hole_inset_right, rpi_depth/2-rpi_hole_inset],
  [-rpi_width/2+rpi_hole_inset, rpi_depth/2-rpi_hole_inset]
];
rpi_bottom_clearance = 3;
rpi_standoff = 13;  // 12.9


led1_y_inset = 7.6;
led2_y_inset = 11.6;

module rpi_2b(cutout=[0, 0]) {
 
  // Mainboard
  color("green")
  difference() {
    cuboid( [rpi_width, rpi_depth, rpi_board_height], 
              rounding=rpi_corner_radius,
            edges=[LEFT+FRONT,RIGHT+FRONT,RIGHT+BACK,LEFT+BACK],
            $fn=48,
            anchor=TOP);
    for (i = [0:1:3]) {
      up(0.1)
      move( x=rpi_hole_center_offsets[i][0], 
            y=rpi_hole_center_offsets[i][1])
      cyl(d=rpi_hole_dia, l=rpi_board_height+.2, $fn=48, anchor=TOP);
    }
  }
  
  // Micro USB
  left(rpi_width/2-10.6)
  fwd(rpi_depth/2-microusb_depth/2+microusb_out)
  microusb(cutout=cutout);

  // HDMI
  left(rpi_width/2-32)
  fwd(rpi_depth/2-hdmi_depth/2+hdmi_out)
  hdmi(cutout=cutout);

  // Audio
  left(rpi_width/2-53.5)
  fwd(rpi_depth/2-audio_depth/2)
  audio(cutout=cutout);

  // Ethernet
   first = cutout[0];
   _cutout = [(first>0) ? 0.25 : cutout[0],
              cutout[1]];
  right(rpi_width/2-ethernet_depth/2+ethernet_out)
  fwd(rpi_depth/2-10.25)
  zrot(90)
  ethernet(cutout=_cutout);

  // USB 1
  right(rpi_width/2-usb_depth/2+usb_out)
  fwd(rpi_depth/2-29)
  zrot(90)
  usb(cutout=_cutout);

  // USB 2
  right(rpi_width/2-usb_depth/2+usb_out)
  fwd(rpi_depth/2-47)
  zrot(90)
  usb(cutout=_cutout);

  // GPIO
  left(rpi_width/2 - rpi_hole_inset - 29)// + pinconnector_base_dimension/2)
  back(rpi_depth/2 - pinconnector_inset - pinconnector_base_dimension)
  pinconnector(cutout=cutout);

  // Micro SD
  left(rpi_width/2 - microsd_depth/2 + microsd_out)
  down(rpi_board_height + microsd_height)
  zrot(-90)
  microsd(cutout=cutout);

  // LEDs
  left(rpi_width/2 - led_depth/2 - led_inset)
  fwd(rpi_depth/2 - led_width/2  - led1_y_inset)
  zrot(-90)
  led(cutout=cutout);

  left(rpi_width/2 - led_depth/2 - led_inset)
  fwd(rpi_depth/2 - led_width/2  - led2_y_inset)
  zrot(-90)
  led(cutout=cutout);
} 

// rpi_2b();
// %rpi_2b(cutout=[0.5, 20]);
