module tool_holder(tool_diameter=50,width=100,height=12,thickness=12, gap=5, hole_diameter=5) {
  cylinder_outer_radius=tool_diameter/2+thickness;

  translate([width/2,width/2,height/2-height/2]) {    
    difference() {
      union() {
        translate([-width/2,-width/2,0]) linear_extrude(height=height,convexity=5)
        polygon([[0,0],[width/4,0],[width/2,width/2-cylinder_outer_radius],[width/2,width-(width/2-cylinder_outer_radius)],[width/4,width],[0,width]]);

        cylinder(r=cylinder_outer_radius,h=height,$fn=128);
        translate([tool_diameter/2,-thickness,0]) cube([thickness*2,thickness*2,height]);
      }

      translate([0,0,-1]) cylinder(r=tool_diameter/2,h=height+2,$fn=128);
      translate([0,-gap/2,-1]) cube([cylinder_outer_radius+thickness+1,gap,height+2]);
      translate([cylinder_outer_radius+thickness/2,thickness+1,thickness/2]) rotate([90,0,0]) cylinder(r=hole_diameter/2,h=thickness*2+2,$fn=16);
    }
  }
}
