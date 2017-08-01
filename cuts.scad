module angle_cut(width=100,angle=45,thickness=30) {
  color([0.5,0.5,1,0.5])
  translate([-1,-1,-1])
  linear_extrude(height=thickness+2)
  polygon([[0,0],[0,tan(angle)*(width+2)],[width+2,0]]);
}
