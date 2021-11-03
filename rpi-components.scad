//
//  rpi-modules.scad
//  © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//
include <BOSL2/std.scad>
include <cutout.scad>

// 
// Parameter cutout: See cutout.scad
//

audio_dim = [6, 10, 6];
audio_out = 2.3;

module audio(cutout=[0, 0, 0]) {
  up(audio_dim.z/2){
    union() {
      color("navy")
      cuboid(audio_dim, anchor=FRONT);
      color("black")
      ycyl(d=audio_dim.x + cutout[0]*2, l=audio_out, anchor=BACK);
    }
    if (cutout[0] > 0) {
      color(CUTOUT_COLOR)
      ycyl(d=audio_dim.x+2*cutout[0], l=cutout[1], anchor=BACK);
    }
  }
}


ethernet_dim = [16, 21.25, 13.5];

module ethernet(cutout=[0, 0]) {
  up(ethernet_dim.z/2)
  object_cuboid(s=ethernet_dim, color="silver", cutout=cutout);
}

// HDMI

hdmi_dim = [15.2, 12, 5.6]; // z = height + offset from board
hdmi_z_offset = 0.6;

module hdmi(cutout=[0, 0]) {
  down(cutout[0])
  up(hdmi_z_offset)
  color("silver") cuboid( addCutoutToSizeY(s=hdmi_dim, c=cutout), 
                          anchor=BOTTOM,
                          chamfer=1.75,
                          edges=[BOTTOM+LEFT, BOTTOM+RIGHT] );
}
function hdmi_dimension() = hdmi_dim;


hdmi_micro_dim = [6.5, 7.5, 3.2];

module hdmi_micro(cutout=[0,0]) {
  up(hdmi_micro_dim.z/2)
  object_cuboid(s=hdmi_micro_dim, rounding=1.2, cutout=cutout);
}


// LEDs

module led(dim=[2,2,0.5], color="red", cutout=[0, 0]) {
  up(dim.z/2) {
    color(color)
    cuboid(dim, anchor=FRONT);
    if (cutout[0] > 0) {
      cuboid ([.5,cutout[1], .5], anchor=BACK);
      fwd(cutout[0])
      fwd(fwdForCutout(cutout))
      color(CUTOUT_COLOR)
      cuboid( addCutoutToSizeY(dim, cutout),
              anchor=FRONT);
    }
  }
}



// SD-Card

microsd_dim = [12, 11.4, 1.3];

module microsd(cutout=[0, 0]) {
  down(cutout[0])
  color("silver")
  cuboid( addCutoutToSizeY(s=microsd_dim, c=cutout),
          anchor=BOTTOM+FRONT);

  if (cutout[1] > 0) {
    down(cutout[0] + microsd_dim.z + 8/2)
    fwd(microsd_dim.y + cutout[1]/2 - 2) 
    cuboid([microsd_dim.x + 4,
            microsd_dim.y + cutout[1],
            8],
            chamfer=2.5,
            edges=[BACK+LEFT, BACK+RIGHT],
            anchor=BOTTOM+FRONT);
  }
}
function microsd_dimension() = microsd_dim;

// Micro-USB

microusb_dim = [8.1, 5, 3.2];

module microusb(cutout=[0, 0]) {
  down(cutout[0])
  color("silver") cuboid( addCutoutToSizeY(s=microusb_dim, c=cutout), 
                          anchor=BOTTOM,
                          chamfer=0.75+cutout[0]*.5,
                          edges=[BOTTOM+LEFT, BOTTOM+RIGHT] );
}
function microusb_dimension() = microusb_dim;

pinconnector_base_dim = 2.54;
pinconnector_pin_radius = 0.62;
pinconnector_pin_length = 6;
pinconnector_female_20x2_width = 56;
pinconnector_female_20x2_depth = 6; 
pinconnector_female_20x2_notch_width = 3.8;
pinconnector_female_20x2_notch_depth = 0.8;

/// Cutout is fixed for R-Pi GPIO 20 pins (count=20)
module pinconnector(double=true, count=20, cutout=[0,0]) {
  rows = (double) ? 2 : 1;
  has_cut = (cutout[1] > 0) ? true : false;

  // correct the cutout because the plug (see pinconnector_female_xxx is so much
  // bigger and needs to fit in the cutout)
  base_width = (has_cut == false) 
    ? count*pinconnector_base_dim 
    : pinconnector_female_20x2_width;
  base_depth = (has_cut == false)
    ? rows*pinconnector_base_dim
    : pinconnector_female_20x2_depth;
  
  move( x=-pinconnector_base_dim*count/2,
        y=-pinconnector_base_dim/2,
        z=pinconnector_base_dim)
  union() {
    if (double==true) { rows = 2; }
    for (i = [0:1:count-1]) {
      move(x = i * pinconnector_base_dim + pinconnector_base_dim/2)
      for (j = [0:1:rows-1]) {
        move(y=j * pinconnector_base_dim) {
        
          color("gold")
          cuboid( [pinconnector_pin_radius, 
                    pinconnector_pin_radius, 
                    pinconnector_pin_length],
                  anchor=BOTTOM);
        }
      }
    }
    base_size = [base_width,
                  base_depth,
                  pinconnector_base_dim];
    move( x=count/2 * pinconnector_base_dim,
          y=pinconnector_base_dim/2,
          z=-pinconnector_base_dim) {
      color("black") 
      cuboid( addCutoutToSizeZ(s=base_size, c=cutout),
              anchor=BOTTOM);
    
      notch_width = (has_cut == false) 
        ? 0.001
        : pinconnector_female_20x2_notch_width;
      notch_depth = (has_cut == false)
        ? 0.001
        : 2*pinconnector_female_20x2_notch_depth + base_depth;
      notch_height = (has_cut == false) 
        ? 0.001
        : pinconnector_base_dim;
      notch_size = [notch_width, notch_depth, notch_height];
      color("blue") cuboid(addCutoutToSizeZ(s=notch_size, c=cutout), anchor=BOTTOM);
    }
  }
}
function pinconnector_base_dimension() = pinconnector_base_dim;


usb_size = [15.2, 17, 15.8];

module usb(cutout=[0, 0]) {
  fwd(fwdForCutout(cutout))
  down(cutout[0])
  color("silver") 
  cuboid( addCutoutToSizeY(s=usb_size, c=cutout),
          anchor=BOTTOM+FRONT);
}


function sumVectors3d(lhs=[0,0,0], rhs=[0,0,0]) =
  [
    lhs[0] + rhs[0],
    lhs[1] + rhs[1],
    lhs[2] + rhs[2],
  ];

$fn=40;
right(20) {
  right()   ethernet();
  right(20) ethernet(cutout=[.5, 20]);

  right(40) hdmi_micro(); 
  right(51) hdmi_micro(cutout=[.5, 10]);
  
  right(60) led();
  right(65) led(cutout=[0.5, 20]);
  
  right(75) audio();
  right(85) audio(cutout=[0.5, 20]);

  right(110) microsd();
  right(130) microsd(cutout=[0.5, 20]);

  right(180) #pinconnector();
  right(240) pinconnector(cutout=[0.5, 20]);
}
