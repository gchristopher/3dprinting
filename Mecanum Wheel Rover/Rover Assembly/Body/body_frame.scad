// body_frame.scad
//
// Main body of a small mecanum-wheeled rover.
//
// By Gregg Christopher, 2015
// This file is public domain. 

slop = 0.01;

ps = 0.1 * 25.4; // 0.1 inch DIP package pin spacing.

frame_w = 90; // Width of the frame body

hub_motor_distance = 12;
wheel_attachment_thickness = 10.3945;
wheel_distance = hub_motor_distance + wheel_attachment_thickness/2; // Distance of center of wheel from base of motor shaft.

frame_thickness = 4; // Thickness of frame body and wall thickness

// Hole for a 6-32 screw. Many offets are in terms of DIP package pin spacings because
// the main purpose of these screw holes is to line up with the electronics holder board. 
module screw_hole_6_32() {
  translate([0.5 * ps, 0.5 * ps])
  circle(r = 10/2, $fn = 20);
}

// Preview a common tiny gearmotor shape
module motor_preview() {
  // Keyed shaft
  color([0.7, 0.7, 0.7, 0.7])
  %intersection() {
    cylinder(r = 1.5, h = 9, $fn = 10);
    translate([-1.5, -1.5, 0]) cube([3, 2.5, 9]);
  }

  // Gear box
  color([0.7, 0.7, 0.2, 0.7])
  translate([-6, -5, -9.5]) %cube([12, 10, 9.5]);
    
  // Motor body
  color([0.7, 0.7, 0.7, 0.7])
  translate([0, 0, -24.5])
  %intersection() {
    cylinder(r = 6, h = 15, $fn = 20);
    translate([-6, -5, 0]) cube([12, 10, 15]);
  }
}

// Preview space taken by a common volume for a small RC battery. 
module battery_preview() {
  translate([0, 0, 8])
  %cube([30, 93, 16], center=true);
}

// Parameters used for motor holder brackets. 
holder_bracket_thickness = 3;
screw_4_40_r = 1.6;
screw_4_40_nut_r = 3.9;
screw_4_40_washer_r = 4.0;


// Motor holder bracket that tightens using a 1" 4-40 screw
module motor_holder() {
  translate([0, -6 - holder_bracket_thickness, 0])
  cube([25, 12 + 2*holder_bracket_thickness, frame_thickness]);

  translate([9.5, -6 - holder_bracket_thickness, frame_thickness])
  difference() {
    cube([15.5, 12 + 2*holder_bracket_thickness, 9]);
    intersection() {
      translate([0, 6 + holder_bracket_thickness, 5]) rotate([0, 90, 0]) cylinder(r = 6.2, h = 16, $fn = 30);
      translate([0, holder_bracket_thickness-.2, 0]) cube([16, 12.4, 10]);
    }
  }
  
  difference() {
    union() {
      translate([9.5, -6 - holder_bracket_thickness, frame_thickness + 9])
      cube([15.5, holder_bracket_thickness, 8]);
      
      translate([9.5, 6, frame_thickness + 9])
      cube([15.5, holder_bracket_thickness, 8]);
    }
    
    translate([9.5 + 15/2, -12.5, 13 + frame_thickness]) rotate([-90, 0, 0]) cylinder(r = screw_4_40_r, h = 25, $fn = 20);
  }
  
  %translate([9.5 + 15/2, -12.5, 13 + frame_thickness]) rotate([-90, 0, 0]) cylinder(r = screw_4_40_r, h = 25, $fn = 12);
  
  translate([0, 0, 5 + frame_thickness])
  rotate([90, 0, -90])
  motor_preview();
}


// Preview square dimensions of the wheelbase. 
translate([0, 0, -5])
%square([frame_w + 2*wheel_distance, frame_w + 2*wheel_distance], center = true);

// Preview the battery position and size
translate([0, 0, frame_thickness+slop])
color([1, .3, 0, 0.5]) battery_preview();

// Parameters used to build the frame shape.
main_strut_w = 10;
minor_strut_w = 4;

minor_strut_x_count = 2;
minor_strut_y_count = 4;

inner_x = frame_w - main_strut_w*2 + minor_strut_w;
inner_y = frame_w + 2*wheel_distance + 2*6 + 2*holder_bracket_thickness - main_strut_w*2 + minor_strut_w;


electronics_holder_x = 0;
electronics_holder_y = -5;

support_frame_thickness = 2.5;

cutout_r = 7;
cutout_spacing = 8;

// 2D outline of the base of the frame.
module base_outline() {
  hull() {
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14*ps, 7*ps]) screw_hole_6_32();
      translate([14*ps, -16*ps]) screw_hole_6_32();
      translate([-15*ps, 7*ps]) screw_hole_6_32();
      translate([-15*ps, -16*ps]) screw_hole_6_32();
    }
  }
  
  hull() {
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14*ps, 7*ps]) screw_hole_6_32();
      translate([-15*ps, 7*ps]) screw_hole_6_32();
    }
    translate([-frame_w/2, frame_w/2 + wheel_distance - 6 - holder_bracket_thickness, 0])
    square([frame_w, 12 + 2*holder_bracket_thickness]);
  }

  hull() {
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14*ps, -16*ps]) screw_hole_6_32();
      translate([-15*ps, -16*ps]) screw_hole_6_32();
    }
    translate([-frame_w/2, -frame_w/2 - wheel_distance - 6 - holder_bracket_thickness, 0])
    square([frame_w, 12 + 2*holder_bracket_thickness]);
  }
}

// 2D outline of the frame walls.
module frame_outline() {
  hull() {
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14*ps, 7*ps]) screw_hole_6_32();
      translate([14*ps, -16*ps]) screw_hole_6_32();
      translate([-15*ps, 7*ps]) screw_hole_6_32();
      translate([-15*ps, -16*ps]) screw_hole_6_32();
    }
  }
  
  hull() {
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14*ps, 7*ps]) screw_hole_6_32();
      translate([-15*ps, 7*ps]) screw_hole_6_32();
    }
    translate([-frame_w/2 + 9.5, frame_w/2 + wheel_distance - 6 - holder_bracket_thickness, 0])
    square([frame_w - 19, support_frame_thickness]);
  }

  hull() {
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14*ps, -16*ps]) screw_hole_6_32();
      translate([-15*ps, -16*ps]) screw_hole_6_32();
    }
    translate([-frame_w/2 + 9.5, -frame_w/2 - wheel_distance + 6 + holder_bracket_thickness - support_frame_thickness, 0])
    square([frame_w -19, support_frame_thickness]);
  }
}

// Construct the rover frame.
module body_frame() {
  translate([frame_w/2, frame_w/2 + wheel_distance, 0])
  rotate([0, 0, 180])
  motor_holder();
  
  translate([frame_w/2, -frame_w/2 - wheel_distance, 0])
  rotate([0, 0, 180])
  motor_holder();
  
  translate([-frame_w/2, frame_w/2 + wheel_distance, 0])
  motor_holder();
  
  translate([-frame_w/2, -frame_w/2 - wheel_distance, 0])
  motor_holder();
  
  linear_extrude(height = frame_thickness, convexity = 20)
  difference() {
    base_outline();
    intersection() {
      offset(r = -main_strut_w) base_outline();
      for(ii = [-10: 1: 10]) { // Y = rows
        for(jj = [-10: 1: 10]) { // X = columns
          if(jj%2 == 0) {
            translate([jj*(cutout_spacing + cutout_spacing*sin(30)), ii*2*(cutout_spacing*cos(30))])
            circle(r = cutout_r, $fn = 6);
          } else {
            translate([jj*(cutout_spacing + cutout_spacing*sin(30)), (ii*2+1)*(cutout_spacing*cos(30)), 0])
            circle(r = cutout_r, $fn = 6);
          }
        }
      }
    }
    
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14.5*ps, 7.5*ps]) circle(r = 4.4/2, $fn = 16);
      translate([-14.5*ps, 7.5*ps]) circle(r = 4.4/2, $fn = 16);
      translate([14.5*ps, -15.5*ps]) circle(r = 4.4/2, $fn = 16);
      translate([-14.5*ps, -15.5*ps]) circle(r = 4.4/2, $fn = 16);
    }
  }

  
  translate([0, 0, frame_thickness-slop])
  linear_extrude(height = 8, convexity = 20) {
    difference() {
      frame_outline();
      offset(r = -support_frame_thickness) frame_outline();
      square([frame_w-9.5-15, frame_w + wheel_distance*2], center=true);
    }
    translate([-frame_w/2 + 9.5 + 15, -frame_w/2 - wheel_distance - 6 - holder_bracket_thickness])
    square([frame_w - 2*(9.5 + 15), support_frame_thickness]);
    translate([-frame_w/2 + 9.5 + 15, frame_w/2 + wheel_distance + 6 + holder_bracket_thickness - support_frame_thickness])
    square([frame_w - 2*(9.5 + 15), support_frame_thickness]);
  }
}

body_frame();
