// teal_drone_top_cover_with_side_bracket_parameters.scad
//
// Driving parameters for teal_drone_top_cover_with_side_bracket.scad
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

preview_color = [0, .7, 1];

side_bracket_thickness = 3; // Thickness of the screw holder bracket to which the side bracket attaches.
side_bracket_nut_cutout_radius = 6/2; // Cutout for a M3 nut.
side_bracket_nut_cutout_length = 7; // Length of cutout for nut.

// Cut a hole for LED wiring:
wire_cutout_x = -38; // X position of base of hole.
wire_cutout_y = 0; // Y position of base of hole.
wire_cutout_r = 2.5; // Radius.
wire_cutout_x_scale = 0.8; // Scale hole by this amount on the x axis. (It's probably going to be ribbon cable.)
wire_cutout_angle = 35; // Tile wire hole by this angle.