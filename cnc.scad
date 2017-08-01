include <list.scad>
include <sbr.scad>
include <profiles.scad>

cnc_rail_dimensions=[1100,700,300];
aluminum_thickness=5;
mount_sheet_thickness=50;

aluminum_color=[0.913,0.921,0.925];
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

module frame_y(y=700,z=300,thickness=5) {
  translate([0,-thickness,20-thickness]) rotate([90,0,0]) sbr16uu();
  translate([0,y+thickness,20-thickness]) rotate([-90,0,0]) sbr16uu();

}

frame_x(x=cnc_rail_dimensions[0],y=cnc_rail_dimensions[1],thickness=aluminum_thickness);
mount_sheet(x=cnc_rail_dimensions[0],y=cnc_rail_dimensions[1],thickness=mount_sheet_thickness);
frame_y(y=cnc_rail_dimensions[1],z=cnc_rail_dimensions[3],thickness=aluminum_thickness);
