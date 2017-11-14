// led_strip_holder_bracket.scad
//
// Bracket to allow adjustable tilt mounting of an LED strip to the side of a
// Teal Sport drone. Requires a matching modified top case with a  bracket 
// attachment point. 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

// Module summary:
//
// led_strip_holder_bracket() : A bracket with tilt adjustment to mount the LED strip to the side of the drone.
//
// The bottom of this bracket is pretty blocky to make it easy to print. 
//
// TODO: Consider ways to make it prettier and lighter. 
//       In the meantime, this is solvable by sanding off the ugly corners.

// Infinitesimal value for ensuring manifold shapes and other special uses. 
slop = 0.01;

teal_sport_body_height = 18; // Couldn't find dimensional drawings; this is only a guess from images. 

// Get parameters to match the base post and tilt adjustment arm on the LED strip holder.
include <curvy_led_strip_holder_parameters.scad>

include <led_strip_holder_bracket_parameters.scad>

module rounded_circle_arc(radius, width, thickness, min_theta, max_theta) {
  rotate([0, 90, 0]) {
    intersection() {
      difference() {
        cylinder(r = radius + width/2, h = thickness, $fn = bracket_circle_fineness);
        translate([0, 0, -slop])
        cylinder(r = radius - width/2, h = thickness + 2*slop, $fn = bracket_circle_fineness);
      }
      rotate([0, 0, -90 - min_theta])
      translate([-radius - width/2, 0, 0])
      cube([2*radius + width, radius + width, thickness]);
    
      rotate([0, 0, 90 - max_theta])
      translate([-radius - width/2, 0, 0])
      cube([2*radius + width, radius + width, thickness]);
    }

    rotate([0, 0, -min_theta])
    translate([0, radius, 0])
    cylinder(r = width/2, h = thickness, $fn = bracket_circle_fineness);

    rotate([0, 0, -max_theta])
    translate([0, radius, 0])
    cylinder(r = width/2, h = thickness, $fn = bracket_circle_fineness);
    
  }
}

module led_strip_holder_bracket() {
  // Tilt adjustment arm and post holder.
  difference() {
    union() {
      rotate([180, 0, 0])
      rounded_circle_arc(angle_adjustment_arm_l - angle_adjustment_arm_w/2, angle_adjustment_arm_w, base_post_notch_w, tilt_bracket_min_theta, tilt_bracket_max_theta);
      
      rounded_circle_arc(base_post_notch_r + bracket_post_holder_w/2, bracket_post_holder_w, base_post_notch_w + 2*slop, -60, 120);
      
      translate([0, -bracket_base_outer_width + bracket_base_position_offset, -base_post_notch_r - bracket_post_holder_w - bracket_base_height])
      cube([base_post_notch_w, bracket_base_outer_width, bracket_base_height + bracket_post_holder_w + base_post_notch_r]);
    }

    translate([-slop, 0, 0])
    rotate([180, 0, 0])
    rounded_circle_arc(angle_adjustment_arm_l - angle_adjustment_arm_w/2, 2*angle_adjustment_arm_screw_hole_r, base_post_notch_w + 2*slop, tilt_bracket_min_theta, tilt_bracket_max_theta);
    
    rotate([0, 90, 0])
    translate([0, 0, -slop])
    cylinder(r = base_post_notch_r, h = base_post_notch_w + 2*slop, $fn = 20);
    
    rotate([60, 0, 0])
    translate([-slop, -base_post_notch_r, 0])
    cube([base_post_notch_w + 2*slop, 2*base_post_notch_r, 3*base_post_notch_w]);
  }
  
  // Bracket base.
  hull() {
    translate([0, -bracket_base_outer_width + bracket_base_position_offset, -base_post_notch_r - bracket_post_holder_w - bracket_base_height])
    cube([base_post_notch_w, bracket_base_outer_width, bracket_base_height]);

    translate([base_post_notch_w + bracket_angle_arm_slot_thickness, -bracket_base_inner_width + bracket_base_inner_position_offset, -base_post_notch_r - bracket_post_holder_w - bracket_base_height])
    cube([slop, bracket_base_inner_width, bracket_base_height]);
    
  }

  // Bracket inner upright post.
  difference() {
    union() {
      translate([base_post_notch_w + bracket_angle_arm_slot_thickness, -bracket_base_inner_width + bracket_base_inner_position_offset, -base_post_notch_r - bracket_post_holder_w - bracket_base_height])
      cube([bracket_inner_thickness, bracket_base_inner_width, base_post_notch_r + bracket_post_holder_w + bracket_base_height + teal_sport_body_height/2 + bracket_inner_height_over_lip - bracket_inner_top_bevel]);

      hull() {
        translate([base_post_notch_w + bracket_angle_arm_slot_thickness, -bracket_base_inner_width + bracket_base_inner_position_offset + bracket_inner_top_bevel, teal_sport_body_height/2 + bracket_inner_height_over_lip - bracket_inner_top_bevel])
        rotate([0, 90, 0])
        cylinder(r = bracket_inner_top_bevel, h = bracket_inner_thickness, $fn = bracket_circle_fineness);

        translate([base_post_notch_w + bracket_angle_arm_slot_thickness, bracket_base_inner_position_offset - bracket_inner_top_bevel, teal_sport_body_height/2 + bracket_inner_height_over_lip - bracket_inner_top_bevel])
        rotate([0, 90, 0])
        cylinder(r = bracket_inner_top_bevel, h = bracket_inner_thickness, $fn = bracket_circle_fineness);
      }
    }
   
    translate([base_post_notch_w + bracket_angle_arm_slot_thickness - slop, 0, teal_sport_body_height/2 + bracket_mounting_screw_height])
    rotate([0, 90, 0])
    cylinder(r = bracket_mounting_screw_hole_r, h = bracket_inner_thickness + 2*slop, $fn = 20);
  }

  // Sloped lip with inner shape conformal to the side of the Teal Sport drone body.
  difference() {
    hull() {  
      translate([base_post_notch_w + bracket_angle_arm_slot_thickness + bracket_inner_thickness - slop, -bracket_base_inner_width + bracket_base_inner_position_offset, teal_sport_body_height/2 - bracket_mounting_lip_straight_section_height])
      cube([bracket_mounting_lip_depth, bracket_base_inner_width, bracket_mounting_lip_straight_section_height]);
    
      translate([base_post_notch_w + bracket_angle_arm_slot_thickness + bracket_inner_thickness - slop, -bracket_base_inner_width + bracket_base_inner_position_offset, teal_sport_body_height/2 - bracket_mounting_lip_straight_section_height - bracket_mounting_lip_sloped_section_height])
      cube([slop, bracket_base_inner_width, bracket_mounting_lip_straight_section_height]);
    }
    
    // Use the projection of the top cover for the body shape.
    translate([base_post_notch_w + bracket_angle_arm_slot_thickness + bracket_inner_thickness + bracket_distance_from_teal_body, 0, -teal_sport_body_height/2])
    linear_extrude(height = teal_sport_body_height + slop)
    import("teal_top_cover_outline.dxf");
  }
}

translate([base_post_notch_w + bracket_angle_arm_slot_thickness + bracket_inner_thickness + bracket_distance_from_teal_body, 0, -teal_sport_body_height/2])
%linear_extrude(height = teal_sport_body_height + slop)
import("teal_top_cover_outline.dxf");
  
module post_preview() {
  translate([-base_post_notch_d, 0, 0]) {
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
  }
}

%post_preview();

led_strip_holder_bracket();

translate([-8, 0, 0])
mirror([1, 0, 0])
led_strip_holder_bracket();
