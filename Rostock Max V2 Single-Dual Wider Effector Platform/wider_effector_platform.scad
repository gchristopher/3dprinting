// wider_effector_platform.scad
// Printable effector platform with a larger center opening for Rostock MAX V2.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <effector_constants.scad>

module effector_platform() {
  difference() {
    union() {
      // Rotationally symmetric parts:
      for(rot = [0, 120, -120]) {
        rotate([0, 0, rot]) {
          // Layer fan or whatever attachment flanges.
          translate([0, 0, arm_attachment_height-flange_thickness]) 
          difference() {
            union() {
              translate([0, 45, 0])
              cylinder(r = 4.5, h = flange_thickness, $fn = 30);
          
              translate([-4.5, 20, 0])
              cube([9, 25, flange_thickness]);
            }
      
            translate([0, 45, -slop])
            cylinder(r = 1.6, h = 5, $fn = 20);
          }
          
          // Screw holder blocks. (Maybe too beefy?)
          translate([-arm_attachment_width/2, -37.5, 0])
          translate([arm_attachment_bevel, arm_attachment_bevel, arm_attachment_bevel])
          minkowski() {
            cube([arm_attachment_width - arm_attachment_bevel*2, 9 - arm_attachment_bevel*2, arm_attachment_height - arm_attachment_bevel*2]);
            sphere(r = arm_attachment_bevel, $fn = 30);
          }
          
          // Extra material to hole the 4-40 set screws
          for(offset = [-set_screw_offset, set_screw_offset]) {
            rotate([0, 0, 60])
            translate([offset, 25, arm_attachment_height/2 - screw_4_40_r - arm_screw_r])
            rotate([-90, 0, 0])
            cylinder(r = screw_4_40_nut_r + 1, h = arm_attachment_height, $fn = 30);
          }
  
          // Extra brace material around the screw holes for the upper tool platform.
          translate([0, 32, 0])
          cylinder(r = 7.0, h = arm_attachment_height, $fn = 20);
      
        }
      }
  
      // Main cylindrical body.
      cylinder(r = 35, h = arm_attachment_height, $fn = 60);
      
    }
  
    // Rotationally symmetric cutouts:
    for(rot = [0, 120, -120]) {
      rotate([0, 0, rot]) {
        // Screw holes for the upper tool platform spacers.
        translate([0, 32, -slop]) {
          cylinder(r = upright_screw_r, h = arm_attachment_height + 2*slop, $fn = 20);
          cylinder(r = 4, h = 4, $fn = 20);
        }
  
        // Holes for the screws connecting the delta arms.
        translate([0, -33, arm_attachment_height/2])
        rotate([0, 90, 0])
        translate([0, 0, -arm_screw_length/2])
        cylinder(r = arm_screw_r, h = arm_screw_length, $fn = 20);

        // Threaded Rod for arm attachment preview.
        %color([0.5, 1.0, 0.5, 0.8])
        translate([0, -33, arm_attachment_height/2])
        rotate([0, 90, 0])
        translate([0, 0, -arm_screw_length/2])
        cylinder(r = arm_screw_r, h = arm_screw_length, $fn = 20);
        
        // Cutout for the screw to be placed, then held by set screws.
        rotate([0, 0, 60])
        translate([-12, 33 + arm_screw_r/3, -screw_4_40_nut_r - 2 - slop])
        cube([24, 10, arm_attachment_height/2 + arm_screw_r*2/3 + screw_4_40_nut_r + 2 + slop]);

        // Extra clearance at the end of the rod holder screw holes. 
        // These sections are braces to prevent the lock nuts from torquing the screws,
        // and to not actually hold or stabilize the screws.
        translate([11.5, -33, arm_attachment_height/2])
        rotate([0, 90, 0])
        cylinder(r = arm_screw_r*1.25, h = 8, $fn = 20);

        translate([-11.5, -33, arm_attachment_height/2])
        rotate([0, -90, 0])
        cylinder(r = arm_screw_r*1.25, h = 8, $fn = 20);

        for(offset = [-set_screw_offset, set_screw_offset]) {
          // Set screw and nut holes:
          rotate([0, 0, 60])
          translate([offset, 24, arm_attachment_height/2 - screw_4_40_r - arm_screw_r])
          rotate([-90, 0, 0]) {
            cylinder(r = screw_4_40_r, h = 15, $fn = 30);
            translate([0, 0, 0]) rotate([0, 0, 90]) cylinder(r = screw_4_40_nut_r, h = 3.5, $fn = 6);
          }
          
          // Set screw preview
          %color([0.5, 1.0, 0.5, 0.8])
          rotate([0, 0, 60])
          translate([offset, 24, arm_attachment_height/2 - screw_4_40_r - arm_screw_r])
          rotate([-90, 0, 0]) {
            cylinder(r = screw_4_40_r, h = 13, $fn = 30);
            translate([0, 0, 10.5]) cylinder(r = screw_4_40_washer_r, h = 1, $fn = 30);
            translate([0, 0, 1]) rotate([0, 0, 90]) cylinder(r = screw_4_40_nut_r, h = 2.5, $fn = 6);
          }
          
        }
        
        
        // Cutouts at the end of each screw platform to leave plenty of room for the arm attachment to move.
        translate([37/2 + slop, -33, arm_attachment_height/2])
        rotate([0, 90, 0])
        cylinder(r = 6.5, h = 5, $fn = 30); 
  
        translate([-37/2 - slop, -33, arm_attachment_height/2])
        rotate([0, -90, 0])
        cylinder(r = 6.5, h = 5, $fn = 30); 
      }
    }
  
    // Center circular cutout. 
    translate([0, 0, -slop])
    difference() {
      cylinder(r = 27, h = arm_attachment_height + 2*slop, $fn = 50);
      for(rot = [0, 120, -120]) 
      rotate([0, 0, rot]) {
        translate([0, 32, -2*slop])
        cylinder(r = 7.0, h = arm_attachment_height + 4*slop, $fn = 20);
        
        // Reinforcement for sections of the circle nearest the cutouts for the arm attachment rods
        rotate([0, 0, 60]) {
          translate([-15, 25, 0]) 
          cube([30, 3, arm_attachment_height]);
        }
      }
    }
  
  }
}

// Rotate upside-down for printing
rotate([0, 180, 0])
effector_platform();
