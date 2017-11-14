// teal_drone_top_cover_plain_parameters.scad
//
// Driving parameters for: teal_drone_top_cover_plain.scad
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

// Mounting Bracket Height: The case shape should try to minimize overhangs below this height. 
mounting_bracket_h = 5.5; 
// Mounting Bracket Lip Height: Force an exact match to the Teal Sport drone shape up to this height.
mounting_bracket_lip_h = 0.5;
// Mounting Bracket Slope Scale: Used to determine the overhang slope in the bracket portion of the top case.
mounting_bracket_slope_scale = 0.9;
mounting_bracket_inner_slop_distance = 3;
// Mounting Bracket Outer Thickness: The bracket will be this thick at the base.
mounting_bracket_outer_thickness = 4;
// Case Top Thickness: How thick the case should be at a horizontal point. This should be the thinnest part of the case.
case_top_thickness = 2;

mounting_clip_inner_r = 2.5; // Radius of holes for mounting to body of Teal Sport Drone
mounting_clip_outer_r = 4; // Outer radius of holders for  mounting to body of Teal Sport Drone
mounting_clip_hole_positions = [ [37.49, 56.15], [37.49, -56.15], [-37.49, 56.15], [-37.49, -56.15],
                                 [45.99, 41.43], [45.99, -41.43], [-45.99, 41.43], [-45.99, -41.43] ];
