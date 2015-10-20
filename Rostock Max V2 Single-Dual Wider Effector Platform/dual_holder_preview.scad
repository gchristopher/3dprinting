// effector_constants.scad
// Printable effector platform with a larger center opening for Rostock MAX V2.
// This is the preview of all parts assembled.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <effector_constants.scad>
use <wider_effector_platform.scad>
use <dual_tool_holder.scad>
use <dual_tool_clamp.scad>
use <fan_shroud_bottom.scad>

effector_platform();


color([.5, 1, .5, .8])
%rotate([0, 0, -90]) {
  translate([0, offset, hotend_height]) rotate([90, 0, 180 - rotation]) import("E3D_V6_1.75mm_Universal_HotEnd_Mockup.stl");
  translate([0, -offset, hotend_height]) rotate([90, 0, -rotation]) import("E3D_V6_1.75mm_Universal_HotEnd_Mockup.stl");
}

%color([.5, 1, .5, .8])
for(rot = [0, 120, -120]) {
  rotate([0, 0, rot]) {
    translate([0, 32, arm_attachment_height]) {
      cylinder(r = 4, h = spacer_height, $fn = 20);
    }
  }
}
echo("Spacer height is: ", spacer_height);

tool_platform();

top_clamp();

fan_shroud_bottom();
