include <sbr.scad>
include <profiles.scad>
include <joints.scad>
include <mount_sheet.scad>
include <router.scad>

rail_length_x = 1100;
rail_length_y = 700;
rail_length_z = 300;

base_length=200;
base_height=50;
side_width=150;
side_height=455;
side_angle=11;
side_offset=60;
sbr16uu_offset=45;

profile_thickness = 3;
profile_l_width = 60;
profile_square_small_width = 40;
profile_square_large_width = 60;
plate_thickness = 15;
plate_stainless_thickness = 2;

frame_width=rail_length_y+sbr16uu_offset*2+plate_thickness*2+profile_thickness*2;
side_bottom=20-base_height/2;
side_bottom_width=side_width/cos(side_angle);
side_bottom_offset=(base_length-side_bottom_width)/2;

left_block_y=frame_width-sbr16uu_offset*2-plate_thickness*2;

beam_width=frame_width+plate_thickness*2;
beam_left=-sbr16uu_offset-plate_thickness*2;
beam_height=profile_square_small_width+profile_l_width*2;

offset_x = 200; //rail_length_x - base_length;
offset_y = 200; //rail_length_y-45*2-25-profile_thickness*2;
offset_z = 0; //rail_length_z-45*2;

aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];
wood_color=[0.5216,0.3686,0.2588];

module profile_square_small(length=20,log=true) {
  profile_o(width=profile_square_small_width,height=profile_square_small_width,thickness=profile_thickness,length=length,log=log);
}

module profile_L(length=20,log=true) {
  profile_l(width=profile_l_width,height=profile_l_width,thickness=profile_thickness,length=length,log=log);
}

module frame_x_stepper_mount(length=10) {
  // TODO: figure out the 2 mm extra spacing
  hole_center = -profile_square_small_width/2-profile_thickness-2;

  difference() {
    translate([profile_thickness,0,-profile_square_small_width-profile_thickness]) rotate([0,0,90]) profile_square_small(length=length);
    translate([-profile_square_small_width,length/2-profile_thickness,hole_center]) rotate([0,90,0]) cylinder(r=14,h=profile_square_small_width*1.2,$fn=32);
  }

  difference() {
    translate([-profile_square_small_width,0,0]) rotate([180,0,90]) profile_L(length=length);
    translate([-profile_square_small_width-profile_thickness,length/2-profile_thickness,hole_center]) rotate([0,90,0]) cylinder(r=20,h=profile_thickness*3,$fn=64);
  }

  difference() {
    translate([-profile_square_small_width,0,0]) rotate([90,0,90]) profile_L(length=length);
    translate([-profile_square_small_width-profile_thickness,-length/2,15]) cube([profile_thickness*3,length*2,profile_l_width]);
  }
}

module frame_x() {
  rail_negative_offset = base_length / 2 - 90;
  translate([rail_negative_offset, 0, 0]) {
    translate([-rail_negative_offset,0,0]) {
      translate([0,0,20]) rotate([90,0,0]) sbr16(length=rail_length_x);
      translate([-70,0,0]) rotate([0,0,0]) profile_L(length=rail_length_x+profile_square_small_width*3);

      translate([0,rail_length_y+profile_thickness*2,0]) {
        translate([0,0,20]) rotate([-90,0,0]) sbr16(length=rail_length_x);
        translate([-70,0,0]) rotate([90,0,0]) profile_L(length=rail_length_x+profile_square_small_width*3);
      }
    }

    translate([rail_length_x,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square_small(length=rail_length_y);
    translate([rail_length_x+profile_square_small_width,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square_small(length=rail_length_y);

    translate([profile_square_small_width*2,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square_small(length=rail_length_y);
    translate([profile_square_small_width,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square_small(length=rail_length_y);
    translate([0,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square_small(length=rail_length_y);
    translate([-profile_square_small_width,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square_small(length=rail_length_y);

    mount_width=rail_length_y/4;
    translate([-profile_square_small_width-11.6,profile_thickness*2+(rail_length_y-mount_width)/2,0]) frame_x_stepper_mount(length=mount_width);

    difference() {
      translate([29,profile_thickness+rail_length_y/2-profile_square_small_width,profile_thickness]) rotate([-90,0,90]) profile_L(length=profile_square_small_width*2);
      translate([0,profile_thickness+rail_length_y/2-profile_square_small_width*2,-profile_l_width*2+profile_thickness*2]) cube([profile_l_width,profile_square_small_width*4,profile_l_width*2]);
    }

    translate([rail_length_x-2,0,0]) difference() {
      translate([29,profile_thickness+rail_length_y/2-profile_square_small_width,profile_thickness]) rotate([-90,0,90]) profile_L(length=profile_square_small_width*2);
      translate([0,profile_thickness+rail_length_y/2-profile_square_small_width*2,-profile_l_width*2+profile_thickness*2]) cube([profile_l_width,profile_square_small_width*4,profile_l_width*2]);
    }

    translate([-profile_square_small_width*2-10,rail_length_y/2+profile_thickness,-22-profile_thickness]) rotate([0,90,0]) sbr16axis_with_mounts_and_motor(length=rail_length_x+50);
  }
}

module side(height=400,width=150,angle=10,offset=-10) {
  intersection() {
    translate([width,-plate_thickness,0]) rotate([90,-90-angle,0]) profile_flat(width=width,length=height*1.2, thickness=plate_thickness);
    translate([offset,-plate_thickness*2.5,0]) rotate([-90, -90, 0]) profile_flat(width=width*2,thickness=plate_thickness*2,length=height,log=false);
  }
}

module frame_y() {
  // Right side
  translate([0,0,20]) rotate([90,0,0]) sbr16uu();
  translate([base_length-sbr16uu_offset,0,20]) rotate([90,0,0]) sbr16uu();
  translate([0,-sbr16uu_offset,side_bottom]) rotate([90,0,0]) profile_flat(width=base_height,length=base_length, thickness=plate_thickness);
  translate([side_bottom_offset,-sbr16uu_offset,side_bottom]) side(height=side_height,width=side_width,angle=side_angle, offset=side_offset*-1);
  translate([side_bottom_offset-side_offset,-sbr16uu_offset-plate_thickness,side_bottom+side_height]) rotate([0,90,0]) profile_L(length=profile_l_width*2+profile_square_small_width);

  // Left side
  translate([0,left_block_y,20]) rotate([-90,0,0]) sbr16uu();
  translate([base_length-sbr16uu_offset,left_block_y,20]) rotate([-90,0,0]) sbr16uu();
  translate([0,frame_width-sbr16uu_offset-plate_thickness,side_bottom]) rotate([90,0,0]) profile_flat(width=base_height,length=base_length, thickness=plate_thickness);

  difference() {
    union() {
      translate([side_bottom_offset,frame_width-sbr16uu_offset+plate_thickness,side_bottom]) side(height=side_height,width=side_width,angle=side_angle, offset=side_offset*-1);
      translate([side_bottom_offset-side_offset,left_block_y+sbr16uu_offset+plate_thickness,side_bottom+side_height]) rotate([0,90,270]) profile_L(length=profile_l_width*2+profile_square_small_width);
    }
    translate([side_bottom_offset-side_offset+25,beam_left+beam_width+plate_thickness,side_bottom+side_height-beam_height/2]) rotate([90,0,0]) cylinder(r=15,h=plate_thickness*3,$fn=32);
  }

  // Top beam
  translate([side_bottom_offset-side_offset,beam_left,side_bottom+side_height-profile_square_small_width]) rotate([0,0,90]) profile_square_small(length=beam_width);
  translate([side_bottom_offset-side_offset,beam_left,side_bottom+side_height-profile_square_small_width*2]) rotate([0,0,90]) profile_square_small(length=beam_width);
  translate([side_bottom_offset-side_offset,beam_left,side_bottom+side_height-profile_square_small_width*3]) rotate([0,0,90]) profile_square_small(length=beam_width);
  translate([side_bottom_offset-side_offset,beam_left,side_bottom+side_height-profile_square_small_width*4]) rotate([0,0,90]) profile_square_small(length=beam_width);

  // Rails, axis and motor
  rail_offset=(beam_width-rail_length_y)/2;
  translate([side_bottom_offset-side_offset+25,beam_left+rail_offset+rail_length_y+78,side_bottom+side_height-beam_height/2]) rotate([90,0,0]) sbr16axis_with_mounts_and_motor(length=rail_length_y+50);
  translate([side_bottom_offset-side_offset,beam_left+rail_offset,side_bottom+side_height-20]) rotate([90,0,90]) sbr16(length=rail_length_y);
  translate([side_bottom_offset-side_offset,beam_left+rail_offset,side_bottom+side_height+20-beam_height]) rotate([90,0,90]) sbr16(length=rail_length_y);

  // Bottom beam
  // TODO: Fix small missalignment and measutements of t plates
  color(steel_color) translate([side_bottom_offset+side_bottom_width,beam_left,side_bottom-plate_stainless_thickness]) rotate([0,0,90]) joint_t(width_a=plate_thickness*2,width_b=profile_square_small_width,length_a=side_width,thickness=plate_stainless_thickness);
  color(steel_color) translate([side_bottom_offset,beam_left+beam_width,side_bottom-plate_stainless_thickness]) rotate([0,0,270]) joint_t(width_a=plate_thickness*2,width_b=profile_square_small_width,length_a=side_width,thickness=plate_stainless_thickness);

  difference() {
    translate([(base_length+profile_square_small_width)/2,beam_left,side_bottom-profile_square_small_width-plate_stainless_thickness]) rotate([0,0,90]) profile_square_small(length=beam_width);
    translate([rail_offset,beam_left+beam_width/2,side_bottom-plate_stainless_thickness-profile_square_small_width/2-profile_thickness+5]) rotate([0,90,0]) cylinder(r=9,h=profile_thickness*3,$fn=32);
    translate([rail_offset+profile_square_small_width-profile_thickness,beam_left+beam_width/2,side_bottom-plate_stainless_thickness-profile_square_small_width/2-profile_thickness+5]) rotate([0,90,0]) cylinder(r=14,h=profile_thickness*3,$fn=32);
  }

  translate([(base_length-profile_square_small_width)/2+profile_square_small_width+10,beam_left+beam_width/2,side_bottom-plate_stainless_thickness-profile_square_small_width/2-profile_thickness+5]) rotate([0,-90,0]) axis_nut();
}

module frame_z() {
  offset_z_plate = 5;
  offset_y_separation = 25;

  //translate([beam_left+profile_square_small_width,profile_thickness,side_bottom+side_height-profile_square_small_width*4]) {
  translate([-side_offset+10,profile_thickness,side_bottom+side_height-profile_square_small_width*4]) {
    // Rail sliders
    translate([13.3,0,profile_square_small_width*4-20]) rotate([90,0,90]) sbr16uu();
    translate([13.3,profile_thickness*2+45+offset_y_separation,profile_square_small_width*4-20]) rotate([90,0,90]) sbr16uu();
    translate([13.3,0,profile_square_small_width-20]) rotate([90,0,90]) sbr16uu();
    translate([13.3,profile_thickness*2+45+offset_y_separation,profile_square_small_width-20]) rotate([90,0,90]) sbr16uu();

    // Frame
    difference() {
      translate([profile_l_width+profile_thickness/2,45+profile_thickness+offset_y_separation,-offset_z_plate-30]) rotate([0,-90,0]) profile_L(length=rail_length_z+90);

      translate([0,offset_y_separation,0]) {
        translate([-40,45-profile_thickness,-rail_length_z+profile_square_small_width*4+profile_thickness]) cube([profile_l_width,profile_thickness*4,rail_length_z]);
        translate([0,45-profile_thickness,7.5]) cube([50,profile_thickness*4,25]);
        translate([0,45-profile_thickness,7.5+profile_square_small_width*3]) cube([50,profile_thickness*4,25]);
        translate([profile_thickness+35.3,45-profile_thickness,profile_square_small_width*2]) rotate([0,90,90]) cylinder(r=14,h=profile_thickness*4,$fn=32);
      }
    }

    difference() {
      translate([profile_l_width+profile_thickness/2,45+profile_thickness,rail_length_z-offset_z_plate+30+30]) rotate([0,90,180]) profile_L(length=rail_length_z+90);

      translate([-40,45-profile_thickness,-rail_length_z+profile_square_small_width*4+profile_thickness]) cube([profile_l_width,profile_thickness*4,rail_length_z]);
      translate([0,45-profile_thickness,7.5]) cube([50,profile_thickness*4,25]);
      translate([0,45-profile_thickness,7.5+profile_square_small_width*3]) cube([50,profile_thickness*4,25]);
      translate([profile_thickness+35.3,45-profile_thickness,profile_square_small_width*2]) rotate([0,90,90]) cylinder(r=14,h=profile_thickness*4,$fn=32);
    }

    translate([1.5,45+profile_thickness,rail_length_z-offset_z_plate+45]) profile_flat(width=offset_y_separation,length=profile_l_width, thickness=plate_thickness);
    translate([20,45+profile_thickness,-30-offset_z_plate]) profile_flat(width=offset_y_separation,length=41.5, thickness=plate_thickness);

    // Motor mount
    translate([profile_l_width+1.5,-profile_thickness-9,rail_length_z-offset_z_plate+60]) {
      difference() {
        rotate([0,180,-90]) profile_L(length=profile_l_width*2+offset_y_separation);
        translate([25,(profile_l_width*2+offset_y_separation)/2,-profile_thickness*2]) rotate([0,0,0]) cylinder(r=20,h=profile_thickness*3,$fn=32);
      }

      difference() {
        translate([profile_thickness,0,-profile_thickness]) rotate([0,180,-90]) profile_square_small(length=profile_l_width*2+offset_y_separation);
        translate([25,(profile_l_width*2+offset_y_separation)/2,-profile_square_small_width*2]) rotate([0,0,0]) cylinder(r=14,h=profile_square_small_width*3,$fn=32);
      }
    }

    // Rail Y nut
    translate([profile_thickness+35.3,45+offset_y_separation+profile_thickness*2+10,profile_square_small_width*2]) rotate([90,0,0]) axis_nut();

    // Rails
    translate([13.5+45+profile_thickness,8,rail_length_z-offset_z_plate]) rotate([0,90,0]) sbr16(length=rail_length_z);
    translate([13.5+45+profile_thickness,8+profile_l_width*2-40+offset_y_separation,rail_length_z-offset_z_plate]) rotate([0,90,0]) sbr16(length=rail_length_z);

    // Screw and motor
    translate([profile_l_width+profile_thickness/2+25,18-30+profile_l_width+offset_y_separation/2,rail_length_z+53.5]) rotate([0,180,180]) sbr16axis_with_mounts_and_motor(length=rail_length_z+50);
  }
}

module frame_tool() {
  offset_y_separation = 25;

  //translate([beam_left+profile_square_small_width+13.5+45+3,profile_thickness+8,side_bottom+side_height-profile_square_small_width*4+40]) {
  translate([-side_offset+sbr16uu_offset+26.5,profile_thickness+8,side_bottom+side_height-profile_square_small_width*4+40]) {
    translate([0,0,0]) rotate([0,90,0]) sbr16uu();
    translate([0,0,45]) rotate([0,90,0]) sbr16uu();
    translate([0,profile_l_width*2+offset_y_separation-40,0]) rotate([0,90,0]) sbr16uu();
    translate([0,profile_l_width*2+offset_y_separation-40,45]) rotate([0,90,0]) sbr16uu();

    // Rail Z nut
    translate([45,25,-30]) {
      difference() {
        rotate([0,0,90]) profile_square_small(length=55);
        translate([-20,55/2,-profile_square_small_width]) rotate([0,0,0]) cylinder(r=14,h=profile_square_small_width*3);
      }
      translate([-20,55/2,-10]) rotate([0,0,0]) axis_nut();
    }

    translate([45,-27.5,45+30]) rotate([0,90,0]) profile_flat(width=160,length=320, thickness=plate_thickness);

    // Tool
    translate([45+plate_thickness,0,-80]) {
      translate([0,-27.5+(160-149)/2,0]) rotate([0,90,0]) router_mount();
      translate([4+12+80/2,-27.5+160/2,-130]) rotate([0,0,0]) router();
    }
  }
}

frame_x();
translate([profile_square_small_width*2+10,profile_thickness,profile_thickness]) mount_sheet(length=rail_length_x-profile_square_small_width*3,width=rail_length_y);
translate([offset_x,0,0]) {
  frame_y();
  translate([0,offset_y,0]) {
    frame_z();
    translate([0,0,offset_z]) {
      frame_tool();
    }
  }
}
