// Measurements source https://d2t1xqejof9utc.cloudfront.net/screenshots/pics/634edaa2aafc69b87035858a4a9380ef/large.jpg
// and https://www.hardware-cnc.nl/en/shop/end-support-bearings/12-16mm-ballscrew/bk12-end-support-bearings-detail
// Measurements for tilted angle under shaft and underside groove are just estimates since the measurements tables are missing that information
// TODO: Add nicer details to SBRxxUU parts
// TODO: Add holes to rails

/**
* Examples:
* translate([0,0,0]) sbr16(length=500);
* translate([0,100,0]) sbr20(length=500);
* translate([0,200,0]) sbr25(length=500);
* translate([0,300,0]) sbr30(length=500);
* translate([0,400,0]) sbr35(length=500);
* translate([0,500,0]) sbr40(length=500);
* translate([0,600,0]) sbr50(length=500);
*
* translate([10,0,0]) sbr16uu();
* translate([10,100,0]) sbr20uu();
* translate([10,200,0]) sbr25uu();
* translate([10,300,0]) sbr30uu();
* translate([10,400,0]) sbr35uu();
* translate([10,500,0]) sbr40uu();
* translate([10,600,0]) sbr50uu();
*/

include <stepper.scad>

aluminum_color=[0.913,0.921,0.925];
steel_color=[0.560,0.570,0.580];
dark_color=[0.3,0.3,0.3];

module sbr(shaft_dimension=16,length=100,h=25,B=40,H=17.8,T=5,F=18.5,X=8,Y=11.7,C=30,S1=5.5,S2d1=5.5,S2d2=9.5,S2i=5.4) {
  translate([0,-B/2,0]) {
    color(aluminum_color)
    rotate([90,0,90])
    linear_extrude(height=length,convexity=5)
    polygon([[0,0],[0,T],[B/2-F/2,T],[B/2-F/2,Y],[B/2-F/2+2,Y],[B/2-X/2,H],[B/2+X/2,H],[B/2+F/2-2,Y],[B/2+F/2,Y],[B/2+F/2,T],[B,T],[B,0],[B/2+S2d2/2+3,0],[B/2+S2d2/2+2,H-S2i*2.5],[B/2-S2d2/2-2,H-S2i*2.5],[B/2-S2d2/2-3,0]]);

    color(steel_color)
    translate([0,B/2,h])
    rotate([90,0,90])
    cylinder(r=shaft_dimension/2,h=length,$fn=64);
  }
}

module sbr16(length=100) {
  sbr(shaft_dimension=16,length=length,h=25,B=40,H=17.8,T=5,F=18.5,X=8,Y=11.7,C=30,S1=5.5,S2d1=5.5,S2d2=9.5,S2i=5.4);
}

module sbr20(length=100) {
  sbr(shaft_dimension=20,length=length,h=27,B=45,H=17.7,T=5,F=19,X=8,Y=10,C=30,S1=5.5,S2d1=5.5,S2d2=9.5,S2i=5.4);
}

module sbr25(length=100) {
  sbr(shaft_dimension=25,length=length,h=33,B=55,H=21,T=6,F=21.5,X=8,Y=12,C=35,S1=6.6,S2d1=6.6,S2d2=11,S2i=6.5);
}

module sbr30(length=100) {
  sbr(shaft_dimension=30,length=length,h=37,B=60,H=22.8,T=7,F=26.5,X=10.3,Y=13,C=40,S1=6.6,S2d1=6.6,S2d2=11,S2i=6.5);
}

module sbr35(length=100) {
  sbr(shaft_dimension=35,length=length,h=43,B=65,H=26.5,T=8,F=28,X=13,Y=15.5,C=45,S1=9,S2d1=9,S2d2=14,S2i=8.6);
}

module sbr40(length=100) {
  sbr(shaft_dimension=40,length=length,h=48,B=75,H=29.5,T=9,F=38,X=15.5,Y=17,C=55,S1=9,S2d1=9,S2d2=14,S2i=8.6);
}

module sbr50(length=100) {
  sbr(shaft_dimension=50,length=length,h=62,B=95,H=38.8,T=11,F=45,X=20,Y=21,C=70,S1=11,S2d1=11,S2d2=17.5,S2i=10.8);
}

module sbruu(shaft_dimension=16,h=20,W=45,L=45,F=33,rh=25,h1=10,q=80,B=32,C=30,S=5,L1=12,T=9) {
  camfer=2;

  translate([0,-W/2,rh-(F-h)]) {
    color(aluminum_color) {
      difference() {
        rotate([90,0,90])
        linear_extrude(height=L,convexity=5)
        polygon([[camfer*2,0],[camfer*2,camfer/2],[camfer,camfer*1.5],[camfer,F-T-camfer],[0,F-T],[0,F-camfer],[camfer,F],[W-B-camfer/2,F],[W-B,F-camfer/2],[W-(W-B),F-camfer/2],[W-(W-B-camfer/2),F],[W-camfer,F],[W,F-camfer],[W,F-T],[W-camfer,F-T-camfer],[W-camfer,camfer*1.5],[W-camfer*2,camfer/2],[W-camfer*2,0]]);

        translate([-2,W/2,F-h])
        rotate([90,180,90])
        linear_extrude(height=L+4,convexity=5)
        polygon([[0,0],[sin(q/2)*W,cos(q/2)*W],[-sin(q/2)*W,cos(q/2)*W]]);

        translate([-1,W/2,F-h]) rotate([90,0,90]) cylinder(r=shaft_dimension/2,h=L+2,$fn=64);

        translate([L-(L-C)/2,W-(W-B)/2,F-L1]) rotate([0,0,90]) cylinder(r=S/2,h=L1+1,$fn=16);
        translate([L-(L-C)/2-C,W-(W-B)/2,F-L1]) rotate([0,0,90]) cylinder(r=S/2,h=L1+1,$fn=16);
        translate([L-(L-C)/2,W-(W-B)/2-B,F-L1]) rotate([0,0,90]) cylinder(r=S/2,h=L1+1,$fn=16);
        translate([L-(L-C)/2-C,W-(W-B)/2-B,F-L1]) rotate([0,0,90]) cylinder(r=S/2,h=L1+1,$fn=16);
      }
    }
  }
}

module sbr16uu() {
  sbruu(shaft_dimension=16,h=20,W=45,L=45,F=33,rh=25,h1=10,q=80,B=32,C=30,S=5,L1=12,T=9);
}

module sbr20uu() {
  sbruu(shaft_dimension=20,h=23,W=48,L=50,F=39,rh=27,h1=10,q=60,B=35,C=35,S=6,L1=12,T=11);
}

module sbr25uu() {
  sbruu(shaft_dimension=25,h=27,W=60,L=65,F=47,rh=33,h1=11.5,q=50,B=40,C=40,S=6,L1=12,T=14);
}

module sbr30uu() {
  sbruu(shaft_dimension=30,h=33,W=70,L=70,F=56,rh=37,h1=14,q=50,B=50,C=50,S=8,L1=18,T=15);
}

module sbr35uu() {
  sbruu(shaft_dimension=35,h=37,W=80,L=80,F=63,rh=43,h1=16,q=50,B=55,C=55,S=8,L1=18,T=18);
}

module sbr40uu() {
  sbruu(shaft_dimension=40,h=42,W=90,L=90,F=72,rh=48,h1=19,q=50,B=65,C=65,S=10,L1=20,T=20);
}

module sbr50uu() {
  sbruu(shaft_dimension=50,h=53,W=120,L=120,F=92,rh=62,h1=23,q=50,B=94,C=80,S=10,L1=20,T=25);
}

module sbr16rail(length=1000) {
  thread_length=length-11-39-15;

  color(steel_color) translate([0,0,length]) rotate([180,0,0]) union() {
    cylinder(r=5,h=11,$fn=32);
    translate([0,0,11]) cylinder(r=8,h=thread_length,$fn=32);
    translate([0,0,11+thread_length]) cylinder(r=6,h=39,$fn=32);
    translate([0,0,11+thread_length+39]) cylinder(r=5,h=15,$fn=32);
  }
}

module sfu1605_3() {
  color(steel_color) difference() {
    union() {
      intersection() {
        cylinder(r=48/2,h=10,$fn=64);
        translate([-20,-50,-1]) cube([40,100,12]);
      }
      translate([0,0,10]) cylinder(r=28/2,h=10,$fn=64);
      translate([0,0,20]) cylinder(r=27.8/2,h=22,$fn=64);
    }

    translate([0,0,-1]) cylinder(r=8,h=44,$fn=64);

    translate([0,19,-1]) cylinder(r=5.5/2,h=12,$fn=24);
    translate([sin(45)*19,cos(45)*19,-1]) cylinder(r=5.5/2,h=12,$fn=24);
    translate([sin(-45)*19,cos(-45)*19,-1]) cylinder(r=5.5/2,h=12,$fn=24);
    translate([0,-19,-1]) cylinder(r=5.5/2,h=12,$fn=24);
    translate([sin(45)*19,-cos(45)*19,-1]) cylinder(r=5.5/2,h=12,$fn=24);
    translate([sin(-45)*19,-cos(-45)*19,-1]) cylinder(r=5.5/2,h=12,$fn=24);
  }
}

module bearing10() {
  color(steel_color) difference() {
    cylinder(r=12,h=10,$fn=55);
    translate([0,0,-1]) cylinder(r=5,h=12,$fn=55);
  }
}

module bolt_hole_sinked(diameter=6.6,head_diameter=10.8,head_length=5,length=30) {
  translate([0,0,-1]) union() {
    translate([0,0,1]) cylinder(r=diameter/2,h=length,$fn=24);
    translate([0,0,0]) cylinder(r=head_diameter/2,h=head_length+1,$fn=32);
  }
}

// TODO: figure out why screw holes overlap, maybe that should be the case?
module bk12() {
  color(dark_color) translate([0,0,-34]) difference() {
    union() {
      translate([-25,-30,4]) cube([32.5,60,25]);
      translate([-17,-17,4]) cube([34,34,30]);
    }

    translate([0,0,-1]) cylinder(r=8,h=36,$fn=55);
    translate([0,0,4+5]) cylinder(r=12,h=31,$fn=55);

    translate([0,23,-1]) cylinder(r=5.5/2,h=100,$fn=24);
    translate([0,-23,-1]) cylinder(r=5.5/2,h=100,$fn=24);
    translate([-18,23,-1]) cylinder(r=5.5/2,h=100,$fn=24);
    translate([-18,-23,-1]) cylinder(r=5.5/2,h=100,$fn=24);

    translate([7,23,4+6]) rotate([0,-90,0]) bolt_hole_sinked(length=32.5);
    translate([7,-23,4+6]) rotate([0,-90,0]) bolt_hole_sinked(length=32.5);
    translate([7,23,4+6+13]) rotate([0,-90,0]) bolt_hole_sinked(length=32.5);
    translate([7,-23,4+6+13]) rotate([0,-90,0]) bolt_hole_sinked(length=32.5);
  }

  color(dark_color) translate([0,-17,-34]) difference() {
    rotate([0,0,45]) cube([24,24,4]);
    translate([0,17,-1]) cylinder(r=8,h=6,$fn=55);
  }

  translate([0,0,-25]) bearing10();
  translate([0,0,-15]) bearing10();
}

module bf12() {
  color(dark_color) translate([0,0,0]) rotate([180,0,0]) difference() {
    union() {
      translate([-25,-30,0]) cube([32.5,60,20]);
      translate([5+2.5,-17,0]) cube([43-32.5,34,20]);
    }

    translate([0,0,-1]) cylinder(r=5,h=22,$fn=55);
    translate([0,0,-1]) cylinder(r=12,h=22,$fn=55);

    translate([0,23,-1]) cylinder(r=5.5/2,h=100,$fn=24);
    translate([0,-23,-1]) cylinder(r=5.5/2,h=100,$fn=24);
    translate([-18,23,-1]) cylinder(r=5.5/2,h=100,$fn=24);
    translate([-18,-23,-1]) cylinder(r=5.5/2,h=100,$fn=24);

    translate([7,23,4+6]) rotate([0,-90,0]) bolt_hole_sinked(length=32.5);
    translate([7,-23,4+6]) rotate([0,-90,0]) bolt_hole_sinked(length=32.5);
  }

  translate([0,0,-10]) bearing10();
}

module sbr16rail_with_mounts_and_motor(length=1000) {
  nema23();
  translate([0,0,9]) axis_coupling();
  translate([0,0,33]) sbr16rail(length=length);
  translate([0,0,90]) bk12();
  translate([0,0,length+33-1]) bf12();
}
