include <list.scad>
include <cuts.scad>
include <joints.scad>
include <sbr.scad>
include <profiles.scad>
include <tool.scad>
include <foot.scad>

cnc_rail_dimensions=[1100,700,300];
y_side_height=cnc_rail_dimensions[2]+90;
y_side_thickness=12;
y_slide_width=300;
z_slide_width=150;
mount_sheet_margin=25;
mount_sheet_margin_last=30;
mount_sheet_offset_x=125;
mount_sheet_thickness=40;
mount_sheet_slide_spacing=70;
mount_sheet_slide_play=0;
mount_sheet_width=cnc_rail_dimensions[1]-z_slide_width+mount_sheet_margin*2;
mount_sheet_length=cnc_rail_dimensions[0]-60*2-mount_sheet_offset_x;
mount_sheet_border_thickness=mount_sheet_thickness+8;
thickness=4;
//TODO: Fix x rail at 0 with thickness = 3

aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];
wood_color=[0.5216,0.3686,0.2588];

module mount_sheet(length=1100,width=700,thickness=40,border_thickness=45,border_margin=25,border_margin_last=30,slide_spacing=70,slide_shaft_width=5,slide_shaft_height=10,slide_head_width=8,slide_head_height=5,slide_play=0.1) {
  slides = floor((width-slide_spacing)/slide_spacing);
  slides_offset = (width-slides*slide_spacing)/2-slide_spacing/2;

  translate([0,0,0]) {
    color(wood_color) {
      difference() {
        cube([length,width,border_thickness]);

        translate([border_margin,border_margin,thickness]) cube([length-border_margin-border_margin_last,width-border_margin*2,border_thickness-thickness+1]);

        translate([border_margin,border_margin,thickness]) cylinder(r=2.5,h=border_thickness-thickness+1,$fn=32);

        translate([border_margin,width-border_margin,thickness]) cylinder(r=2.5,h=border_thickness-thickness+1,$fn=32);

        translate([length-border_margin_last,border_margin,thickness]) cylinder(r=2.5,h=border_thickness-thickness+1,$fn=32);

        translate([length-border_margin_last,width-border_margin,thickness]) cylinder(r=2.5,h=border_thickness-thickness+1,$fn=32);

        for(i=[1:slides]) {
          translate([-1,i*slide_spacing+slides_offset,thickness-slide_shaft_height]) {
            translate([border_margin*2,-slide_shaft_width/2-slide_play,-1]) cube([length-(border_margin+border_margin_last+border_margin*2),slide_shaft_width+slide_play*2,slide_shaft_height+2]);
            translate([border_margin*2-(slide_head_width-slide_shaft_width)/2,-slide_head_width/2-slide_play,-slide_head_height]) cube([length-(border_margin+border_margin_last+border_margin*2)+(slide_head_width-slide_shaft_width),slide_head_width+slide_play*2,slide_head_height]);

            hole_spacing=slide_spacing*2.5;
            holes = floor((length-hole_spacing)/hole_spacing);
            holes_offset = (length-holes*hole_spacing)/2-hole_spacing/2;

            for(j=[1:holes]) {
              translate([j*hole_spacing+holes_offset,0,-1]) cylinder(r=(slide_head_width+slide_play*2)/2,h=slide_shaft_height+3);
            }
          }
        }
      }
    }
  }
}

module frame_x(x=1100,y=700,thickness=5,mount_sheet_width=700,mount_sheet_thickness=40,mount_sheet_offset_x=125) {
  rail_offset = 32 + 60 * 2;
  frame_length = x + rail_offset;

  translate([rail_offset,-thickness,20]) rotate([90,0,0]) sbr16(length=x);
  translate([rail_offset,mount_sheet_width+thickness,20]) rotate([-90,0,0]) sbr16(length=x);

  color(aluminum_color) {
    translate([0,-thickness,0]) profile_l(width=60,height=40,thickness=thickness,length=frame_length);
    translate([0,mount_sheet_width+thickness,0]) rotate([90,0,0]) profile_l(width=40,height=60,thickness=thickness,length=frame_length);

    translate([60,0,thickness]) rotate([0,0,90]) profile_o(width=60,height=40,length=mount_sheet_width,thickness=thickness);
    translate([60*2,0,thickness]) rotate([0,0,90]) profile_o(width=60,height=40,length=mount_sheet_width,thickness=thickness);
    translate([rail_offset + mount_sheet_offset_x,0,thickness]) rotate([0,0,90]) profile_o(width=60,height=40,length=mount_sheet_width,thickness=thickness);
    translate([frame_length-60,0,thickness]) rotate([0,0,90]) profile_o(width=60,height=40,length=mount_sheet_width,thickness=thickness);
    translate([frame_length,0,thickness]) rotate([0,0,90]) profile_o(width=60,height=40,length=mount_sheet_width,thickness=thickness);
  }

  translate([0,-thickness,-40]) foot(width=60,height=40,length=60,thickness=thickness);
  translate([0,mount_sheet_width+thickness-60,-40]) foot(width=60,height=40,length=60,thickness=thickness);
  translate([x+rail_offset-65,-thickness,-40]) foot(width=60,height=40,length=65,thickness=thickness);
  translate([x+rail_offset-65,mount_sheet_width+thickness-60,-40]) foot(width=60,height=40,length=65,thickness=thickness);

  // Motor and screw
  translate([1.4,mount_sheet_width/2,-20]) rotate([0,90,0]) sbr16axis_with_mounts_and_motor(length=x+50);
}

module frame_y(y=700,z=300,y_side_height=420,width=200,thickness=5,thickness_side_plate=12,mount_sheet_width=750) {
  side_thickness = 45+40+thickness+thickness_side_plate;
  slide_width=mount_sheet_width+side_thickness*2;

  translate([0,0,-50]) {
    translate([0,-thickness,25]) rotate([90,0,0]) sbr16uu();
    translate([width-45,-thickness,25]) rotate([90,0,0]) sbr16uu();
    translate([0,mount_sheet_width+thickness,25]) rotate([-90,0,0]) sbr16uu();
    translate([width-45,mount_sheet_width+thickness,25]) rotate([-90,0,0]) sbr16uu();

    // Right side
    color(aluminum_color) {
      translate([40,-side_thickness,0]) cube([(width-80)/2,thickness_side_plate,y_side_height]);
      translate([0,-side_thickness+thickness_side_plate,0]) {
        difference() {
          profile_o(width=40,height=60,thickness=thickness,length=width);
          translate([0,0,60]) rotate([180,0,90]) angle_cut(width=40,angle=45,thickness=60);
          translate([width,0,0]) rotate([0,0,90]) angle_cut(width=40,angle=45,thickness=60);
        }
      }
    }

    // Left side
    color(aluminum_color) {
      translate([40,slide_width-side_thickness-thickness_side_plate,0]) cube([(width-80)/2,thickness_side_plate,y_side_height]);
      translate([0,slide_width-side_thickness-thickness_side_plate-40,0]) {
        difference() {
          profile_o(width=40,height=60,thickness=thickness,length=width);
          translate([width,40,60]) rotate([0,180,90]) angle_cut(width=40,angle=45,thickness=60);
          translate([0,40,0]) rotate([180,180,90]) angle_cut(width=40,angle=45,thickness=60);
        }
      }
    }

    // Bottom side
    color(steel_color) {
      translate([width/2-width/4,-side_thickness+thickness_side_plate,0]) rotate([180,0,90])
      joint_t(width_a=40,length_a=width/2,width_b=40,length_b=180);

      translate([width-width/4,slide_width-side_thickness-thickness_side_plate,0]) rotate([180,0,270])
      joint_t(width_a=40,length_a=width/2,width_b=40,length_b=180);
    }

    color(aluminum_color) {
      translate([width/2-40/2,-side_thickness+thickness_side_plate,-2]) {
        difference() {
          rotate([180,0,90]) profile_u(width=40,height=20,length=slide_width-thickness_side_plate*2,thickness=thickness);
          translate([40,0,-20]) rotate([0,270,0]) angle_cut(width=20,angle=45,thickness=40);
          translate([0,slide_width-thickness_side_plate*2,-20]) rotate([90,270,90]) angle_cut(width=20,angle=45,thickness=40);
        }
      }
    }

    // Linear bearings
    translate([40,-50,y_side_height-20]) rotate([90,0,90]) sbr16(length=y);
    color(aluminum_color) translate([40,-side_thickness,y_side_height-40]) rotate([0,0,90]) profile_l(width=40,height=40,length=slide_width,thickness=thickness);

    translate([40,y-50,y_side_height-20-100]) rotate([-90,0,-90]) sbr16(length=y);
    color(aluminum_color) translate([40,slide_width-side_thickness,y_side_height-100]) rotate([0,180,90]) profile_l(width=40,height=40,length=slide_width,thickness=thickness);

    color(aluminum_color) translate([40,slide_width-side_thickness,y_side_height-40]) rotate([0,180,90]) profile_o(width=40,height=60,length=slide_width,thickness=thickness);

    // Motor and screw
//    translate([25+40,-133.5+10,y_side_height-(40*2+60)/2]) rotate([90,0,0]) sbr16axis_with_mounts_and_motor(length=y+50);
    translate([25+40,y+23.5,y_side_height-(40*2+60)/2]) rotate([90,0,0]) sbr16axis_with_mounts_and_motor(length=y+50);
  }
}

module frame_z(z=300,y_side_height=420,width=100,thickness=5) {
  y_bearing_placement=22;
  y_offset=y_side_height-10+(z-40-60-40)/2-y_bearing_placement;
  above_rail_height=78.5;

  translate([40,-50,y_offset]) {
    translate([0,0,-z/2+55+y_bearing_placement]) rotate([90,0,90]) sbr16uu();
    translate([0,width-45,-z/2+55+y_bearing_placement]) rotate([90,0,90]) sbr16uu();
    translate([0,0,-z/2-45+y_bearing_placement]) rotate([90,0,90]) sbr16uu();
    translate([0,width-45,-z/2-45+y_bearing_placement]) rotate([90,0,90]) sbr16uu();

    translate([45+thickness,20,0]) rotate([0,90,0]) sbr16(length=z);
    translate([45+thickness,width-20,0]) rotate([0,90,0]) sbr16(length=z);

    color(aluminum_color) {
      translate([45-thickness,width,thickness+above_rail_height]) rotate([90,180,90]) profile_l(width=60,height=60,length=width,thickness=thickness);
      translate([45,width,thickness+above_rail_height-60]) rotate([0,180,90]) profile_l(width=60,height=60,length=width,thickness=thickness);

      difference() {
        translate([45+thickness,width-60,above_rail_height]) rotate([0,90,90]) profile_l(width=40,height=60,length=z+above_rail_height,thickness=thickness);
        translate([-1,-1,-z/2-45+y_bearing_placement+22.5-z]) cube([45+1,width+2,z]);
        translate([-1,-1,-z/2+55+y_bearing_placement-22.5]) cube([45+1,width+2,z]);
      }


      difference() {
        translate([45+thickness,60,above_rail_height]) rotate([0,90,180]) profile_l(width=60,height=40,length=z+above_rail_height,thickness=thickness);
        translate([-1,-1,-z/2-45+y_bearing_placement+22.5-z]) cube([45+1,width+2,z]);
        translate([-1,-1,-z/2+55+y_bearing_placement-22.5]) cube([45+1,width+2,z]);
      }

      translate([45,0,-z])
      rotate([0,0,90])
      profile_l(width=40,height=40,length=width,thickness=thickness);
    }

    // Motor and screw
    translate([25+45+thickness,width/2,y_side_height-thickness-z-50+40+2]) rotate([0,180,180]) sbr16axis_with_mounts_and_motor(length=z+50);
  }
}

module frame_tool(z=300,y_side_height=420,width=100,thickness=5,tool_holder_thickness=12,lowest_tool_holder_diameter=50,highest_tool_holder_diameter=80,highest_tool_holder_position=250,tool_center_distance=45,draw_laser=false,draw_router=false) {
  y_offset=y_side_height-10+(z-40-60-40)/2-22;
  slide_height=z/2;

  translate([40+thickness,-50,y_offset]) {
    translate([45,20,0]) rotate([0,90,0]) sbr16uu();
    translate([45,20,-45-20]) rotate([0,90,0]) sbr16uu();
    translate([45,width-20,0]) rotate([0,90,0]) sbr16uu();
    translate([45,width-20,-45-20]) rotate([0,90,0]) sbr16uu();

    color(aluminum_color) {
      difference() {
        translate([thickness+40+45+5,width-60,0]) rotate([0,90,90]) profile_l(width=40,height=60,length=slide_height,thickness=thickness);
        translate([45-1,width-60-1,-9]) cube([45, 10, 11]);
        translate([45-1,width-60-1,-slide_height]) cube([45, 10, 60+1]);
      }

      difference() {
        translate([thickness+40+45+5,60,0]) rotate([180,90,0]) profile_l(width=60,height=40,length=slide_height,thickness=thickness);
        translate([45-1,60-10+1,-9]) cube([45, 10, 11]);
        translate([45-1,60-10+1,-slide_height]) cube([45, 10, 60+1]);
      }
    }

    translate([thickness+40+45+5,0,-slide_height]) {
      tool_holder_laser(tool_diameter=lowest_tool_holder_diameter,width=width,tool_center_distance=tool_center_distance,beam_length=400,beam_width_angle=30,laser_unit_angle=24.5,draw_laser=draw_laser,thickness=tool_holder_thickness);
      translate([0,0,highest_tool_holder_position]) tool_holder(tool_diameter=highest_tool_holder_diameter,width=width,tool_center_distance=tool_center_distance,thickness=tool_holder_thickness);
      if (draw_router) {
        translate([tool_center_distance,width/2,tool_holder_thickness+0]) router(diameter=highest_tool_holder_diameter,neck_diameter=lowest_tool_holder_diameter);
      }
    }
  }
}

translate([78,thickness+45+40+12,40+thickness]) {
  frame_x(x=cnc_rail_dimensions[0],y=cnc_rail_dimensions[1],thickness=thickness,mount_sheet_width=mount_sheet_width,mount_sheet_offset_x=mount_sheet_offset_x);

  translate([60*2+32+mount_sheet_offset_x,0,thickness]) {
    mount_sheet(length=mount_sheet_length,width=mount_sheet_width,thickness=mount_sheet_thickness,border_thickness=mount_sheet_border_thickness,border_margin=mount_sheet_margin,border_margin_last=mount_sheet_margin_last,slide_spacing=mount_sheet_slide_spacing);

    // Maximum cutting area
    //color([0.5,0.5,1,0.2]) translate([mount_sheet_margin,mount_sheet_margin,0]) cube([cnc_rail_dimensions[0]-y_slide_width,cnc_rail_dimensions[1]-z_slide_width,cnc_rail_dimensions[2]-70]);
  }

  translate([0,0,0]) { // Max (with 1100 mm rail) is 1100-300=800
    translate([60*2+32,0,45]) frame_y(y=cnc_rail_dimensions[1],z=cnc_rail_dimensions[2],y_side_height=y_side_height+thickness,width=y_slide_width,thickness=thickness,mount_sheet_width=mount_sheet_width);

    translate([60*2+32,550/2,0]) { // Max (with 700 mm rail) is 700-150=550
      frame_z(z=cnc_rail_dimensions[2],y_side_height=y_side_height+thickness,width=z_slide_width,thickness=thickness);

      translate([0,0,-80]) { // Max (with 300 mm rail) is 300-45*2-20=190
        frame_tool(z=cnc_rail_dimensions[2],y_side_height=y_side_height+thickness,width=z_slide_width,thickness=thickness,highest_tool_holder_position=cnc_rail_dimensions[2]/2-45-16,highest_tool_holder_diameter=80,highest_tool_holder_diameter=80,tool_center_distance=z_slide_width/2-thickness,draw_laser=true,draw_router=true);
      }
    }
  }
}

// Workshop footprint
//color([0.5,0.5,1,0.2]) cube([cnc_rail_dimensions[0]+166.6,cnc_rail_dimensions[1]+205.1,cnc_rail_dimensions[2]+349.6]);
