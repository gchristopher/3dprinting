// teal_drone_top_cover_stocklike.scad
//
// OpenSCAD implementation of a top cover for the Teal Sport drone that is very
// close in size and shape to that provided by the manufacturer at:
// https://www.thingiverse.com/thing:2597372
//
// This model is builds on the shapes from teal_drone_top_cover_plain.scad and 
// adds a FPV camera mount and port for SMA antenna connector to make it
// functionally similar to the stock Teal Sport drone cover.
//
// This model is intended to be a starting point for drone cover modifications
// that want to preserve the FPV mounting options.
//
// Dimensions for RunCam Swift 2 camera mount taken from: http://shop.runcam.com/runcam-swift-2/
// I couldn't find dimensional drawings for the Rotor Riot edition, so if the case is different
// those constants will need to be changed. 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

// Module summary:
//
// fpv_camera_shape() : preview the FPV camera.
// fpv_camera_holder_outer_shell() : Camera Holder and cowling.
// fpv_camera_holder_inner_cutout() : Cutout for camera holder and cowling.
// fpv_camera_tilt_bracket() : Camera holder and tilt adjustment bracket.
// fpv_camera_tilt_bracket_cutout() : Clearance cutout for access to tilt bracket screws.
// sma_connector_bracket() : SMA connector bracket and cowling.
// sma_connector_bracket_cutout() : Cutout for the SMA connector bracket and cowling.
// main_cover() : The plain cover minus the cutots.
// teal_stocklike_top_cover(preview_camera = false, camera_preview_angle = 0) : Complete stocklike cover with optional camera preview.

use <teal_drone_top_cover_plain.scad>

include <teal_drone_top_cover_stocklike_parameters.scad>

// Infinitesimal value for ensuring manifold shapes and other special uses. 
slop = 0.01;

module fpv_camera_shape() {
  translate([0, fpv_camera_screw_distance, 0])
  difference() {
    union() {
      // Square portion of camera case.
      translate([-fpv_camera_case_w/2, -fpv_camera_square_case_l, -fpv_camera_case_h/2]) {
        cube([fpv_camera_case_w, fpv_camera_square_case_l, fpv_camera_case_h]);
      }
      
      // Tapered portion nearer the lense.
      hull() {
        translate([-fpv_camera_case_w/2, -fpv_camera_square_case_l, -fpv_camera_case_h/2])
        rotate([90, 0, 0])
        linear_extrude(height = slop)
        square([fpv_camera_case_w, fpv_camera_case_w]);
        
        translate([0, -fpv_camera_total_case_l, 0])
        rotate([90, 0, 0])
        linear_extrude(height = slop)
        circle(r = fpv_camera_lense_r + fpv_camera_lense_mount_lip_r, $fn = fpv_camera_circle_fineness);
      }
      
      // Lense
      translate([0, -fpv_camera_total_case_l + slop, 0])
      rotate([90, 0, 0])
      difference() {
        cylinder(r = fpv_camera_lense_r, h = fpv_camera_total_l - fpv_camera_total_case_l, $fn = fpv_camera_circle_fineness);
        
        translate([0, 0, fpv_camera_lense_notch_distance])
        difference() {
          cylinder(r = fpv_camera_lense_r + 1, h = fpv_camera_lense_notch_h, $fn = fpv_camera_circle_fineness);
          translate([0, 0, -slop])
          cylinder(r = fpv_camera_lense_notch_r, h = fpv_camera_lense_notch_h + 2*slop, $fn = fpv_camera_circle_fineness);
        }
      }
      
      // Tilt adjustment screw holders
      translate([0, -fpv_camera_screw_distance, 0]) {
        translate([fpv_camera_case_w/2 + slop, 0, 0])
        rotate([26.575, 0, 0])
        translate([0, fpv_camera_side_screw_distance, 0]) 
        rotate([0, -90, 0])
        difference() {
          cylinder(r = fpv_camera_screw_holder_r, h = 4, $fn = fpv_camera_circle_fineness);
          translate([0, 0, -slop])
          cylinder(r = fpv_camera_mount_screw_r, h = 4 + 2*slop, $fn = fpv_camera_circle_fineness);
        }
    
        translate([-fpv_camera_case_w/2 - slop, 0, 0])
        rotate([26.575, 0, 0])
        translate([0, fpv_camera_side_screw_distance, 0]) 
        rotate([0, 90, 0])
        difference() {
          cylinder(r = fpv_camera_screw_holder_r, h = 4, $fn = fpv_camera_circle_fineness);
          translate([0, 0, -slop])
          cylinder(r = fpv_camera_mount_screw_r, h = 4 + 2*slop, $fn = fpv_camera_circle_fineness);
        }
      }      
    }
    
    //Bottom Screw Holes
    for(x = [-fpv_camera_bottom_screw_spacing, 0, fpv_camera_bottom_screw_spacing]) {
      translate([x, -fpv_camera_screw_distance, -fpv_camera_case_h/2 - slop])
      cylinder(r = fpv_camera_mount_screw_r, h = 4, $fn = 12);
    }
    
    // Side Screw Holes
    translate([0, -fpv_camera_screw_distance, 0]) {
      translate([fpv_camera_case_w/2 + slop, 0, 0])
      rotate([0, -90, 0])
      cylinder(r = fpv_camera_mount_screw_r, h = 4, $fn = 12);

      translate([-fpv_camera_case_w/2 - slop, 0, 0])
      rotate([0, 90, 0])
      cylinder(r = fpv_camera_mount_screw_r, h = 4, $fn = 12);
    }
  }
}


module rounded_circle_arc(radius, width, thickness, min_theta, max_theta) {
  rotate([0, 90, 0]) {
    intersection() {
      difference() {
        cylinder(r = radius + width/2, h = thickness, $fn = camera_holder_circle_fineness);
        translate([0, 0, -slop])
        cylinder(r = radius - width/2, h = thickness + 2*slop, $fn = camera_holder_circle_fineness);
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
    cylinder(r = width/2, h = thickness, $fn = camera_holder_circle_fineness);

    rotate([0, 0, -max_theta])
    translate([0, radius, 0])
    cylinder(r = width/2, h = thickness, $fn = camera_holder_circle_fineness);
    
  }
}

module fpv_camera_holder_outer_shell() {
  hull() {
    translate([0, fpv_camera_screw_distance, 0])
    rotate([-90, 0, 0])
    linear_extrude(height = 3)
    translate([-(camera_holder_mount_width/2 + camera_body_clearance + camera_holder_thickness - camera_holder_body_bevel), -(camera_holder_mount_width/2 + camera_body_clearance + camera_holder_thickness - camera_holder_body_bevel)])
    minkowski() {
      square([camera_holder_mount_width + 2*camera_body_clearance + 2*camera_holder_thickness - 2*camera_holder_body_bevel, camera_holder_mount_width + 2*camera_body_clearance + 2*camera_holder_thickness - 2*camera_holder_body_bevel]);
      circle(r = camera_holder_body_bevel, $fn = 20);
    }

    sphere_x = camera_holder_mount_width/2 + camera_body_clearance + camera_holder_thickness - camera_holder_body_bevel;
    sphere_z = camera_holder_mount_width/2 + camera_body_clearance + camera_holder_thickness - camera_holder_body_bevel;
    for(x = [sphere_x, -sphere_x]) {
      for(z = [sphere_z, -sphere_z]) {
        translate([x, fpv_camera_screw_distance, z])
        sphere(r = camera_holder_body_bevel, $fn = 30);
      }
    }
    
    translate([0, 40, -12])
    scale([1, 1.4, 0])
    cylinder(r = (camera_holder_mount_width + camera_body_clearance + camera_holder_thickness)/2, h = slop);
  }
}

module fpv_camera_holder_inner_cutout() {
  hull() {
    translate([0, fpv_camera_screw_distance- slop, 0])
    rotate([-90, 0, 0])
    linear_extrude(height = 3)
    translate([-(camera_holder_mount_width/2 + camera_body_clearance - camera_holder_body_bevel), -(camera_holder_mount_width/2 + camera_body_clearance - camera_holder_body_bevel)])
    minkowski() {
      square([camera_holder_mount_width + 2*camera_body_clearance - 2*camera_holder_body_bevel, camera_holder_mount_width + camera_body_clearance + 2*camera_holder_thickness -2*camera_holder_body_bevel]);
      circle(r = camera_holder_body_bevel, $fn = 20);
    }

    sphere_x = (camera_holder_mount_width + 2*camera_body_clearance - 2*camera_holder_body_bevel)/2;
    sphere_z = (camera_holder_mount_width + 2*camera_body_clearance - 2*camera_holder_body_bevel)/2;
    for(x = [sphere_x, -sphere_x]) {
      for(z = [sphere_z, -sphere_z]) {
        translate([x, fpv_camera_screw_distance - fpv_camera_square_case_l, z])
        
        sphere(r = camera_holder_body_bevel, $fn = 30);
      }
    }
    
    translate([-camera_holder_lense_cutout_w/2 + camera_holder_lense_cutout_bevel_r, fpv_camera_screw_distance - camera_holder_lense_cutout_d, camera_holder_lense_cutout_w/2 - camera_holder_lense_cutout_bevel_r])
    rotate([-90, 0, 0])
    linear_extrude(height = slop)
    minkowski() {
      square([camera_holder_lense_cutout_w - 2*camera_holder_lense_cutout_bevel_r, camera_holder_lense_cutout_w - 2*camera_holder_lense_cutout_bevel_r]);
      circle(r = camera_holder_lense_cutout_bevel_r, $fn = 20);
    }
    
    translate([0, 40, -12])
    scale([1, 1.4, 0])
    cylinder(r = (camera_holder_mount_width + camera_body_clearance + camera_holder_thickness)/2 - camera_body_clearance, h = slop);
  }

  translate([-camera_holder_lense_cutout_w/2 + camera_holder_lense_cutout_bevel_r, fpv_camera_screw_distance - camera_holder_lense_cutout_d + slop, -camera_holder_lense_cutout_w/2 + camera_holder_lense_cutout_bevel_r])
  rotate([90, 0, 0])
  linear_extrude(height = 30) // Long enough to clear the case, not parameterized.
  minkowski() {
    square([camera_holder_lense_cutout_w - 2*camera_holder_lense_cutout_bevel_r, camera_holder_lense_cutout_w - 2*camera_holder_lense_cutout_bevel_r]);
    circle(r = camera_holder_lense_cutout_bevel_r, $fn = 20);
  }
}

module fpv_camera_tilt_bracket() {
  translate([camera_holder_mount_width/2, 0, 0])
  difference() {
    hull() {
      rotate([0, 90, 0])
      cylinder(r = camera_holder_screw_holder_r, h = camera_holder_thickness, $fn = camera_holder_circle_fineness);
  
      rounded_circle_arc(fpv_camera_side_screw_distance, 2*camera_holder_screw_holder_r, camera_holder_thickness, tilt_bracket_min_theta, tilt_bracket_max_theta);
    }
  
    rotate([0, 90, 0])
    translate([0, 0, -slop])
    cylinder(r = camera_holder_screw_hole_r, h = camera_holder_thickness + 2*slop, $fn = camera_holder_circle_fineness);

    translate([-slop, 0, 0])
    rounded_circle_arc(fpv_camera_side_screw_distance, 2*camera_holder_screw_hole_r, camera_holder_thickness + 2*slop, tilt_bracket_min_theta, tilt_bracket_max_theta);
  }

  translate([-camera_holder_mount_width/2, 0, 0])
  difference() {
    hull() {
      rotate([0, -90, 0])
      cylinder(r = camera_holder_screw_holder_r, h = camera_holder_thickness, $fn = camera_holder_circle_fineness);
      mirror([1, 0, 0])
      rounded_circle_arc(fpv_camera_side_screw_distance, 2*camera_holder_screw_holder_r, camera_holder_thickness, tilt_bracket_min_theta, tilt_bracket_max_theta);
    }
    
    rotate([0, -90, 0])
    translate([0, 0, -slop])
    cylinder(r = camera_holder_screw_hole_r, h = camera_holder_thickness + 2*slop, $fn = camera_holder_circle_fineness);

    mirror([1, 0, 0])
    translate([-slop, 0, 0])
    rounded_circle_arc(fpv_camera_side_screw_distance, 2*camera_holder_screw_hole_r, camera_holder_thickness + 2*slop, tilt_bracket_min_theta, tilt_bracket_max_theta);
  }
}

module fpv_camera_tilt_bracket_cutout() {
  // ggg TODO: Revisit this shape completely in light of adding a cowling.
  translate([camera_holder_mount_width/2, 0, 0])
  hull() {
    rotate([0, 90, 0])
    cylinder(r = camera_holder_screw_holder_r - 1, h = camera_holder_thickness, $fn = camera_holder_circle_fineness);
  
    rounded_circle_arc(fpv_camera_side_screw_distance + camera_holder_screw_holder_r - 1, slop, camera_holder_thickness + 8, tilt_bracket_min_theta - 15, tilt_bracket_max_theta + 15); // ggg TODO figure out how to parameterize this shape
  }  

  translate([-camera_holder_mount_width/2, 0, 0])
  mirror([1, 0, 0])
  hull() {
    rotate([0, 90, 0])
    cylinder(r = camera_holder_screw_holder_r - 1, h = camera_holder_thickness, $fn = camera_holder_circle_fineness);
  
    rounded_circle_arc(fpv_camera_side_screw_distance + camera_holder_screw_holder_r - 1, slop, camera_holder_thickness + 8, tilt_bracket_min_theta - 15, tilt_bracket_max_theta + 15); // ggg TODO figure out how to parameterize this shape
  }  
}

// ggg TODO: add an under-bracket section below the camera lense.

// ggg TODO: add front air vent cutout and cowling

module sma_connector_bracket() {
  rotate([90 + sma_connector_angle, 0, 0]) {
    cylinder(r = sma_connector_cowling_inner_r + sma_connector_cowling_thickness, h = sma_connector_cowling_length, $fn = sma_connector_circle_fineness);
    translate([-sma_connector_cowling_inner_r - sma_connector_cowling_thickness, -sma_connector_cowling_height, 0])
    cube([2*(sma_connector_cowling_inner_r + sma_connector_cowling_thickness), sma_connector_cowling_height, sma_connector_cowling_length]);
  }
}

module sma_connector_bracket_cutout() {
  rotate([90 + sma_connector_angle, 0, 0]) {
    // Hole for jack.
    translate([0, 0, -slop])
    cylinder(r = sma_connector_jack_hole_r, h = sma_connector_cowling_thickness + 2*slop, $fn = sma_connector_circle_fineness);
    
    // Rouded interior cavity.
    translate([0, 0, sma_connector_cowling_thickness])
    cylinder(r = sma_connector_cowling_inner_r, h = sma_connector_cowling_length - sma_connector_cowling_thickness + slop, $fn = sma_connector_circle_fineness);
    
    // Squared portion of interior cavity.
    translate([-sma_connector_cowling_inner_r, -sma_connector_cowling_height - slop, sma_connector_cowling_thickness - slop])
    cube([2*sma_connector_cowling_inner_r, sma_connector_cowling_height, sma_connector_cowling_length - sma_connector_cowling_thickness + 2*slop]);
  }
}

module main_cover() {
  difference() {
    render(convexity = 10)
    teal_cover_plain();
    translate([0, fpv_camera_position_forward, fpv_camara_position_h])
    fpv_camera_holder_inner_cutout();
  
    translate([0, fpv_camera_position_forward, fpv_camara_position_h]) {
        fpv_camera_holder_inner_cutout();
        
        fpv_camera_tilt_bracket_cutout();
      }
    translate([0, sma_connector_position_rear, sma_connector_position_h])
    sma_connector_bracket_cutout();
  }
}


module teal_stocklike_top_cover(preview_camera = false, camera_preview_angle = 0) {
  // Apply brackets/cowlings/cutouts to plain case shape.
  difference() {
    union() {
      // Camera bracket and cowling
      difference() {
        translate([0, fpv_camera_position_forward, fpv_camara_position_h])
        fpv_camera_holder_outer_shell();
        
        translate([0, fpv_camera_position_forward, fpv_camara_position_h]) {
          fpv_camera_holder_inner_cutout();
          
          fpv_camera_tilt_bracket_cutout();
          
        }
      }

      // SMA jack and cowling
      translate([0, sma_connector_position_rear, sma_connector_position_h])
      difference() {
        sma_connector_bracket();
        sma_connector_bracket_cutout();
      }

    }

    // Do not invade case inner volume with external bracket.
    render(convexity = 5)
    case_inner_volume();
    
    // Trim any geomery that extends farther down. 
    translate([-80, -100, -20])
    cube([160, 200, 20]);
  }
 
  translate([0, fpv_camera_position_forward, fpv_camara_position_h]) {
    fpv_camera_tilt_bracket();
    if(preview_camera) {
      rotate([-camera_preview_angle, 0, 0])
      %fpv_camera_shape();
    }
  }

  main_cover();
}


teal_stocklike_top_cover(true, 0);
