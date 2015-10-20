// assembled_preview.scad
// Angled EzStruder Holders for Rostock MAX V2.
// Preview of all holder components assembled and attached to the top plate.  
// By Gregg Christopher, 2015
// This file is public domain. 
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <extruder_constants.scad>
use <extruder_holders.scad>
use <nut_clamp.scad>
use <filament_wire_guide.scad>

color([.6, .2, .2]) linear_extrude(height = melamine_thickness) top_place_centered();
union() {
  translate([0, screw_line_origin, -.1]) {
    for(rot = [screw_line_angle, -screw_line_angle]) {
      color([1, 0, 0]) rotate([0, 0, rot]) {
        translate([-.05, 0, 0]) cube([.1, 100, .1]);
        translate([0, screw1_dist, 0]) cylinder(r = screw_hole_r, height = .1, $fn = 10*res);
        translate([0, screw2_dist, 0]) cylinder(r = screw_hole_r, height = .1, $fn = 10*res);
      }
    }
  }
}

rotate([0, 180, 0])
filament_wire_guide();

translate([0, screw_line_origin, 0])
rotate([0, 0, screw_line_angle - 90])
translate([-center_hole_plate_radius/2, 0, 0])
rotate([90, 180, 0]) {
  left_ezstruder_mount();
  translate([screw1_dist - center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) mirror([0, 1, 0]) nut_clamp();  
  translate([screw2_dist - center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) nut_clamp();  
}

translate([0, screw_line_origin, 0])
rotate([0, 0, -screw_line_angle + 90])
translate([center_hole_plate_radius/2, 0, 0])
rotate([90, 180, 0]) {
  right_ezstruder_mount();
  translate([-screw1_dist + center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) mirror([0, 1, 0]) nut_clamp();
  translate([-screw2_dist + center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) nut_clamp();
}
