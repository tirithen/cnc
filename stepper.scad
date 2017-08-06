aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];
dark_color=[0.3,0.3,0.3];

module nema23(length=78,width=56.4,axis_diameter=6.35,axis_length=20.6,mount_hole_diameter=5,mount_hole_distance=47.14,mount_hole_depth=5,collar_diameter=38.1,collar_height=1.6) {
  mount_hole_edge_distance=width/2-mount_hole_distance/2;

  translate([-width/2,-width/2,-length-collar_height]) {
    color(dark_color) difference() {
      union() {
        translate([mount_hole_edge_distance,0,0]) cube([mount_hole_distance,width,length]);
        translate([0,mount_hole_edge_distance,0]) cube([width,mount_hole_distance,length]);

        translate([mount_hole_edge_distance,mount_hole_edge_distance,0]) cylinder(r=mount_hole_edge_distance,h=length,$fn=32);
        translate([mount_hole_edge_distance+mount_hole_distance,mount_hole_edge_distance,0]) cylinder(r=mount_hole_edge_distance,h=length,$fn=32);
        translate([mount_hole_edge_distance,mount_hole_edge_distance+mount_hole_distance,0]) cylinder(r=mount_hole_edge_distance,h=length,$fn=32);
        translate([mount_hole_edge_distance+mount_hole_distance,mount_hole_edge_distance+mount_hole_distance,0]) cylinder(r=mount_hole_edge_distance,h=length,$fn=32);
      }

      union() {
        translate([mount_hole_edge_distance,mount_hole_edge_distance,-1]) cylinder(r=mount_hole_edge_distance,h=length-mount_hole_depth+1,$fn=32);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance+1,mount_hole_edge_distance*2+1,length-mount_hole_depth+1]);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance*2+1,mount_hole_edge_distance+1,length-mount_hole_depth+1]);
      }


      translate([mount_hole_distance+mount_hole_edge_distance*2,0,0]) rotate([0,0,90]) union() {
        translate([mount_hole_edge_distance,mount_hole_edge_distance,-1]) cylinder(r=mount_hole_edge_distance,h=length-mount_hole_depth+1,$fn=32);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance+1,mount_hole_edge_distance*2+1,length-mount_hole_depth+1]);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance*2+1,mount_hole_edge_distance+1,length-mount_hole_depth+1]);
      }

      translate([0,mount_hole_distance+mount_hole_edge_distance*2,0]) rotate([0,0,270]) union() {
        translate([mount_hole_edge_distance,mount_hole_edge_distance,-1]) cylinder(r=mount_hole_edge_distance,h=length-mount_hole_depth+1,$fn=32);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance+1,mount_hole_edge_distance*2+1,length-mount_hole_depth+1]);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance*2+1,mount_hole_edge_distance+1,length-mount_hole_depth+1]);
      }

      translate([mount_hole_distance+mount_hole_edge_distance*2,mount_hole_distance+mount_hole_edge_distance*2,0]) rotate([0,0,180]) union() {
        translate([mount_hole_edge_distance,mount_hole_edge_distance,-1]) cylinder(r=mount_hole_edge_distance,h=length-mount_hole_depth+1,$fn=32);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance+1,mount_hole_edge_distance*2+1,length-mount_hole_depth+1]);
        translate([-1,-1,-1]) cube([mount_hole_edge_distance*2+1,mount_hole_edge_distance+1,length-mount_hole_depth+1]);
      }

      translate([mount_hole_edge_distance,mount_hole_edge_distance,-1]) cylinder(r=mount_hole_diameter/2,h=length+2,$fn=32);
      translate([mount_hole_edge_distance+mount_hole_distance,mount_hole_edge_distance,-1]) cylinder(r=mount_hole_diameter/2,h=length+2,$fn=32);
      translate([mount_hole_edge_distance,mount_hole_edge_distance+mount_hole_distance,-1]) cylinder(r=mount_hole_diameter/2,h=length+2,$fn=32);
      translate([mount_hole_edge_distance+mount_hole_distance,mount_hole_edge_distance+mount_hole_distance,-1]) cylinder(r=mount_hole_diameter/2,h=length+2,$fn=32);
    }

    color(aluminum_color) translate([width/2,width/2,length]) cylinder(r=collar_diameter/2,h=collar_height,$fn=64);

    color(steel_color) translate([width/2,width/2,length]) cylinder(r=axis_diameter/2,h=axis_length,$fn=32);
  }
}

module axis_coupling(bore_diameter1=6.35,bore_diameter2=10,outer_diameter=25,length=34) {
  difference() {
    cylinder(r=outer_diameter/2,h=length,$fn=32);
    translate([0,0,-1]) cylinder(r=bore_diameter1/2,h=length/3+1,$fn=32);
    translate([0,0,length-length/3+1]) cylinder(r=bore_diameter2/2,h=length/3+1,$fn=32);
  }
}

nema23();
