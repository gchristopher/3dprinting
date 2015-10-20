// extruder_constants.scad
// A variety of driving variables for angled EzStruder Holders for Rostock MAX V2.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

// Tolerance Variables
manifold_slop = 0.01;
res = 10;

melamine_thickness = 6.4; // Thickness of the melamine sheets used in the Max V2 kit. 
baseplate_thickness = 12; // Thickness of most solid components of the extruder holders.

// Values used in constructing the motor mounts:
motor_cutout_x_pos = -169.329;
motor_cutout_y_pos = 467.08;
motor_x_size = 42.49;
motor_y_size = motor_x_size;

lifter_x_pos = 270.15;
lifter_y_pos = 401.6;

motor_holder_size = 54.3;
ezstruder_mount_height = 28;

lifter_radius = 8.5;
lifter_bottom_distance = 17.9;

motor_side_brace_width = 10;
motor_brace_length = motor_x_size/2 + motor_holder_size/2;
brace_bevel_scale = 2;

motor_mount_width = motor_holder_size + 2*motor_side_brace_width;

// Utilities to display the Max V2 top plate, to check alignment of holder parts. 

top_plate_x_pos = 36.81;
top_plate_y_pos = 296.4;

// Used to preview position of Rostock MAX V2 top plate
module top_place_centered() {
  translate([-top_plate_x_pos, -top_plate_y_pos]) scale([25.4, 25.4]) import("top_plate.dxf");
}

// Used to preview center hole of Rostock MAX V2 top plate
module top_hole_centered() {
  translate([-top_plate_x_pos, -top_plate_y_pos]) scale([25.4, 25.4]) import("top_hole.dxf");
}


top_center_hole_radius = 12.45; // Radius of the plate top center hole

// Parameters for the filament and wire guide. 
center_hole_plate_radius = top_center_hole_radius + 5;
top_plate_thickness = 4;

// Placement and size of screw holes.
screw_line_origin = 14.87;
screw_line_angle = 53.5;

screw_hole_r = 1.8;
screw1_dist = 18.66;
screw2_dist = 63;

screw_attachment_thickness = 10;
nut_gap_thickness = 5;
nut_gap_width = 10;

screw_bracket_1_pos = 35;
screw_bracket_2_pos = 88;

nut_clearance_r = 6;
bracket_wall_thickness = 4;
bracket_length = 8;
bracket_depth_offset = 2.55;
extra_screw_depth = 5;


