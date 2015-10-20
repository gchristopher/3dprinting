// dual_tool_clamp.scad
// Printable effector platform with a larger center opening for Rostock MAX V2.
// This is the top clamp for the dual tool holder.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <effector_constants.scad>

module top_clamp() {
  difference() {
    translate([0, 0, hotend_height + 21.4])
    union() {
      linear_extrude(height = 5.5)
      hull() {
        translate([offset, 0])
        circle(r = top_clamp_outer_r, $fn = 50);
        
        translate([-offset, 0])
        circle(r = top_clamp_outer_r, $fn = 50);
      
        translate([top_clamp_screw_offset, 0])
        circle(r = top_clamp_screw_outer_r, $fn = 30);
      
        translate([-top_clamp_screw_offset, 0])
        circle(r = top_clamp_screw_outer_r, $fn = 30);
      }
      // Add some reinforcement so it doesn't bend as much when clamped tightly down.
      translate([0, 0, 5.5 - slop])
      linear_extrude(height = 4)
      difference() {
        hull() {
          //circle(r = top_clamp_outer_r, $fn = 50);
        
          translate([top_clamp_screw_offset, 0])
          circle(r = top_clamp_screw_outer_r, $fn = 30);
        
          translate([-top_clamp_screw_offset, 0])
          circle(r = top_clamp_screw_outer_r, $fn = 30);
        }
        offset(r = -2) 
        hull() {
          //circle(r = top_clamp_outer_r, $fn = 50);
        
          translate([top_clamp_screw_offset, 0])
          circle(r = top_clamp_screw_outer_r, $fn = 30);
        
          translate([-top_clamp_screw_offset, 0])
          circle(r = top_clamp_screw_outer_r, $fn = 30);
        }
      }
    }
        
    translate([offset, 0, hotend_height + 21.4 - slop])
    cylinder(r = top_clamp_inner_r, h = 5.5 + 2*slop, $fn = 50);
    
    translate([-offset, 0, hotend_height + 21.4 - slop])
    cylinder(r = top_clamp_inner_r, h = 5.5 + 2*slop, $fn = 50);

    translate([0, 0, hotend_height + 21.4 - slop])
    cylinder(r = top_clamp_screw_inner_r, h = 5.5 + 2*slop, $fn = 20);

    translate([top_clamp_screw_offset, 0, hotend_height + 21.4 - slop])
    cylinder(r = top_clamp_screw_inner_r, h = 5.5 + 2*slop, $fn = 20);

    translate([-top_clamp_screw_offset, 0, hotend_height + 21.4 - slop])
    cylinder(r = top_clamp_screw_inner_r, h = 5.5 + 2*slop, $fn = 20);
  }
}

top_clamp();

