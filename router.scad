aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];

module bit() {
  color(steel_color) {
    difference() {
      cylinder(r=5/2,h=50,$fn=16);
      translate([0,0,-1]) cube([10,10,26]);
      translate([-10,-10,-1]) cube([10,10,26]);
    }
  }
}

module router_mount(inner_radius=40,height=108,width=149,depth=78,base_height=15,clamp_width=112,clamp_height=70,clamp_thickness=12,clamp_gap=2) {
  color(aluminum_color) difference() {
    union() {
      cube([depth,width,base_height]);
      translate([0,(width-clamp_width)/2,base_height]) cube([depth,clamp_width,clamp_height]);
      translate([0,width/2,height-inner_radius-clamp_thickness]) rotate([0,90,0]) cylinder(r=inner_radius+clamp_thickness,h=depth,$fn=64);
    }

    translate([-depth,width/2,height-inner_radius-clamp_thickness]) rotate([0,90,0]) cylinder(r=inner_radius,h=depth*3,$fn=64);
    translate([-depth,-width/2,base_height+inner_radius-clamp_gap/2]) cube([depth*3,width,clamp_gap]);
  }
}

module router(main_body_length=8+164+25,main_body_radius=80/2,collar_length=22,collar_radius=59/2,bit_holder_height=40,bit_holder_neck_radius=20/2,bit_holder_nut=25) {
  // Main body
  color([0.3,0.3,0.3]) translate([0,0,collar_length]) cylinder(r=main_body_radius,h=main_body_length,$fn=64);
  color(aluminum_color) translate([0,0,0]) cylinder(r=collar_radius,h=collar_length,$fn=64);

  // Bit holder
  color(steel_color) translate([0,0,-bit_holder_height+10]) cylinder(r=bit_holder_neck_radius,h=bit_holder_height-10,$fn=32);
  color(steel_color) translate([0,0,-bit_holder_height]) cylinder(r=bit_holder_nut/2,h=10,$fn=6);

  translate([0,0,-40-bit_holder_height]) bit();
}
