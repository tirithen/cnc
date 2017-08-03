include <list.scad>
include <cuts.scad>
include <joints.scad>
include <sbr.scad>
include <profiles.scad>
include <tool.scad>

cnc_rail_dimensions=[1100,700,300];
aluminum_thickness=5;
//TODO: Fix x rail at 0 with aluminum_thickness = 3
aluminum_thickness_thin=3;
mount_sheet_thickness=50;

aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];
wood_color=[0.5216,0.3686,0.2588];

module mount_sheet(x=1100,y=700,thickness=50,slide_spacing=70,slide_shaft_width=5,slide_shaft_height=10,slide_head_width=8,slide_head_height=5,slide_play=0.1) {
  slides = floor((y-slide_spacing)/slide_spacing);
  slides_offset = (y-slides*slide_spacing)/2-slide_spacing/2;

  color(wood_color) {
    difference() {
      cube([x,y,thickness]);
      for(i=[1:slides]) {
        translate([-1,i*slide_spacing+slides_offset,thickness-slide_shaft_height]) {
          translate([slide_spacing,-slide_shaft_width/2-slide_play,-1]) cube([x-slide_spacing*2,slide_shaft_width+slide_play*2,slide_shaft_height+2]);
          translate([slide_spacing-(slide_head_width-slide_shaft_width)/2,-slide_head_width/2-slide_play,-slide_head_height]) cube([x-slide_spacing*2+(slide_head_width-slide_shaft_width),slide_head_width+slide_play*2,slide_head_height]);

          hole_spacing=slide_spacing*3;
          holes = floor((x-hole_spacing)/hole_spacing);
          holes_offset = (x-holes*hole_spacing)/2-hole_spacing/2;

          for(j=[1:holes]) {
            translate([j*hole_spacing+holes_offset,0,-1]) cylinder(r=(slide_head_width+slide_play*2)/2,h=slide_shaft_height+3);
          }
        }
      }
    }
  }
}

module frame_x(x=1100,y=700,thickness=5) {
  translate([0,-thickness,20-thickness]) rotate([90,0,0]) sbr16(length=x);
  translate([0,y+thickness,20-thickness]) rotate([-90,0,0]) sbr16(length=x);

  color(aluminum_color) {
    translate([-60,-thickness,-thickness]) profile_l(width=60,height=40,thickness=thickness,length=x+60*2);
    translate([-60,y+thickness,-thickness]) rotate([90,0,0]) profile_l(width=40,height=60,thickness=thickness,length=x+60*2);
    rotate([0,0,90]) profile_o(width=60,height=40,length=y);
    translate([x+60,0,0]) rotate([0,0,90]) profile_o(width=60,height=40,length=y);
  }
}

module frame_y(y=700,z=300,width=200,thickness=5,thickness_thin=3,thickness_side_plate=12) {
  translate([0,0,-10]) {
    translate([0,-thickness,25]) rotate([90,0,0]) sbr16uu();
    translate([0,y+thickness,25]) rotate([-90,0,0]) sbr16uu();
    translate([width-45,-thickness,25]) rotate([90,0,0]) sbr16uu();
    translate([width-45,y+thickness,25]) rotate([-90,0,0]) sbr16uu();

    side_thickness = 45+40+thickness;
    side_height=z+100;

    // Right side
    color(aluminum_color) {
      translate([40,-thickness_side_plate-side_thickness,0]) cube([(width-80)/2,thickness_side_plate,side_height]);
      translate([0,-side_thickness,0]) {
        difference() {
          profile_o(width=40,height=60,thickness=thickness,length=width);
          translate([0,0,60]) rotate([180,0,90]) angle_cut(width=40,angle=45,thickness=60);
          translate([width,0,0]) rotate([0,0,90]) angle_cut(width=40,angle=45,thickness=60);
        }
      }
    }

    // Left side
    color(aluminum_color) {
      translate([40,y+side_thickness,0]) cube([(width-80)/2,thickness_side_plate,side_height]);
      translate([0,y+thickness+45,0]) {
        difference() {
          profile_o(width=40,height=60,thickness=thickness,length=width);
          translate([width,40,60]) rotate([0,180,90]) angle_cut(width=40,angle=45,thickness=60);
          translate([0,40,0]) rotate([180,180,90]) angle_cut(width=40,angle=45,thickness=60);
        }
      }
    }

    // Bottom side
    color(steel_color) {
      translate([width/2-width/4,-side_thickness,0]) rotate([180,0,90])
      joint_t(width_a=40,length_a=width/2,width_b=40,length_b=180);

      translate([width-width/4,y+side_thickness,0]) rotate([180,0,270])
      joint_t(width_a=40,length_a=width/2,width_b=40,length_b=180);
    }

    color(aluminum_color) {
      translate([width/2-40/2,-side_thickness,-2]) {
        difference() {
          rotate([180,0,90]) profile_u(width=40,height=20,length=y+(side_thickness)*2,thickness=thickness_thin);
          translate([40,0,-20]) rotate([0,270,0]) angle_cut(width=20,angle=45,thickness=40);
          translate([0,y+side_thickness*2,-20]) rotate([90,270,90]) angle_cut(width=20,angle=45,thickness=40);
        }
      }
    }

    // Linear bearings
    translate([40,0,side_height-20]) rotate([90,0,90]) sbr16(length=y);
    color(aluminum_color) translate([40,-side_thickness-thickness_side_plate,side_height-40]) rotate([0,0,90]) profile_l(width=40,height=40,length=y+side_thickness*2+thickness_side_plate*2,thickness=thickness);

    translate([40,y,side_height-20-100]) rotate([-90,0,-90]) sbr16(length=y);
    color(aluminum_color) translate([40,y+side_thickness+thickness_side_plate,side_height-100]) rotate([0,180,90]) profile_l(width=40,height=40,length=y+side_thickness*2+thickness_side_plate*2,thickness=thickness);

    color(aluminum_color) translate([40,y+side_thickness+thickness_side_plate,side_height-40]) rotate([0,180,90]) profile_o(width=40,height=60,length=y+side_thickness*2+thickness_side_plate*2,thickness=thickness);
  }
}

module frame_z(z=300,width=100,thickness=5) {
  side_height=z+100;
  y_offset=side_height-10+(z-40-60-40)/2;

  translate([40,0,y_offset]) {
    translate([0,0,-z/2+50]) rotate([90,0,90]) sbr16uu();
    translate([0,width-45,-z/2+50]) rotate([90,0,90]) sbr16uu();
    translate([0,0,-z/2-50]) rotate([90,0,90]) sbr16uu();
    translate([0,width-45,-z/2-50]) rotate([90,0,90]) sbr16uu();

    translate([45,20,0]) rotate([0,90,0]) sbr16(length=z);
    translate([45,width-20,0]) rotate([0,90,0]) sbr16(length=z);

    color(aluminum_color) {
      translate([45-thickness,width,thickness]) rotate([90,180,90]) profile_l(width=60,height=60,length=width,thickness=thickness);

      difference() {
        translate([45+thickness,width-45,0]) rotate([0,90,90]) profile_l(width=40,height=45,length=z,thickness=thickness);
        translate([-1,-1,-z/2+50-22.5]) cube([45+1,width+2,z]);
        translate([-1,-1,-z*1.5-50+22.5]) cube([45+1,width+2,z]);
      }

      difference() {
        translate([45+thickness,45,0]) rotate([0,90,180]) profile_l(width=45,height=40,length=z,thickness=thickness);
        translate([-1,-1,-z/2+50-22.5]) cube([45+1,width+2,z]);
        translate([-1,-1,-z*1.5-50+22.5]) cube([45+1,width+2,z]);
      }

      translate([45,0,-z])
      rotate([0,0,90])
      profile_l(width=40,height=40,length=width,thickness=thickness);
    }
  }
}

module frame_tool(z=300,width=100,thickness=5,highest_tool_holder_position=250,draw_laser=false) {
  side_height=z+100;
  y_offset=side_height-10+(z-40-60-40)/2;
  slide_height=z/2;

  translate([40,0,y_offset]) {
    translate([45,20,0]) rotate([0,90,0]) sbr16uu();
    translate([45,20,-45-20]) rotate([0,90,0]) sbr16uu();
    translate([45,width-20,0]) rotate([0,90,0]) sbr16uu();
    translate([45,width-20,-45-20]) rotate([0,90,0]) sbr16uu();

    color(aluminum_color) {
      translate([thickness+40+45+5,width-60,0]) rotate([0,90,90]) profile_l(width=40,height=60,length=slide_height,thickness=thickness);
      translate([thickness+40+45+5,60,0]) rotate([180,90,0]) profile_l(width=60,height=40,length=slide_height,thickness=thickness);
    }

    translate([thickness+40+45+5,0,-slide_height]) {
      tool_holder_laser(tool_diameter=50,width=width,,beam_width_angle=70,laser_unit_angle=0,draw_laser=draw_laser);
      translate([0,0,highest_tool_holder_position]) tool_holder(tool_diameter=100,width=width);
    }
  }
}

frame_x(x=cnc_rail_dimensions[0],y=cnc_rail_dimensions[1],thickness=aluminum_thickness);

mount_sheet(x=cnc_rail_dimensions[0],y=cnc_rail_dimensions[1],thickness=mount_sheet_thickness);

translate([0,0,0]) { // Max (with 1100 mm rail) is 1100-300=800
  frame_y(y=cnc_rail_dimensions[1],z=cnc_rail_dimensions[2],width=300,thickness=aluminum_thickness,thickness_thin=aluminum_thickness_thin);

  translate([0,0,0]) { // Max (with 700 mm rail) is 700-150=550
    frame_z(z=cnc_rail_dimensions[2],width=150,thickness=aluminum_thickness);

    translate([0,0,-190]) { // Max (with 300 mm rail) is 300-45*2-20=190
      frame_tool(z=cnc_rail_dimensions[2],width=150,thickness=aluminum_thickness,highest_tool_holder_position=cnc_rail_dimensions[2]/2-45-16,draw_laser=false);
    }
  }
}

color([0.5,0.5,1,0.2]) translate([210,150/2,mount_sheet_thickness]) cube([cnc_rail_dimensions[0]-300,cnc_rail_dimensions[1]-150,cnc_rail_dimensions[2]-45*2+20]);
