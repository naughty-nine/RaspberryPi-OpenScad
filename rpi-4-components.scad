// 
// rpi-4-modules.scad
// © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//
include <BOSL2/std.scad>
include <cutout.scad>


// LED 

module led(dim=[2,2,0.5], color="blue", cutout=[0, 0]) {
  up(dim.z/2) {
    object_cuboid_cutout_circle(dim=dim, color=color, cutout=cutout);
  }
}

// USB

module usb_a(body_dim=[6,9,7], lip_dim=[7,0.5,8], cutout=[0,0]) {
  up(body_dim[2]/2) {
    color("silver")
    union() {
      cuboid(body_dim, anchor=FRONT);
      cuboid(lip_dim, anchor=FRONT);
    }
    if (cutout[0] > 0) {
      color(CUTOUT_COLOR)
      fwd(fwdForCutout(cutout)) {
        cuboid(addCutoutToSizeY(s=body_dim, c=cutout), anchor=FRONT);
        front_cutout = [cutout[0], 
                        cutout[1] - body_dim[1] - lip_dim[1]];
    
        cuboid(addCutoutToSizeY(s=lip_dim, c=cutout), anchor=FRONT);
      }
    }
  }
}


usb_c_dim = [9, 7.3, 3.2];

module usb_c(cutout=[0,0]) {
  up(usb_c_dim[2]/2) {
    color("silver")
    cuboid (usb_c_dim, 
            rounding=1.2,
            except_edges=[FRONT, BACK],
            anchor=FRONT);
    if (cutout[0] > 0) {
      //cuboid ([2,cutout[1], 2], anchor=BACK);
      fwd(cutout[0])
      fwd(fwdForCutout(cutout))
      color(CUTOUT_COLOR)
      cuboid (addCutoutToSizeY(s=usb_c_dim, c=cutout), 
              rounding=1.2,
              except_edges=[FRONT, BACK],
              anchor=FRONT);
    }
  }
}

$fn=30;
right(20) {
  right()   usb_a();
  right(10) usb_a(cutout=[0.5, 30]);

  right(30) usb_c();
  right(42) usb_c(cutout=[0.5, 15]);

  right(57) led(dim=[4, 3, 2]);
  right(63) led(dim=[4, 3, 2], cutout=[0.5, 20]);
}
