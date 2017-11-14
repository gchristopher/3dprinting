// led_strip_holder_bracket_parameters.scad



// This file depends on values in curvy_led_strip_holder_parameters.scad.
// Include that file first.

// Mounting Bracket Height: The case shape should not have any severe overhangs below this height. 
mounting_bracket_h = 5.5; 


// Minimum and maximum angle for slide arm holder.
tilt_bracket_min_theta = -10;
tilt_bracket_max_theta = 50;

bracket_circle_fineness = 60; // Affects polygon count. Could affect printed model appearance.

bracket_post_holder_w = 6; // Width of round holder for the LED strip post notch. Also determines clearance for the wider portion of the post. 
bracket_angle_arm_slot_thickness = 1.5*angle_adjustment_arm_thickness; // Thickness of slide arm holder

// Size and position of the bracket base section. These might be replaced with math, but picking numbers that look good is relatively easy.
bracket_base_height = 3;
bracket_base_outer_width = 27;
bracket_base_position_offset = 6;

bracket_base_inner_width = 12; // Width of the bracket upright adjacent to the drone body.
bracket_base_inner_position_offset = bracket_base_inner_width/2; // Position offset. Centered by default.
bracket_inner_thickness = 3; // Thickness of the inner bracket section. 
bracket_inner_height_over_lip = 7; // Vertical distance from the top of the drone to the top of the inner bracket. 
bracket_mounting_screw_height = 3; // Vertical distance from the top of the drone to the attachment screw hole center. 
bracket_mounting_screw_hole_r = 3.2/2; // Radius of the attachment screw hole. (M3 sized)
bracket_inner_top_bevel = 4; // Roundness of the top of the inner bracket.


// Dimensions for a sloped lip to the mounting bracket so it doesn't wobble or tilt when installed. 
// (That would be bad, because it'd create a risk of the LED strips hitting the rotors!
bracket_mounting_lip_depth = 2; 
bracket_mounting_lip_straight_section_height = 2;
bracket_mounting_lip_sloped_section_height = 5;

// Distance from center of Teal Sport body shape to inner edge of straight portion of bracket.
// Used to make the sloped lip exactly match the body shape for a conformal fit.
bracket_distance_from_teal_body = 51.2;
