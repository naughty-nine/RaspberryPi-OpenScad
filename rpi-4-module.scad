//
//  rpi-4.scad
//  © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//

include <BOSL2/std.scad>
include <rpi-common.scad>
use     <rpi-components.scad>
use     <rpi-4-components.scad>


module rpi4(cutout=[0, 0]) {
  union() {
    down(rpi_pcb_dim.z/2) mainboard();
    rpi4_connectors(cutout=cutout);
  }
}

module rpi4_connectors(cutout=[0, 0]) {
  rpi4_front_connectors(cutout=cutout);
  rpi4_right_connectors(cutout=cutout);
  rpi4_back_connectors(cutout=cutout);
  rpi4_left_connectors(cutout=cutout);
}

module rpi4_front_connectors(cutout=[0, 0]) {
  x0 = rpi_hole_inset;
  move(x=-rpi_pcb_dim.x/2, y=-rpi_pcb_dim.y/2) {
    x1 = x0 + 7.7;
    x2 = x1 + 14.8;
    x3 = x2 + 13.5;
    fwd(1.3) {
      right(x1) usb_c(cutout=cutout);
      right(x2) hdmi_micro(cutout=cutout);
      right(x3) hdmi_micro(cutout=cutout);
    }
    x5 = x3 + 7 + 7.5;
    right(x5) audio(cutout=cutout);
  }
}


rpi4_usba_double_body_dim = [13.1, 17.5, 14];
rpi4_usba_double_lip_dim = [14.57, 0.5, 15.5];
rpi4_usb_offset_x = 3;
rpi4_usb_offset_z = 2.9 - rpi_pcb_dim.z;
rpi4_ethernet_offset_x = rpi4_usb_offset_x;

module rpi4_right_connectors(cutout=[0, 0]) {
  move(x=rpi_pcb_dim.x/2, y=-rpi_pcb_dim.y/2) {
    right(rpi4_usb_offset_x) {
      up(rpi4_usb_offset_z) {
        y1 = 9;
        back(y1) zrot(90) 
        usb_a(body_dim=rpi4_usba_double_body_dim,
              lip_dim=rpi4_usba_double_lip_dim,
              cutout=cutout);
        y2 = 27;
        back(y2) zrot(90) 
        usb_a(body_dim=rpi4_usba_double_body_dim,
              lip_dim=rpi4_usba_double_lip_dim,
              cutout=cutout);
      }
      y3 = 45.75;
      back(y3) zrot(90) ethernet(cutout=cutout);
    }
  }
}

module rpi4_back_connectors(cutout=[0, 0]) {
  x0 = rpi_hole_inset;
  move(x=-rpi_pcb_dim.x/2,  y=rpi_pcb_dim.y/2) {
    x1 = x0 + 29;
    right(x1) fwd(rpi_hole_inset) pinconnector(cutout=cutout);
  }
}

module rpi4_left_connectors(cutout=[0, 0]) {
  led_dim = [1.9, 1, 0.5];
  led_inset_x = .4;
  led_insets_y = [7, 1.8, 43.4];
  y0 = led_insets_y[0] + led_dim.x/2;
  y1 = y0 + led_insets_y[1] + led_dim.x;
  move(x=-rpi_pcb_dim.x/2, y=-rpi_pcb_dim.y/2) {
    right(led_inset_x) {
      //cuboid([1, led_insets_y[0], 1], anchor=FRONT);
      back(y0)
      zrot(-90) led(dim=led_dim, color="red", cutout=cutout);
      back(y1)
      zrot(-90) led(dim=led_dim, color="lime", cutout=cutout);
    }
    //back(rpi_pcb_dim.y)
    //cuboid([1, led_insets_y[2], 1], anchor=BACK);
    y3 = 24.5;
    down(rpi_pcb_dim.z+microsd_dimension().z)
    back(y3) zrot(-90) microsd(cutout=cutout);
  }
}

//
// standoff[0] = diameter
// standoff[1] = length
//
module rpi4_with_standoffs(standoff=[0,0], cutout=[0,0]) {
  union() {
    move (x=-rpi_pcb_dim.x/2, y=-rpi_pcb_dim.y/2)
    for (i=[0:1:3]) {
      move (x=rpi_hole_centers[i][0], y=rpi_hole_centers[i][1]) 
      color("silver")
      cyl(d=standoff[0], l=standoff[1], $fn=6, anchor=BOT);
    }
    up(rpi_pcb_dim.z + standoff[1])
    rpi4(cutout=cutout);
  }
}


$fn=40;
left(55)  rpi4();
right(55) rpi4(cutout=[0.5, 20]);
