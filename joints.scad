module joint_t(width_a=50, width_b=30, length_a=200, length_b=150, thickness=2) {
  linear_extrude(height=thickness,convexity=5)
  polygon([[0,0],[width_a,0],[width_a+(length_b-width_a)/2,length_a/2-width_b/2],[length_b,length_a/2-width_b/2],[length_b,length_a/2+width_b/2],[width_a+(length_b-width_a)/2,length_a/2+width_b/2],[width_a,length_a],[0,length_a]]);
}
