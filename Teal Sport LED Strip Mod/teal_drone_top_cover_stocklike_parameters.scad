// teal_drone_top_cover_stocklike_parameters.scad
//
// Driving parameters for teal_drone_top_cover_stocklike.scad
//
// Dimensions for RunCam Swift 2 camera mount taken from: http://shop.runcam.com/runcam-swift-2/
// I couldn't find dimensional drawings for the Rotor Riot edition, so if the case is different
// those constants will need to be changed. 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

preview_color = [0, .7, 1];

// Dimensional variables for a RunCam Swift 2 camera. Mostly for the engineering preview view.
fpv_camera_case_w = 28.5; // Width of main camera case.
fpv_camera_case_h = 28.5; // Height of main camera case.
fpv_camera_square_case_l = 6+1; // Length of square, non-tapered section of camera case.
fpv_camera_total_case_l = 17; // Length of case, including tapered section before the lense.
fpv_camera_total_l = 27; // Total length of camera including lense.
fpv_camera_lense_r = 14/2; // Radius of lense.
fpv_camera_lense_mount_lip_r = 1; // Roundness/bevel radius of small end of tapered section.
fpv_camera_circle_fineness = 30; // Affects polygon count.
fpv_camera_lense_notch_distance = 3; // Distance of notch in lense, from base of lense.
fpv_camera_lense_notch_r = fpv_camera_lense_r - 1; // Radius of notched section of lense. 
fpv_camera_lense_notch_h = 2; // Width of notch in lense. 

// Screw positions! These will affect the camera bracket shape. 
fpv_camera_side_screw_distance = 9; // Defines Radius of tilt mount for the FPV camera.
fpv_camera_bottom_screw_spacing = 6; // Distance between each of the three bottom screws.
fpv_camera_screw_distance = 3.4; // Distance from the back edge of the case to the screws. 
fpv_camera_mount_screw_r = 2.1/2; // Radius of screw holes. 
fpv_camera_screw_holder_r = 6/2; // Radius of material surrouding each screw hole.

// Dimensional variables for the camera holder bracket. 
camera_holder_screw_holder_r = 8/2; // Radius of material surrouding each screw hole in the bracket.
camera_holder_thickness = 2; // Wall thickness for the bracket. 
camera_holder_mount_width = 28.5; // Width of the bracket. Should be snug or else tighening screws will deform the case.

camera_holder_circle_fineness = 40; // Affects polygon count. Could affect printed model appearance.
camera_holder_screw_hole_r = 2.1/2; // Radius of screw holes and tilt adjustment screw slide slot.
camera_body_clearance = 1.5; // Extra clearance between the camera and non-bracket cowling/case parts. 
camera_holder_body_bevel = 2; // Bevel radius for some curved parts of the camera cowling. 

camera_holder_lense_cutout_w = 20; // Width of the cutout in the case for the front of the camera and lense. 
camera_holder_lense_cutout_bevel_r = 5; // Bevel radius for the camera lense cutout.
camera_holder_lense_cutout_d = 20; // Affects the cutout shape. Measured from the base of the camera at 0 tilt. 

// Variables describing the shape of the under-cowling for the FPV camera tilt bracket for screw access.
// Position, size, and scaling of sphere that forms one end of the hull. (The other end is the tilt bracket.)
fpv_camera_tilt_bracket_under_cowling_boundary_sphere_x_pos = 29.530; 
fpv_camera_tilt_bracket_under_cowling_boundary_sphere_y_pos = -35;
fpv_camera_tilt_bracket_under_cowling_boundary_sphere_z_pos = 10;
fpv_camera_tilt_bracket_under_cowling_boundary_sphere_r = 5;
fpv_camera_tilt_bracket_under_cowling_boundary_sphere_x_scale = 2;
fpv_camera_tilt_bracket_under_cowling_thickness = case_top_thickness - 0.5;
fpv_camera_tilt_bracket_under_cowling_cutoff_distance = 9; // Offset of a straight-edge cutoff to keep the cowling from extending too far back into the interior volume.

tilt_bracket_min_theta = -35; // Minimum angle (highest point) of the tilt adjustment slider. 
// Min Theta determines lowest angle camera can point. The RunCam Swift 2 needs at least -27 degrees to point stright forward.
tilt_bracket_max_theta = 20; // Maximum angle (lowest point) of the tilt adjustment slider. 
// Max Theta determines the highest angle the camera can point up. Similarly, add 27 to this to get a practical max upward tilt, in degrees. 

// Variables that position the camera relative to the center of the base. (This position will be the midpoint of the 2 center side mounting screws on the camera.)
fpv_camera_position_forward = -42;
fpv_camara_position_h = 15;

// Dimensional variables for SMA connector slot and cowling.
sma_connector_jack_hole_r = 6.5/2; // Hole for the SMA jack. Should be a snug fit. 
sma_connector_cowling_inner_r = 6.5/2 + 2; // Inner diameter of cowling leading to SMA jack. 
sma_connector_cowling_thickness = 2; // Thickness of cowling around the SMA connector.
sma_connector_angle = 18; // Angle of SMA connector, from horizontal.
sma_connector_cowling_length = 30; // Just needs to be long enough to completely intersect the top case.
sma_connector_cowling_height = 20; // Square portion, any value long enough to completely interesect the top case.
sma_connector_circle_fineness = 60; // Affects polygon count. Could affect printed model appearance.
// Position of center of SMA connector hole, relative to the center of the base.
sma_connector_position_rear = 65; 
sma_connector_position_h = 16; 

// Front and rear vent cowlings are both conical sections defined by ellipses (made by scaling a circle) at each end. 
front_vent_cowling_opening_radius = 19;
front_vent_cowling_end_radius = 8;
front_vent_cowling_y_scale = 0.6;
front_vent_cowling_angle = 12;
front_vent_cowling_opening_x_pos = -20;
front_vent_cowling_opening_y_pos = -31.5;
front_vent_cowling_opening_z_pos = 10;
front_vent_cowling_end_x_pos = -25;
front_vent_cowling_end_y_pos = 15;
front_vent_cowling_end_z_pos = 4.5;
front_vent_cowling_thickness = case_top_thickness;

rear_vent_cowling_opening_radius = 20;
rear_vent_cowling_end_radius = 9;
rear_vent_cowling_y_scale = 0.45;
rear_vent_cowling_angle = 20;
rear_vent_cowling_opening_x_pos = -18;
rear_vent_cowling_opening_y_pos = 60;
rear_vent_cowling_opening_z_pos = 7;
rear_vent_cowling_end_x_pos = -20;
rear_vent_cowling_end_y_pos = -10;
rear_vent_cowling_end_z_pos = 3.5;
rear_vent_cowling_thickness = case_top_thickness;


