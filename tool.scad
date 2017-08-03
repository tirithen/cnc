aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];

module tool_holder(tool_diameter=50,width=100,height=12,thickness=12, gap=5, hole_diameter=5) {
  cylinder_outer_radius=tool_diameter/2+thickness;

  color(aluminum_color) {
    translate([width/2,width/2,height/2-height/2]) {
      difference() {
        union() {
          translate([-width/2,-width/2,0]) linear_extrude(height=height,convexity=5)
          polygon([[0,0],[width/4,0],[width/2,width/2-cylinder_outer_radius],[width/2,width-(width/2-cylinder_outer_radius)],[width/4,width],[0,width]]);

          cylinder(r=cylinder_outer_radius,h=height,$fn=128);
          translate([tool_diameter/2,-thickness,0]) cube([thickness*2,thickness*2,height]);
        }
        union() {
          translate([0,0,-1]) cylinder(r=tool_diameter/2,h=height+2,$fn=128);
          translate([0,-gap/2,-1]) cube([cylinder_outer_radius+thickness+1,gap,height+2]);
          translate([cylinder_outer_radius+thickness/2,thickness+1,thickness/2]) rotate([90,0,0]) cylinder(r=hole_diameter/2,h=thickness*2+2,$fn=16);
        }
      }
    }
  }
}

module tool_holder_laser_laser(beam_length=200,beam_angle=0,beam_width_angle=30,beam_thickness=0.5,beam_color=[1,0,0,0.05]) {
  color(steel_color) cylinder(r=6,h=35,$fn=64);

  color(beam_color) {
    rotate([0,0,beam_angle]) {
      intersection() {
        translate([0,beam_thickness/2,0]) rotate([90,180,0]) cylinder(r=beam_length,h=beam_thickness,$fn=32);
        union() {
          translate([0,beam_thickness/2+1,0]) rotate([90,180,0]) linear_extrude(height=beam_thickness+2,convexity=5) polygon([[0,0],[sin(beam_width_angle/2)*beam_length,cos(beam_width_angle/2)*beam_length],[-sin(beam_width_angle/2)*beam_length,cos(beam_width_angle/2)*beam_length]]);

          difference() {
            translate([0,beam_thickness/2+1,0]) rotate([90,180,0]) cylinder(r=beam_length,h=beam_thickness+2,$fn=32);
            translate([-beam_length,-beam_thickness/2-2,-cos(beam_width_angle/2)*beam_length]) cube([beam_length*2,beam_thickness+4,beam_length*2]);
          }
        }
      }
    }
  }
}

module tool_holder_laser(tool_diameter=50,width=100,height=12,thickness=12, gap=5, hole_diameter=5,beam_length=300,beam_angle=0,beam_width_angle=30,laser_unit_angle=15,draw_laser=false) {
  cylinder_outer_radius=tool_diameter/2+thickness;

  translate([width/2,width/2,height/2-height/2]) {
    color(aluminum_color) {
      difference() {
        union() {
          translate([-width/2,-width/2,0]) linear_extrude(height=height,convexity=5) polygon([[0,0],[width/4,0],[width/1.75,width/2-cylinder_outer_radius-thickness*2.2],[width/1.75,width-(width/2-cylinder_outer_radius-thickness*2.2)],[width/4,width],[0,width]]);

          cylinder(r=cylinder_outer_radius,h=height,$fn=128);
          translate([tool_diameter/2,-thickness,0]) cube([thickness*2,thickness*2,height]);
        }
        union() {
          translate([0,0,-1]) cylinder(r=tool_diameter/2,h=height+2,$fn=128);
          translate([0,-gap/2,-1]) cube([cylinder_outer_radius+thickness+1,gap,height+2]);
          translate([cylinder_outer_radius+thickness/2,thickness+1,thickness/2]) rotate([90,0,0]) cylinder(r=hole_diameter/2,h=thickness*2+2,$fn=16);

          translate([0,-cylinder_outer_radius-thickness/2,-thickness/2]) rotate([laser_unit_angle,0,0]) cylinder(r=6,h=50,$fn=32);
          translate([0,cylinder_outer_radius+thickness/2,-thickness/2]) rotate([-laser_unit_angle,0,0]) cylinder(r=6,h=50,$fn=32);
          translate([-cylinder_outer_radius-thickness/2,0,-thickness/2]) rotate([0,-laser_unit_angle,0]) cylinder(r=6,h=50,$fn=32);
        }
      }
    }

    if (draw_laser) {
      translate([0,-cylinder_outer_radius-thickness/2,-thickness/2]) rotate([laser_unit_angle,0,0]) tool_holder_laser_laser(beam_length=beam_length,beam_angle=90,beam_width_angle=beam_width_angle);
      translate([0,cylinder_outer_radius+thickness/2,-thickness/2]) rotate([-laser_unit_angle,0,0]) tool_holder_laser_laser(beam_length=beam_length,beam_angle=90,beam_width_angle=beam_width_angle);
      translate([-cylinder_outer_radius-thickness/2,0,-thickness/2]) rotate([0,-laser_unit_angle,0]) tool_holder_laser_laser(beam_length=beam_length,beam_angle=0,beam_width_angle=beam_width_angle);
    }
  }
}

module bit() {
  color(steel_color) {
    difference() {
      cylinder(r=5/2,h=50,$fn=16);
      translate([0,0,-1]) cube([10,10,26]);
      translate([-10,-10,-1]) cube([10,10,26]);
    }
  }
}

module router(diameter=80,height=200,neck_diameter=50,neck_height=20,bit_holder_height=20,bit_holder_neck_diameter=10,bit_holder_nut=12) {
  color([0.3,0.3,0.3]) cylinder(r=diameter/2,h=height,$fn=64);
  color(aluminum_color) translate([0,0,-neck_height]) cylinder(r=neck_diameter/2,h=neck_height,$fn=64);

  color(steel_color) translate([0,0,-neck_height-bit_holder_height+10]) cylinder(r=bit_holder_neck_diameter/2,h=bit_holder_height-10,$fn=32);
  color(steel_color) translate([0,0,-neck_height-bit_holder_height]) cylinder(r=bit_holder_nut/2,h=10,$fn=6);

  translate([0,0,-neck_height-bit_holder_height-30]) bit();
}
