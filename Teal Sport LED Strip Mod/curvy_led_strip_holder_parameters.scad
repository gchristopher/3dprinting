// curvy_led_strip_holder_parameters.scad
//
// Driving parameters for curvy_led_strip_holder.scad
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

// Strip Length Estimates:
// 30 LEDs: 20.8cm
// 32 LEDs: 22.2cm

led_strip_width = 14; // Including weather stripping
led_strip_thickness = 4; // Including weather stripping
led_strip_length = 208; 

// These values are only used for the approximate preview of the LED strip
led_spacing = 1000/144; 
led_width = 5;
led_height = 2;
led_backing_thickness = 0.2;

led_holder_front_thickness = 1.5; // Thickness of LED holder section in front (lit side) of the LED strip
led_holder_back_thickness = 2; // Thickness of holder behind the LEDs
led_holder_side_thickness= 1.5; // Thickness of holder on leading and trailing edge. (Not including the curved section on the leading edge.
led_holder_clip_length = 2; // Length of the strips in front of the LEDs that hold the LED strip in place. 
led_holder_bevel_r = 1; // Roundness of the strip body.
led_holder_leading_edge_r = 1.5; // Radius of the front of the leading edge curved section of the LED strip.
led_holder_bottom_cap_thickness = 2; // Thickness of the solid bottom of the strip that keeps the LEDs from sliding down or contacting the ground. 

led_holder_length = led_strip_length; 

// The LED holder strip consists of a straight center section, then two sections that follow
// a circular arc above and below the center section. (So it curves back toward the drone
// body, then straightens out.) If those circular sections are shorter than the specified
// strip holder length, straight sections are appended to the ends. (If they end up being 
// longer, then change the curve section parameters to get the total length back down to the 
// desired value.)

led_holder_straight_center_length = 15; // Length of the center straight section.

curvy_section_r = 80; // Radius of the circular arc. 
curvy_section_theta = 25; // Arc length of each section, in degrees. (There will be a total of four.)

// Parameters describing the swivel base post and tilt angle adjustment arm.
base_post_length = 6.5;
base_post_r = 5;
base_post_notch_r = 3;
base_post_notch_d = 1;
base_post_notch_w = 3;

angle_adjustment_arm_l = 22;
angle_adjustment_arm_w = base_post_r * 2;
angle_adjustment_arm_thickness  = 2.5;
angle_adjustment_arm_screw_hole_r = 1.7;
