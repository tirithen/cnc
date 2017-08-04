aluminum_color=[0.913,0.921,0.925];

module foot(width=60,height=40,length=60,thickness=5, through_hole_diameter=10) {
  // Aluminum foot
  color(aluminum_color) {
    difference() {
      profile_o(width=width,height=height,length=length,thickness=thickness);
      translate([through_hole_diameter+thickness,through_hole_diameter+thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness+2,$fn=32);
      translate([through_hole_diameter+thickness,width-through_hole_diameter-thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness+2,$fn=32);
      translate([length-through_hole_diameter-thickness,through_hole_diameter+thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness+2,$fn=32);
      translate([length-through_hole_diameter-thickness,width-through_hole_diameter-thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness+2,$fn=32);
    }
  }

  // Rubber foot
  color([0,0,0]) {
    union() {
      translate([0,0,-thickness]) cube([length,width,thickness]);
      translate([through_hole_diameter+thickness,through_hole_diameter+thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness*2,$fn=32);
      translate([through_hole_diameter+thickness,width-through_hole_diameter-thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness*2,$fn=32);
      translate([length-through_hole_diameter-thickness,through_hole_diameter+thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness*2,$fn=32);
      translate([length-through_hole_diameter-thickness,width-through_hole_diameter-thickness,-1]) cylinder(r=through_hole_diameter/2,h=thickness*2,$fn=32);
    }
  }
}
