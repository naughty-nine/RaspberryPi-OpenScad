//
// cutout.scad
// © naughty.nin@gmail.com 2021 - CC BY-NC-SA 4.0 
//

/// 
/// Parameter cutout:
/// Used to create offset bounding boxes to create holes in a surrounding structure 
/// to access the connectors:
/// cutout <Vector2d>
/// cutout[0] : Value to surround the object with in NOT plug facing direction.
/// cutout[1] : Outside facing value to create the cutout in plug facing direction.
///

CUTOUT_COLOR="#bbbbbb44";
FILAMENT_DIA = 1.75;

function addCutoutToSizeY(s=[0,0,0], c=[0,0]) 
  = [ s[0] + c[0] * 2,
      s[1] + c[1],
      s[2] + c[0] * 2 ];

function addCutoutToSizeZ(s=[0,0,0], c=[0,0]) 
  = [ s[0] + c[0] * 2,
      s[1] + c[0] * 2,
      s[2] + c[1] ];

function fwdForCutout(cutout=[0,0]) 
  = (cutout[1] == 0) ? 0 : cutout[1] - cutout[0];


module object_cuboid(s=[6,7,3], rounding=0, color="silver", cutout=[0,0]) {
  color(color)
  cuboid (s, rounding=rounding, except_edges=[FRONT, BACK],
          anchor=FRONT);
  if (cutout.x > 0) {
    //cuboid([2,cutout.y,2], anchor=BACK);
    fwd(cutout.x)
    fwd(fwdForCutout(cutout))
    color(CUTOUT_COLOR)
    cuboid (addCutoutToSizeY(s=s, c=cutout),
            rounding=rounding, except_edges=[FRONT, BACK],
            anchor=FRONT);
  }
}


module object_cuboid_cutout_circle(dim=[6,7,3], rounding=0, color="yellow", cutout=[0,0]) {
  color(color)
  cuboid (dim, rounding=rounding, except_edges=[FRONT, BACK],
          anchor=FRONT);
  if (cutout.x > 0) {
    //cuboid([.2,cutout.y,.2], anchor=BACK);
    new_dim = addCutoutToSizeY(s=dim, c=cutout);
    fwd(cutout.x)
    fwd(fwdForCutout(cutout))
    color(CUTOUT_COLOR)
    ycyl(d=FILAMENT_DIA, l=new_dim[1], anchor=FRONT);
  }
}