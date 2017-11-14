// curvy_led_strip_holder.scad
//
// LED strip holder to be attached to a Teal Sport drone. This holder curves 
// slightly to hug the body shape of the drone and avoid rotor contact for a 
// greater range of mounting angles.
//
// The holder can be adjusted to different lengths and degress of curve by
// changing the shape parameters below. 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

// Module summary:

// curvy_led_strip_holder(preview_leds = true, manually_generate_supports = true)
//     preview_leds: Draw a (commented out, purely cosmetic, glitchy) rendering of the led strip and LEDs.
//     manually_generate_supports: Does what it says.

// Infinitesimal value for ensuring manifold shapes and other special uses. 
slop = 0.01;

include <curvy_led_strip_holder_parameters.scad>

generate_supports_from_this_file = false;
manual_support_spacing = 4; // Distance between manually generated support strips

module led_holder_cross_section() {
  difference() {
    translate([-led_holder_front_thickness - led_strip_thickness/2 + led_holder_bevel_r, -led_strip_width/2 - led_holder_side_thickness + led_holder_bevel_r])
    minkowski() {
      square([led_strip_thickness + led_holder_front_thickness + led_holder_back_thickness - 2*led_holder_bevel_r, led_strip_width + 2*led_holder_side_thickness - 2*led_holder_bevel_r]);
      circle(r = led_holder_bevel_r, $fn = 16);
    }
    
    translate([-led_strip_thickness/2, -led_strip_width/2])
    square([led_strip_thickness, led_strip_width]);
  
    translate([-led_holder_front_thickness - led_strip_thickness/2 - slop, -led_strip_width/2 + led_holder_clip_length])
    square([led_strip_thickness, led_strip_width - 2*led_holder_clip_length]);
  }
  
  hull() {
    translate([-led_holder_front_thickness - led_strip_thickness/2 + led_holder_bevel_r, -led_strip_width/2 - led_holder_side_thickness + led_holder_bevel_r])
    circle(r = led_holder_bevel_r, $fn = 16);
  
    translate([led_holder_back_thickness + led_strip_thickness/2 - led_holder_bevel_r, -led_strip_width/2 - led_holder_side_thickness + led_holder_bevel_r])
    circle(r = led_holder_bevel_r, $fn = 16);
  
    translate([(led_strip_thickness/2 + led_holder_back_thickness - led_holder_leading_edge_r)*3/4, -13])
    circle(r = led_holder_leading_edge_r, $fn = 16);
  }
}

module led_holder_print_support_cross_section() {
  translate([-led_holder_front_thickness - led_strip_thickness/2, -led_strip_width/2 + led_holder_clip_length - slop])
  //translate([-led_holder_front_thickness - led_strip_thickness/2, 0])
  square([led_holder_front_thickness, led_strip_width - 2*led_holder_clip_length + 2*slop]);
}


module led_strip_preview_cross_section(show_weather_strip = true) {
  if(show_weather_strip) {
    translate([-led_strip_thickness/2 - slop, -led_strip_width/2, 0])
    square([led_strip_thickness, led_strip_width]);
  } else {
    translate([led_strip_thickness/2 - led_backing_thickness - slop, -led_strip_width/2, 0])
    square([led_backing_thickness, led_strip_width]);
  }
}

module curved_led_preview_section(direction = 1, start_offset = 0) {
  perim_distance = curvy_section_theta/180*PI * curvy_section_r;
  total_perim = 2 * PI * curvy_section_r;
  
  for(led_dx = [start_offset + led_spacing : led_spacing : perim_distance]) {
    theta = (led_dx / total_perim) * 360;
    %color([1, 0, 0, 0.7])
    rotate([0, 0, -direction*theta])
    translate([direction*curvy_section_r, 0, -led_width/2])
    cube([led_height, led_width, led_width]);
  }
}

module straight_led_preview_section(section_height = 0, , start_offset = 0) {
  for(led_dx = [start_offset + led_spacing/2 : led_spacing : section_height - led_width*3/4]) {
    %color([1, 0, 0, 0.7])
    translate([0, -led_width/2, led_dx])
    cube([led_height, led_width, led_width]);
  }
}

// Show either preview of LED positions or weather stripping size for mounting.
module curvy_led_strip_preview(show_weather_strip = true) {
  perim_distance = 4*curvy_section_theta/180*PI * curvy_section_r;
  //echo(4*perim_distance);
  d_x = cos(curvy_section_theta) * curvy_section_r;
  d_y = sin(curvy_section_theta) * curvy_section_r;
  rotational_fineness = 80;
      
  rotate([-90, 0, 0])
  translate([curvy_section_r, 0, 0]) {
    translate([0, led_holder_straight_center_length/2 + slop, 0])
    rotate([0, 0, -curvy_section_theta]) {
      %color([0.2, 0.2, 0.2, 0.7])
      rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
      translate([-curvy_section_r, 0, 0])
      led_strip_preview_cross_section(show_weather_strip);
      
      curved_led_preview_section(-1);
    }

    translate([0, -led_holder_straight_center_length/2 + slop, 0]) {
      %color([0.2, 0.2, 0.2, 0.7])
      rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
      translate([-curvy_section_r, 0, 0])
      led_strip_preview_cross_section(show_weather_strip); 
      
      curved_led_preview_section(-1);
    }
    
    translate([-2*d_x - slop, 2*d_y + led_holder_straight_center_length/2 - slop, 0]) {
      %color([0.2, 0.2, 0.2, 0.7])
      rotate([0, 0, -curvy_section_theta])
      rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
      translate([curvy_section_r, 0, 0])
      led_strip_preview_cross_section(show_weather_strip);

      curved_led_preview_section(1);
    }
    
    translate([-2*d_x - slop, -2*d_y - led_holder_straight_center_length/2 + slop, 0]) {
      %color([0.2, 0.2, 0.2, 0.7])
      rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
      translate([curvy_section_r, 0, 0])
      led_strip_preview_cross_section(show_weather_strip);

      rotate([0, 0, curvy_section_theta])
      curved_led_preview_section(1);
    }
  }

  translate([0, 0, -led_holder_straight_center_length/2]) {
    %color([0.2, 0.2, 0.2, 0.7])
    linear_extrude(height = led_holder_straight_center_length)
    led_strip_preview_cross_section(show_weather_strip);
  
    straight_led_preview_section(led_holder_straight_center_length);
  }
  
  translate([2*curvy_section_r - 2*d_x, 0, 2*d_y - 2*slop]) {
    %color([0.2, 0.2, 0.2, 0.7])
    linear_extrude(height = (led_holder_length - perim_distance)/2)
    led_strip_preview_cross_section(show_weather_strip);

    straight_led_preview_section((led_holder_length - perim_distance)/2);
  }

  translate([2*curvy_section_r - 2*d_x, 0, -2*d_y - (led_holder_length - perim_distance)/2 + 2*slop]) {
    %color([0.2, 0.2, 0.2, 0.7])
    linear_extrude(height = (led_holder_length - perim_distance)/2)
    led_strip_preview_cross_section(show_weather_strip);
  
    straight_led_preview_section((led_holder_length - perim_distance)/2);
  }
}

perim_distance = 4*curvy_section_theta/180*PI * curvy_section_r;
d_x = cos(curvy_section_theta) * curvy_section_r;
d_y = sin(curvy_section_theta) * curvy_section_r;
rotational_fineness = 80;

module curved_section_manual_print_supports() {
  strip_theta = 0.4 / curvy_section_r / 2 / PI * 360;
  echo(strip_theta);
  //manual_support_spacing
  
  for(x = [manual_support_spacing/2 : manual_support_spacing : perim_distance/4]) {
    rot_theta = x / curvy_section_r / 2 / PI * 360;
    
    translate([0, -led_holder_straight_center_length/2 + slop, 0])
    rotate([0, 0, rot_theta])
    rotate_extrude(angle = strip_theta, $fn = rotational_fineness)
    translate([-curvy_section_r, 0, 0])
    led_holder_print_support_cross_section();

    translate([0, led_holder_straight_center_length/2 - slop, 0])
    rotate([0, 0, rot_theta])
    rotate([0, 0, -curvy_section_theta])
    rotate_extrude(angle = strip_theta, $fn = rotational_fineness)
    translate([-curvy_section_r, 0, 0])
    led_holder_print_support_cross_section();
    
    translate([-2*d_x - slop, 2*d_y + led_holder_straight_center_length/2  - 2*slop, 0])
    rotate([0, 0, rot_theta])
    rotate([0, 0, -curvy_section_theta])
    rotate_extrude(angle = strip_theta, $fn = rotational_fineness)
    translate([curvy_section_r, 0, 0])
    led_holder_print_support_cross_section();
    
    translate([-2*d_x - slop, -2*d_y - led_holder_straight_center_length/2 + 2*slop, 0])
    rotate([0, 0, rot_theta])
    rotate_extrude(angle = strip_theta, $fn = rotational_fineness)
    translate([curvy_section_r, 0, 0])
    led_holder_print_support_cross_section();
  }
}

module straight_section_manual_print_supports(section_length) {
  for(z = [0 : manual_support_spacing: section_length]) {
    translate([0, 0, z])
    linear_extrude(height = 0.4)
    led_holder_print_support_cross_section();
  }
    
  translate([0, 0, section_length - 0.4])
  linear_extrude(height = 0.4)
  led_holder_print_support_cross_section();
}

module curvy_led_strip_holder(preview_leds = true, manually_generate_supports = true) {
  if(preview_leds) {
    curvy_led_strip_preview(false);
  }
  
  echo("Length of center+curved section: ", perim_distance + led_holder_straight_center_length);
  
  translate([led_strip_thickness/2 + led_holder_back_thickness - slop, 0, 0]) {
    rotate([0, 90, 0])
    difference() {
      cylinder(r = base_post_r, h = base_post_length, $fn = 20);
      
      translate([0, 0, base_post_notch_d])
      difference() {
        cylinder(r = base_post_r + 1, h = base_post_notch_w, $fn = 20);
        translate([0, 0, -slop])
        cylinder(r = base_post_notch_r, h = base_post_notch_w + 2*slop, $fn = 20);
      }
    }
    
    // Angle adjustment_arm:
    translate([base_post_length - angle_adjustment_arm_thickness, -angle_adjustment_arm_l + angle_adjustment_arm_w/2, -angle_adjustment_arm_w/2]) {
      difference() {
        union() {
          cube([angle_adjustment_arm_thickness, angle_adjustment_arm_l - angle_adjustment_arm_w/2, angle_adjustment_arm_w]);
          translate([0, 0, angle_adjustment_arm_w/2])
          rotate([0, 90, 0])
          cylinder(r = angle_adjustment_arm_w/2, h = angle_adjustment_arm_thickness, $fn = 20);
        }
        translate([-slop, 0, angle_adjustment_arm_w/2])
        rotate([0, 90, 0])
        cylinder(r = angle_adjustment_arm_screw_hole_r, h = angle_adjustment_arm_thickness + 2*slop, $fn = 20);
      }
    }
    
    if(manually_generate_supports) {
      for(x = [base_post_notch_d - 0.4, base_post_notch_d + base_post_notch_w, base_post_length - 0.4]) {
        translate([x, 0, -angle_adjustment_arm_w/2])
        cube([0.4, led_strip_width/2 + led_holder_side_thickness, angle_adjustment_arm_w]);
      }
    }
  }
  
  // Curvy LED strip holder:
  rotate([-90, 0, 0])
  translate([curvy_section_r, 0, 0]) {

    translate([0, -led_holder_straight_center_length/2 + slop, 0])
    rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
    translate([-curvy_section_r, 0, 0])
    led_holder_cross_section();

    translate([0, led_holder_straight_center_length/2 - slop, 0])
    rotate([0, 0, -curvy_section_theta])
    rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
    translate([-curvy_section_r, 0, 0])
    led_holder_cross_section();
    
    translate([-2*d_x - slop, 2*d_y + led_holder_straight_center_length/2  - 2*slop, 0])
    rotate([0, 0, -curvy_section_theta])
    rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
    translate([curvy_section_r, 0, 0])
    led_holder_cross_section();
    
    translate([-2*d_x - slop, -2*d_y - led_holder_straight_center_length/2 + 2*slop, 0])
    rotate_extrude(angle = curvy_section_theta, $fn = rotational_fineness)
    translate([curvy_section_r, 0, 0])
    led_holder_cross_section();
    
    if(manually_generate_supports) {
      curved_section_manual_print_supports();
    }
  }
  
  // Center straight section
  translate([0, 0, -led_holder_straight_center_length/2]) {
    linear_extrude(height = led_holder_straight_center_length)
    led_holder_cross_section();
  
    if(manually_generate_supports) {
      straight_section_manual_print_supports(led_holder_straight_center_length);
    }
  }
  
  // Add straight end sections only if needed:
  end_cap_dz = (led_holder_length - perim_distance - led_holder_straight_center_length) / 2;
  if(end_cap_dz > 0) {
    translate([2*curvy_section_r - 2*d_x, 0, 2*d_y + led_holder_straight_center_length/2 - 3*slop]) {
      linear_extrude(height = end_cap_dz)
      led_holder_cross_section();
  
      if(manually_generate_supports) {
        straight_section_manual_print_supports(end_cap_dz);
      }
    }

    translate([2*curvy_section_r - 2*d_x, 0, -2*d_y - end_cap_dz - led_holder_straight_center_length/2 + 3*slop]) {
      linear_extrude(height = end_cap_dz)
      led_holder_cross_section();

      if(manually_generate_supports) {
        straight_section_manual_print_supports(end_cap_dz);
      }
    }
  }

  end_cap_pos = end_cap_dz;
  if(end_cap_pos < 0) {
    end_cap_pos = 0;
  }
  translate([2*curvy_section_r - 2*d_x, 0, -2*d_y - end_cap_pos - led_holder_bottom_cap_thickness - led_holder_straight_center_length/2 + 3*slop])
  linear_extrude(height = led_holder_bottom_cap_thickness)
  hull()
  led_holder_cross_section();
}

// Place the curvy LED strip holder for printing. 
translate([-35, 0, 0])
rotate([-90, 0, 0])
curvy_led_strip_holder(true, generate_supports_from_this_file);

// Long skinny, tallish objects can benefit greatly from stick pads on the ends.
if(generate_supports_from_this_file) {
  translate([16, -100, -led_strip_width/2 - led_holder_side_thickness])
  cylinder(r = 8, h = 0.2);

  translate([16, 100, -led_strip_width/2 - led_holder_side_thickness])
  cylinder(r = 8, h = 0.2);
}

mirror([1, 0, 0])
// Place the curvy LED strip holder for printing. 
translate([-35, 0, 0])
rotate([-90, 0, 0])
curvy_led_strip_holder(true, generate_supports_from_this_file);
