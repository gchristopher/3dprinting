// teal_drone_plus_led_strips_assembled_preview.scad
// 
// Assembly preview and clearance check for the Teal Sport drone LED strip
// holder project. 
//
// Not intended to produce anything printable. This file is for checking 
// that everything goes together as intended and doesn't intersect the 
// drone body or rotor keep-out area 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

use <curvy_led_strip_holder.scad>;
use <led_strip_holder_bracket.scad>
use <teal_drone_top_cover_with_side_bracket.scad>

// Infinitesimal value for ensuring manifold shapes and other special uses. 
slop = 0.01;

include <curvy_led_strip_holder_parameters.scad>
include <led_strip_holder_bracket_parameters.scad>

led_strip_tilt = 25;
led_strip_mounting_distance = 66; // TDO: This should be calculated, not a constant.
teal_sport_body_height = 18; // Couldn't find dimensional drawings; this is only a guess from images. 
teal_battery_height = 15; // Also complete conjecture,

// Preview 
rotate([led_strip_tilt, 0, 0]) {

  // Led holder strips.
  translate([-led_strip_mounting_distance, 0, 0])
  translate([0, 0, -12])
  rotate([-led_strip_tilt, 0, 0])
  curvy_led_strip_holder(true, false);

  translate([led_strip_mounting_distance, 0, 0])
  translate([0, 0, -12])
  rotate([-led_strip_tilt, 0, 0])
  mirror([1, 0, 0])
  curvy_led_strip_holder(true, false);
  
  // Side mounting brackets.
  color([0.5, 0.5, 0.2])
  translate([-bracket_distance_from_teal_body - base_post_notch_w - bracket_angle_arm_slot_thickness - bracket_inner_thickness, 0, -teal_sport_body_height/2])
  led_strip_holder_bracket();

  color([0.5, 0.5, 0.2])
  mirror([1, 0, 0])
  translate([-bracket_distance_from_teal_body - base_post_notch_w - bracket_angle_arm_slot_thickness - bracket_inner_thickness, 0, -teal_sport_body_height/2])
  led_strip_holder_bracket();
  
  // Stocklike top cover.
  //teal_stocklike_top_cover(true, led_strip_tilt);
  
  top_cover_base_bracket();
  top_cover_horribly_curvy_upper_section(true, led_strip_tilt);
  
  // Drone body and rotor preview. (Some dimensions are conjectural, based on available images.)
  teal_preview_estimate();

}


module teal_preview_estimate() {
  body_color = [0.2, 0.2, 0.2];
  
  // Body estimate
  color(body_color)
  translate([0, 0, -teal_sport_body_height])
  linear_extrude(height = teal_sport_body_height)
  offset(r = slop)
  import("teal_top_cover_outline.dxf");

  // Battery estimate
  color(body_color)
  translate([0, 0, -teal_sport_body_height])
  mirror([0, 0, 1])
  linear_extrude(height = teal_battery_height, scale = .8)
  import("teal_top_cover_outline.dxf");

  // Plain Top Cover
  //color(body_color)
  //translate([-60+0.35, 80+2.1, -10+0.5])
  //rotate([90, 0, 0])
  //import("TealTopCoverBlank1.STL", convexity = 10);
  
  // Arms and Rotors
  for(x = [101, -101]) {
    for(y = [83, -83]) {
      // Prop keep-out area estimates:
      %color([0.3, 0.3, 0.7, 0.4])
      translate([x, y, 8.25])
      cylinder(r = 127/2, h = 10);
      
      color([0.9, 0.9, 0.9])
      translate([x, y, 0])
      cylinder(r1 = 28/2, r2 = 26/2, h = 7);
  
      color([0.9, 0.9, 0.9])
      translate([x, y, 7])
      cylinder(r = 4, h = 6);
  
      color(body_color)
      translate([x, y, -teal_sport_body_height*2/3]) {
        cylinder(r = 30/2, h = teal_sport_body_height*2/3);
        difference() {
          translate([0, 0, -22 + slop]) {
            cylinder(r1 = 5, r2 = 15, h = 22);
            sphere(r = 5, $fn = 30);
          }
          translate([0, 0, -24])
          rotate_extrude()
          translate([17, 0, 0])
          scale([0.5, 1, 1])
          circle(r = 24, $fn = 30);
        }
      }
      
      color(body_color)
      translate([x, y, -teal_sport_body_height*2/3])
      rotate([0, 0, atan2(x, -y * .66)])
      translate([-26/2, 0, 0])
      cube([26, 90, teal_sport_body_height*2/3]);
    }
  }
}