// fan_shroud_bottom.scad
// Printable effector platform with a larger center opening for Rostock MAX V2.
// This is a small bit of extra material for the fan shroud to keep air restricted to the cooling fins and from flowing over the heater element.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <effector_constants.scad>

module fan_shroud_bottom() {
  // Side fan shroud sections
  difference() {
    union() {
      intersection() {
        translate([-20, -20, arm_attachment_height - 1])
        cube([40, 20, 2]);
        union() {
          translate([-offset, 0, arm_attachment_height - 1])
          cylinder(r = 14.5, h = 2, $fn = 50);
          translate([offset, 0, arm_attachment_height - 1])
          cylinder(r = 14.5, h = 2, $fn = 50);
        }
        
      }
      translate([-15, -17, arm_attachment_height - 1])
      cube([30, 17, 2]);
      
    }
    translate([offset, 0, arm_attachment_height - 1 - slop])
    cylinder(r = 12.5, h = hotend_height + 2.7 + 2*slop, $fn = 50);

    translate([-offset, 0, arm_attachment_height - 1 - slop])
    cylinder(r = 12.5, h = hotend_height + 2.7 + 2*slop, $fn = 50);
  }
}

fan_shroud_bottom();
