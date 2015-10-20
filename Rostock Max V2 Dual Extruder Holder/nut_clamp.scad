// nut_clamps.scad
// Captive nut holders and lateral braces for Angled EzStruder Holders for Rostock MAX V2.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <extruder_constants.scad>

module nut_clamp() {
  // Space for an 6-32 captive nut
  nut_radius = 4.0 / cos(30) * 1.05; // Added 5% allowance for shrinkage and bridging goop. 
  nut_height = 3.0;
  translate([-nut_gap_width/2, -baseplate_thickness/2, 0]) 
  difference() {
    intersection() {
      rotate([0, 90, 0]) scale([1, 1, 1]) cylinder(r = 2*(screw_attachment_thickness + nut_gap_thickness), h = nut_gap_width, $fn = 10*res);
      translate([0, 0, 0]) cube([nut_gap_width, 2*(screw_attachment_thickness + nut_gap_thickness), 2*(screw_attachment_thickness + nut_gap_thickness)]);
    }
    // Trim shape for insertion to main extruder holder body. 
    translate([-manifold_slop, -manifold_slop, -manifold_slop]) cube([nut_gap_width + 2*manifold_slop, baseplate_thickness, screw_attachment_thickness + manifold_slop]);
    translate([-manifold_slop, -manifold_slop, screw_attachment_thickness + nut_gap_thickness]) cube([nut_gap_width + 2*manifold_slop, baseplate_thickness, screw_attachment_thickness + nut_gap_thickness + manifold_slop]);
    // Cutout for captive nut
    translate([nut_gap_width/2, baseplate_thickness/2, screw_attachment_thickness + nut_gap_thickness - nut_height]) rotate([0, 0, 90]) cylinder(r = nut_radius, h = nut_height + manifold_slop, $fn = 6);
    // Screw hole
    translate([nut_gap_width/2, baseplate_thickness/2, screw_attachment_thickness - manifold_slop]) cylinder(r = screw_hole_r, h = screw_attachment_thickness + 2*manifold_slop, $fn = 20);
  }
}

translate([0, 0, nut_gap_width/2])
rotate([0, 90, 0]) nut_clamp(); 
