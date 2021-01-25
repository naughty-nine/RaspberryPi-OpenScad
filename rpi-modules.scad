//
//  rpi-modules.scad
//  © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//
include <BOSL2/std.scad>


/// 
/// Parameter cutout:
/// Used to create offset bounding boxes to create holes in a surrounding structure 
/// to access the connectors:
/// cutout <Vector2d>
/// cutout[0] : Value to surround the object with in NOT plug facing direction.
/// cutout[1] : Outside facing value to create the cutout in plug facing direction.
///

audio_width = 6;
audio_depth = 10;
audio_height = audio_width; 
audio_size = [audio_width, audio_depth, audio_height];
audio_out = 2.3;

module audio(cutout=[0, 0, 0]) {
  union() {
    color("darkgray")
    cuboid(audio_size, anchor=BOTTOM);
    fwd(audio_depth/2)
    up(audio_width/2)
    xrot(90)
    color("black")
    cyl(d=audio_width + cutout[0]*2, 
        l=audio_out+cutout[1], $fn=72);
  }
}


ethernet_width = 16;
ethernet_depth = 21.25;
ethernet_height = 13.5;
ethernet_size = [ethernet_width, ethernet_depth, ethernet_height];
ethernet_out = 1.8;

module ethernet(cutout=[0, 0]) {
  fwd(fwdForCutout(cutout))
  down(cutout[0])
  color("silver") 
  cuboid( addCutoutToSizeY(s=ethernet_size, c=cutout),
          anchor=BOTTOM);
}


hdmi_width = 15.2;
hdmi_depth = 12;
hdmi_height = 5.6;  // height + offset from board
hdmi_size = [hdmi_width, hdmi_depth, hdmi_height];
hdmi_z_offset = 0.6;
hdmi_out = 1.5;

module hdmi(cutout=[0, 0]) {
  down(cutout[0])
  up(hdmi_z_offset)
  color("silver") cuboid( addCutoutToSizeY(s=hdmi_size, c=cutout), 
                          anchor=BOTTOM,
                          chamfer=1.75,
                          edges=[BOTTOM+LEFT, BOTTOM+RIGHT] );
}


led_width = 2;
led_depth = 1;
led_height = .5;
led_inset = 2;

module led(cutout=[0, 0]) {
  fwd(fwdForCutout(cutout))
  down(cutout[0])
  color("red")
  cuboid( addCutoutToSizeY([led_width, led_depth, led_height], cutout),
          anchor=BOTTOM);
}


microsd_width = 12;
microsd_depth = 11.4;
microsd_height = 1.3;
microsd_size = [microsd_width, microsd_depth, microsd_height];
microsd_out = -1.7;

module microsd(cutout=[0, 0]) {
  down(cutout[0])
  color("silver")
  cuboid( addCutoutToSizeY(s=microsd_size, c=cutout),
          anchor=BOTTOM);

  if (cutout[1] > 0) {
    down(cutout[0] + microsd_height + 8/2)
    fwd(microsd_depth + cutout[1]/2 - 2) 
    cuboid([microsd_width + 4,
            microsd_depth + cutout[1],
            8],
            chamfer=2.5,
            edges=[BACK+LEFT, BACK+RIGHT],
            anchor=BOTTOM);
  }
}


microusb_width = 8.1;
microusb_depth = 5;
microusb_height = 3.2;
microusb_size = [microusb_width, microusb_depth, microusb_height];
microusb_out = 1.3;

module microusb(cutout=[0, 0]) {
  down(cutout[0])
  color("silver") cuboid( addCutoutToSizeY(s=microusb_size, c=cutout), 
                          anchor=BOTTOM,
                          chamfer=0.75+cutout[0]*.5,
                          edges=[BOTTOM+LEFT, BOTTOM+RIGHT] );
}


pinconnector_base_dimension = 2.54;
pinconnector_pin_radius = 0.62;
pinconnector_pin_length = 6;
pinconnector_inset = 1.07;
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
    ? count*pinconnector_base_dimension 
    : pinconnector_female_20x2_width;
  base_depth = (has_cut == false)
    ? rows*pinconnector_base_dimension
    : pinconnector_female_20x2_depth;
  
  move( x=-pinconnector_base_dimension*count/2,
        y=-pinconnector_base_dimension/2,
        z=pinconnector_base_dimension)
  union() {
    if (double==true) { rows = 2; }
    for (i = [0:1:count-1]) {
      move(x = i * pinconnector_base_dimension + pinconnector_base_dimension/2)
      for (j = [0:1:rows-1]) {
        move(y=j * pinconnector_base_dimension) {
        
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
                  pinconnector_base_dimension];
    move( x=count/2 * pinconnector_base_dimension,
          y=pinconnector_base_dimension/2,
          z=-pinconnector_base_dimension) {
      color("black") 
      cuboid( addCutoutToSizeZ(s=base_size, c=cutout),
              anchor=BOTTOM);
    
      notch_width = (has_cut == false) 
        ? 0
        : pinconnector_female_20x2_notch_width;
      notch_depth = (has_cut == false)
        ? 0
        : 2*pinconnector_female_20x2_notch_depth + base_depth;
      notch_height = (has_cut == false) 
        ? 0.001
        : pinconnector_base_dimension;
      notch_size = [notch_width, notch_depth, notch_height];
      color("blue") cuboid(addCutoutToSizeZ(s=notch_size, c=cutout), anchor=BOTTOM);
    }
  }
}


usb_width = 15.2;
usb_depth = 17;
usb_height = 15.8;
usb_size = [usb_width, usb_depth, usb_height];
usb_out = 2.1;

module usb(cutout=[0, 0]) {
  fwd(fwdForCutout(cutout))
  down(cutout[0])
  color("silver") 
  cuboid( addCutoutToSizeY(s=usb_size, c=cutout),
          anchor=BOTTOM);
}


function addCutoutToSizeY(s=[0,0,0], c=[0,0]) = [ s[0] + c[0] * 2,
                                                  s[1] + c[1],
                                                  s[2] + c[0] * 2 ];

function addCutoutToSizeZ(s=[0,0,0], c=[0,0]) = [ s[0] + c[0] * 2,
                                                  s[1] + c[0] * 2,
                                                  s[2] + c[1] ];

function fwdForCutout(cutout=[0,0]) = (cutout[1] == 0) ? 0 : cutout[1] / 2 - cutout[0];


function sumVectors3d(lhs=[0,0,0], rhs=[0,0,0]) =
  [
    lhs[0] + rhs[0],
    lhs[1] + rhs[1],
    lhs[2] + rhs[2],
  ];
//


// ethernet();
// #ethernet(cutout=[.5, 20]);

// #pinconnector();
// pinconnector(cutout=[0.5, 20]);
