// dual_tool_holder.scad
// Printable effector platform with a larger center opening for Rostock MAX V2.
// This is the main section of the dual tool holder and integrated fan shroud.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <effector_constants.scad>;

module tool_platform() {
  // Dual tool platform and upper portion of the fan shroud.
  difference() {
    union() {
      // Cylinder shapes for holding the hot ends.
      for(holder_offset = [offset, -offset]) {
        translate([holder_offset, 0, hotend_height + 11.7]) {
          cylinder(r = 17, h = 5.5, $fn = 50);
          translate([0, 15, 0]) cylinder(r = 14, h = 5.5, $fn = 50);
          translate([-14, 0, 0]) cube([28, 15, 5.5]);
        }
      }
    
      // Brace section forming a triangle between the three mounting screws/supports.
      translate([0, 0, hotend_height + 11.7])
      for(rot = [0, 120, -120]) {
        rotate([0, 0, rot]) {
          // Top portion of the material above the vertical supports
          translate([0, 32, 0]) {
            cylinder(r = 4, h = 5.5, $fn = 20);
          }

          // Extension portion of the vertical supports. The vague idea is these are filed down as needed to get the hot ends perfectly level. 
          translate([0, 32, -printed_support_height]) {
            cylinder(r = 4, h = printed_support_height, $fn = 20);
          }

          corner_length = 2 * cos(30) * 32;
          
          translate([0, 32, 0]) rotate([0, 0, 150]) translate([-4, 0, 0]) cube([8, corner_length, 5.5]);
        }
      }
      
      // Panel to cover up the corner of the triangle above the old fan shroud area.
      translate([0, -12, hotend_height + 11.7 + 4.5]) {
        cylinder(r = 3, h = 1);
      }
      
      // Cover another hole in the holder
      translate([0, 22, hotend_height + 11.7 + 4.5]) {
        cylinder(r = 4, h = 1);
      }

      // Side fan shroud sections
      difference() {
        union() {
          intersection() {
            translate([offset, 0, arm_attachment_height + 1])
            cylinder(r = 14.5, h = hotend_height + 2.7, $fn = 50);
            
            rotate([0, 0, -fan_rot2-10])
            translate([33.5, fan_dy - 6 - 5, arm_attachment_height+1])
            rotate([90, 0, -fan_rot])
            cube([17, hotend_height + 2.7, 30]);
          }
  
          intersection() {
            translate([-offset, 0, arm_attachment_height + 1])
            cylinder(r = 14.5, h = hotend_height + 2.7, $fn = 50);
            
            rotate([0, 0, fan_rot2+10])
            translate([-16.3, fan_dy - 6 - 8, arm_attachment_height+1])
            rotate([90, 0, fan_rot])
            cube([17, hotend_height + 2.7, 30]);
          }
          
          translate([0, -6, arm_attachment_height + 1])
          intersection() {
            cylinder(r = 6, h = hotend_height + 2.7);
            translate([-2, -4, 0]) cube([4, 12, hotend_height + 2.7]);
          }
        }
        translate([offset, 0, arm_attachment_height + 1 - slop])
        cylinder(r = 12.5, h = hotend_height + 2.7 + 2*slop, $fn = 50);
  
        translate([-offset, 0, arm_attachment_height + 1 - slop])
        cylinder(r = 12.5, h = hotend_height + 2.7 + 2*slop, $fn = 50);
      }
    }
  
    // Cutouts to insert and hold the hot ends. 
    for(holder_offset = [offset, -offset]) {
      translate([holder_offset, 0, hotend_height + 11.7]) {
        translate([0, 0, -slop]) cylinder(r = 6, h = 5.5 + 2*slop, $fn = 50);
        translate([0, 15, -slop]) cylinder(r = 8, h = 5.5 + 2*slop, $fn = 50);
        translate([-6, 0, -slop]) cube([12, 20, 5.5 + 2*slop]);
      }
    }
    
    // Screw holes for the vertical supports.  
    translate([0, 0, hotend_height + 11.7 - printed_support_height])
    for(rot = [0, 120, -120]) {
      rotate([0, 0, rot]) {
        translate([0, 32, -slop]) {
          cylinder(r = upright_screw_r, h = 5.5 + printed_support_height + 2*slop, $fn = 20);
        }
      }
    }

    // Holes for the top clamp screws.
    translate([0, 0, hotend_height + 11.7 - 2*slop])
    cylinder(r = top_clamp_screw_inner_r, h = 5.5 + 3*slop, $fn = 20);

    translate([top_clamp_screw_offset, 0, hotend_height + 11.7 - slop])
    cylinder(r = top_clamp_screw_inner_r, h = 5.5 + 2*slop, $fn = 20);

    translate([-top_clamp_screw_offset, 0, hotend_height + 11.7 - slop])
    cylinder(r = top_clamp_screw_inner_r, h = 5.5 + 2*slop, $fn = 20);
    
    // Extra clearance for the center top clamp screw nut.
    translate([0, 0, hotend_height + 11.7 - 6 - slop])
    cylinder(r = top_clamp_screw_inner_r + 3, h = 6, $fn = 20);

    // Cutout for the fan.
    difference() {
      union() {
        translate([0, -14, arm_attachment_height+1])
        rotate([90, 0, 0]) {
          translate([0, 0.5, 0])
          fan_30_mm(0);
          translate([-15, 24, -fan_screw_attachment_h]) 
          cube([6, 6, fan_screw_attachment_h]);
          translate([9, 24, -fan_screw_attachment_h])
          cube([6, 6, fan_screw_attachment_h]);
        }
      }
    }

  }

  // Fan screw brackets
  difference() {
    union() {
      translate([0, -14, arm_attachment_height+1])
      rotate([90, 0, 0]) {
        %fan_30_mm();
        translate([-15, 24, -fan_screw_attachment_h]) 
        difference() {
          cube([6, 6, fan_screw_attachment_h]);
          translate([3, 3, -slop]) cylinder(r = 1.5, h = fan_screw_attachment_h + 2*slop, $fn = 16);
        }
        translate([9, 24, -fan_screw_attachment_h])
          difference() {
          cube([6, 6, fan_screw_attachment_h]);
          translate([3, 3, -slop]) cylinder(r = 1.5, h = fan_screw_attachment_h + 2*slop, $fn = 16);
        }
      }
    }
  }
     
}

// Rotate upside-down for printing
rotate([0, 180, 0])
tool_platform();
