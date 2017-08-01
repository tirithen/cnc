/**
* Examples:
* profile_l(length=500,width=30);
* translate([0,50,0]) profile_u(length=500,width=30);
* translate([0,100,0]) profile_o(length=500,width=30);
* translate([0,150,0]) profile_flat(length=500,width=30);
*/

module profile_l(width=10,height=10,thickness=1,length=20) {
  rotate([90,0,90])
  linear_extrude(height=length,convexity=5)
  polygon([[0,0],[width,0],[width,thickness],[thickness,thickness],[thickness,height],[0,height]]);
}

module profile_u(width=10,height=10,thickness=1,length=20) {
  rotate([90,0,90])
  linear_extrude(height=length,convexity=5)
  polygon([[0,height],[0,0],[width,0],[width,height],[width-thickness,height],[width-thickness,thickness],[thickness,thickness],[thickness,height]]);
}

module profile_o(width=10,height=10,thickness=1,length=20) {
  rotate([90,0,90])
  linear_extrude(height=length,convexity=5)
  polygon(points=[[0,0],[width,0],[width,height],[0,height],[thickness,thickness],[width-thickness,thickness],[width-thickness,height-thickness],[thickness,height-thickness]],paths=[[0,1,2,3],[4,5,6,7]]);
}


module profile_flat(width=10,length=10,thickness=1) {
  cube([length,width,thickness]);
}
