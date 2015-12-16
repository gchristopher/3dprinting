slop = 0.01;

ps = 0.1 * 25.4;

frame_w = 90;

hub_motor_distance = 12;
wheel_attachment_thickness = 10.3945;
wheel_distance = hub_motor_distance + wheel_attachment_thickness/2; // Distance of center of wheel from base of motor shaft.


frame_thickness = 4;

module screw_hole_6_32() {
  translate([0.5 * ps, 0.5 * ps])
  difference() {
    circle(r = 10/2, $fn = 20);
    circle(r = 4.4/2, $fn = 16);
  }
}


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

module battery_preview() {
  translate([0, 0, 8])
  %cube([30, 93, 16], center=true);
}


holder_bracket_thickness = 3;
screw_4_40_r = 1.7;
screw_4_40_but_r = 3.9;
screw_4_40_washer_r = 4.0;


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
  //4-40 screw preview
  
  translate([0, 0, 5 + frame_thickness])
  rotate([90, 0, -90])
  motor_preview();
}



translate([0, 0, -5])
%square([frame_w + 2*wheel_distance, frame_w + 2*wheel_distance], center = true);

translate([0, 0, frame_thickness+slop])
color([1, .3, 0, 0.5]) battery_preview();

main_strut_w = 12;
minor_strut_w = 4;

minor_strut_x_count = 2;
minor_strut_y_count = 4;

inner_x = frame_w - main_strut_w*2 + minor_strut_w;
inner_y = frame_w + 2*wheel_distance + 2*6 + 2*holder_bracket_thickness - main_strut_w*2 + minor_strut_w;


electronics_holder_x = 0;
electronics_holder_y = -5;

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
  
  
  //%square([inner_x, inner_y], center = true);
  
  //linear_extrude(height = frame_thickness, convexity = 20)
  difference() {
    union() {
      translate([-frame_w/2, -frame_w/2 - wheel_distance - 6 - holder_bracket_thickness])
      square([main_strut_w, frame_w + 2*wheel_distance + 12 + 2*holder_bracket_thickness]);
    
      translate([-frame_w/2, -frame_w/2 - wheel_distance - 6 - holder_bracket_thickness])
      square([frame_w, main_strut_w]);
    
      translate([frame_w/2 - main_strut_w, -frame_w/2 - wheel_distance - 6 - holder_bracket_thickness])
      square([main_strut_w, frame_w + 2*wheel_distance + 12 + 2*holder_bracket_thickness]);
    
      translate([-frame_w/2, frame_w/2 + wheel_distance + 6 + holder_bracket_thickness - main_strut_w])
      square([frame_w, main_strut_w]);
      
      for(dx = [1: 1: minor_strut_x_count]) {
        translate([-inner_x/2 + (dx/(minor_strut_x_count+1)) * inner_x - minor_strut_w/2, -inner_y/2 - slop ])
        square([minor_strut_w, inner_y + 2*slop]);
      }
    
      for(dy = [1: 1: minor_strut_y_count]) {
        translate([-inner_x/2 - slop, -inner_y/2 + (dy/(minor_strut_y_count+1)) * inner_y - minor_strut_w/2])
        square([inner_x + 2*slop, minor_strut_w]);
      }

      translate([electronics_holder_x, electronics_holder_y]) {
        translate([14*ps, 7*ps]) screw_hole_6_32();
        translate([-15*ps, 7*ps]) screw_hole_6_32();
      
        translate([14*ps, -16*ps]) screw_hole_6_32();
        translate([-15*ps, -16*ps]) screw_hole_6_32();
      }
    }
    translate([electronics_holder_x, electronics_holder_y]) {
      translate([14.5*ps, 7.5*ps]) circle(r = 4.4/2, $fn = 16);
      translate([-14.5*ps, 7.5*ps]) circle(r = 4.4/2, $fn = 16);
      translate([14.5*ps, -15.5*ps]) circle(r = 4.4/2, $fn = 16);
      translate([-14.5*ps, -15.5*ps]) circle(r = 4.4/2, $fn = 16);
    }
  }
}


body_frame();