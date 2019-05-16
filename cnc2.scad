include <sbr.scad>
include <profiles.scad>

profile_thickness = 3;
profile_l_width = 60;
profile_square_width = 40;
plate_thickness = 15;

rail_length_x = 1100;
rail_length_y = 700;
rail_length_z = 300;

module profile_square(length=20,log=true) {
  profile_o(width=profile_square_width,height=profile_square_width,thickness=profile_thickness,length=length,log=log);
}

module profile_L(length=20,log=true) {
  profile_l(width=profile_l_width,height=profile_l_width,thickness=profile_thickness,length=length,log=log);
}

module frame_x_stepper_mount(length=10) {
  difference() {
    translate([profile_thickness,0,-profile_square_width-profile_thickness]) rotate([0,0,90]) profile_square(length=length);
    translate([-profile_square_width,length/2-profile_thickness,-profile_thickness/2-profile_square_width/2]) rotate([0,90,0]) cylinder(r=15,h=profile_square_width*1.5,$fn=32);
  }

  difference() {
    translate([-profile_square_width,0,0]) rotate([180,0,90]) profile_L(length=length);
    translate([-profile_square_width-profile_thickness,length/2-profile_thickness,-profile_thickness/2-profile_square_width/2]) rotate([0,90,0]) cylinder(r=20,h=profile_thickness*3,$fn=64);
  }

  difference() {
    translate([-profile_square_width,0,0]) rotate([90,0,90]) profile_L(length=length);
    translate([-profile_square_width-profile_thickness,-length/2,15]) cube([profile_thickness*3,length*2,profile_l_width]);
  }
}

module frame_x() {
  translate([0,0,20]) rotate([90,0,0]) sbr16(length= rail_length_x);
  translate([-profile_square_width*2,0,0]) rotate([0,0,0]) profile_L(length=rail_length_x+profile_square_width*3);

  translate([0,rail_length_y+profile_thickness*2,0]) {
    translate([0,0,20]) rotate([-90,0,0]) sbr16(length=rail_length_x);
    translate([-profile_square_width*2,0,0]) rotate([90,0,0]) profile_L(length=rail_length_x+profile_square_width*3);
  }

  translate([rail_length_x,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square(length=rail_length_y);
  translate([rail_length_x+profile_square_width,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square(length=rail_length_y);
  translate([profile_square_width,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square(length=rail_length_y);
  translate([0,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square(length=rail_length_y);
  translate([-profile_square_width,profile_thickness,profile_thickness]) rotate([0,0,90]) profile_square(length=rail_length_y);

  mount_width=rail_length_y/4;
  translate([-profile_square_width-11.6,profile_thickness+(rail_length_y-mount_width)/2,0]) frame_x_stepper_mount(length=mount_width);

  translate([-profile_square_width*2-10,rail_length_y/2,-22]) rotate([0,90,0]) sbr16axis_with_mounts_and_motor(length=rail_length_x+50);
}

module side(height=400,width=150,angle=10,offset=-10) {
  intersection() {
    translate([width,-plate_thickness,0]) rotate([90,-90-angle,0]) profile_flat(width=width,length=height*1.2, thickness=plate_thickness);
    translate([offset,-plate_thickness*2.5,0]) rotate([-90, -90, 0]) profile_flat(width=width*2,thickness=plate_thickness*2,length=height,log=false);
  }
}

module frame_y() {
  base_length=240;
  base_height=50;
  side_width=150;
  side_height=400;
  side_angle=12;
  side_offset=45;

  frame_width=rail_length_y+side_offset*2+plate_thickness*2+profile_thickness*2;
  side_bottom=20-base_height/2;

  // Right side
  translate([0,0,20]) rotate([90,0,0]) sbr16uu();
  translate([base_length-side_offset,0,20]) rotate([90,0,0]) sbr16uu();
  translate([0,-side_offset,side_bottom]) rotate([90,0,0]) profile_flat(width=base_height,length=base_length, thickness=plate_thickness);
  translate([side_offset,-side_offset,side_bottom]) side(height=side_height,width=side_width,angle=side_angle, offset=side_offset*-1);
  translate([0,-side_offset-plate_thickness,side_bottom+side_height]) rotate([0,90,0]) profile_L(length=profile_l_width*2+profile_square_width);

  // Left side
  left_block_y=frame_width-side_offset*2-plate_thickness*2;
  translate([0,left_block_y,20]) rotate([-90,0,0]) sbr16uu();
  translate([base_length-side_offset,left_block_y,20]) rotate([-90,0,0]) sbr16uu();
  translate([0,frame_width-side_offset-plate_thickness,side_bottom]) rotate([90,0,0]) profile_flat(width=base_height,length=base_length, thickness=plate_thickness);
  translate([side_offset,frame_width-side_offset+plate_thickness,side_bottom]) side(height=side_height,width=side_width,angle=side_angle, offset=side_offset*-1);
  translate([0,left_block_y+side_offset+plate_thickness,side_bottom+side_height]) rotate([0,90,270]) profile_L(length=profile_l_width*2+profile_square_width);

  // Top beam
  beam_width=frame_width+plate_thickness*2;
  translate([0,-side_offset-plate_thickness*2,side_bottom+side_height-profile_l_width]) rotate([0,0,90]) profile_L(length=beam_width);
  translate([0,-side_offset-plate_thickness*2,side_bottom+side_height-profile_l_width-profile_square_width]) rotate([0,0,90]) profile_square(length=beam_width);
  translate([0,-side_offset-plate_thickness*2,side_bottom+side_height-profile_l_width-profile_square_width]) rotate([-90,0,90]) profile_L(length=beam_width);

  translate([25,beam_width-84,side_height]) rotate([90,0,0]) sbr16axis_with_mounts_and_motor(length=rail_length_y+50);
}

frame_x();
frame_y();
