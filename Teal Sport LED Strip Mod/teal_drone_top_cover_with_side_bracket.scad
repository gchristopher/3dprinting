// teal_drone_top_cover_with_side_bracket.scad
//
// OpenSCAD implementation of a top cover for the Teal Sport drone that 
// includes both stocklike FPV camera and SMA jack holders and small
// side bracket screw attachments. 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

use <teal_drone_top_cover_stocklike.scad>
use <led_strip_holder_bracket.scad>

// Infinitesimal value for ensuring manifold shapes and other special uses. 
slop = 0.01;

teal_sport_body_height = 18; // Couldn't find dimensional drawings; this is only a guess from images. 

// Parameters to match the side LED strip tilt adjustment bracket.
include <curvy_led_strip_holder_parameters.scad>
include <led_strip_holder_bracket_parameters.scad>
include <teal_drone_top_cover_with_side_bracket_parameters.scad>

module side_bracket_shape() {
  union() {
    translate([-bracket_distance_from_teal_body, -bracket_base_inner_position_offset, 0])
    cube([2*side_bracket_thickness + side_bracket_nut_cutout_length, bracket_base_inner_width, bracket_inner_height_over_lip - bracket_inner_top_bevel]);
    
    hull() {
      translate([-bracket_distance_from_teal_body, -bracket_base_inner_position_offset + bracket_inner_top_bevel, bracket_inner_height_over_lip - bracket_inner_top_bevel])
      rotate([0, 90, 0])
      cylinder(r = bracket_inner_top_bevel, h = side_bracket_thickness, $fn = bracket_circle_fineness);
    
      translate([-bracket_distance_from_teal_body, bracket_base_inner_position_offset - bracket_inner_top_bevel, bracket_inner_height_over_lip - bracket_inner_top_bevel])
      rotate([0, 90, 0])
      cylinder(r = bracket_inner_top_bevel, h = side_bracket_thickness, $fn = bracket_circle_fineness);

      translate([-bracket_distance_from_teal_body + 2*side_bracket_thickness + side_bracket_nut_cutout_length, -bracket_base_inner_position_offset, 0])
      cube([slop, bracket_base_inner_width, bracket_inner_height_over_lip - bracket_inner_top_bevel]);
    }
  }
}

module side_bracket_cutout() {
  translate([-bracket_distance_from_teal_body - slop, 0, bracket_mounting_screw_height])
  rotate([0, 90, 0])
  cylinder(r = bracket_mounting_screw_hole_r, h = side_bracket_thickness + 2*slop, $fn = bracket_circle_fineness);

  translate([-bracket_distance_from_teal_body + side_bracket_thickness - slop, 0, bracket_mounting_screw_height])
  rotate([0, 90, 0])
  cylinder(r = side_bracket_nut_cutout_radius, h = side_bracket_nut_cutout_length, $fn = bracket_circle_fineness);

  translate([-bracket_distance_from_teal_body + side_bracket_thickness - slop, -side_bracket_nut_cutout_radius, bracket_mounting_screw_height])
  cube([side_bracket_nut_cutout_length, 2*side_bracket_nut_cutout_radius, bracket_inner_height_over_lip - bracket_mounting_screw_height + slop]);
}

wire_cutout_x = -38;
wire_cutout_y = 0;
wire_cutout_r = 2.5;
wire_cutout_x_scale = 0.8;
wire_cutout_angle = 35;

module wire_cutout() {
  translate([wire_cutout_x, wire_cutout_y, 0])
  rotate([0, -wire_cutout_angle, 0])
  scale([wire_cutout_x_scale, 1, 1])
  translate([0, 0, -10])
  cylinder(r = wire_cutout_r, h = 40, $fn = bracket_circle_fineness);
}


module top_cover_with_side_bracket_base(cut_down_to_bracket = true, preview_camera = false, camera_preview_angle = 0) {
  difference() {
    union() {
      if(cut_down_to_bracket) {
        intersection() {
          teal_stocklike_top_cover(false, 0);
          
          translate([-80, -100, -slop])
          cube([160, 200, mounting_bracket_h]);
        }
      } else {
        teal_stocklike_top_cover(preview_camera, camera_preview_angle);
      }
      
      color(preview_color)
      side_bracket_shape();
      
      color(preview_color)
      mirror([1, 0, 0])
      side_bracket_shape();
    }
    
    side_bracket_cutout();
    
    mirror([1, 0, 0])
    side_bracket_cutout();

    wire_cutout();

    mirror([1, 0, 0])
    wire_cutout();

    // Trim any geomery that extends farther down. 
    translate([-80, -100, -20])
    cube([160, 200, 20 - slop]);

  }
}

module top_cover_horribly_curvy_upper_section(preview_camera = false, camera_preview_angle = 0) {
  intersection() {
    teal_stocklike_top_cover(preview_camera, camera_preview_angle);
    
    translate([-80, -100, mounting_bracket_h+slop])
    cube([160, 200, 30]);
  }
}



top_cover_with_side_bracket_base(false, true, 0);

//difference() {
//rotate([0, 90, 0])
//translate([0, 0, -mounting_bracket_h])
//top_cover_horribly_curvy_upper_section(true, 0);

  // Side mounting brackets.
  %translate([-bracket_distance_from_teal_body - base_post_notch_w - bracket_angle_arm_slot_thickness - bracket_inner_thickness, 0, -teal_sport_body_height/2])
  led_strip_holder_bracket();
  
  %mirror([1, 0, 0])
  translate([-bracket_distance_from_teal_body - base_post_notch_w - bracket_angle_arm_slot_thickness - bracket_inner_thickness, 0, -teal_sport_body_height/2])
  led_strip_holder_bracket();

    //translate([-80, -100, -80])
    //cube([160, 200, 80]);
//}