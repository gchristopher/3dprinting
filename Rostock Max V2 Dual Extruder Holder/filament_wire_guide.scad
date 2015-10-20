// filament_wire_guide.scad
// Angled EzStruder Holders for Rostock MAX V2.
// Wire and filament guide for the center hole of the top plate. 
// By Gregg Christopher, 2015
// This file is public domain. 
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

include <extruder_constants.scad>
use <extruder_holders.scad>

x_size = 14;

module filament_wire_guide() {
  rotate([0, 180, 0])
  difference() {
    wire_run_hull = 2.5;
    wire_run_x = x_size - 5;
    wire_run_y = baseplate_thickness*1.5 - 2.5;
    wire_run_bevel_r = 18;
  
    top_plate_thickness = 5;
  
    union() {
      intersection() {
        union() {
          translate([-wire_run_x/2 - wire_run_hull, wire_run_bevel_r/2, -wire_run_y - wire_run_hull]) cube([wire_run_x + 2*wire_run_hull, 30 + wire_run_hull + manifold_slop, wire_run_y + 2*wire_run_hull]);
          translate([-wire_run_x/2 - wire_run_hull, - wire_run_hull, -wire_run_y + wire_run_bevel_r/2]) cube([wire_run_x + 2*wire_run_hull, top_center_hole_radius + 2*wire_run_hull, wire_run_y + 2*top_plate_thickness + 2*manifold_slop]);
          translate([-wire_run_x/2 - wire_run_hull, wire_run_bevel_r/2, -wire_run_y + wire_run_bevel_r/2]) rotate([0, 90, 0]) cylinder(r = wire_run_bevel_r/2 + wire_run_hull, h = wire_run_x+ 2*wire_run_hull, $fn = 4*res);
        }
        union() {
          translate([0, 0, -baseplate_thickness*1.5]) cylinder(r = center_hole_plate_radius, h = baseplate_thickness*1.5, $fn = 4*res);
          translate([0, 0, -manifold_slop]) cylinder(r = top_center_hole_radius, h = melamine_thickness, $fn = 4*res);
          translate([-x_size/2, 10, -baseplate_thickness*1.5]) cube([x_size, 17.6, baseplate_thickness*1.5]);
        }
      }
      translate([0, 0, -top_plate_thickness]) cylinder(r = center_hole_plate_radius, h = top_plate_thickness, $fn = 4*res);
      translate([0, 0, -manifold_slop]) cylinder(r = top_center_hole_radius, h = melamine_thickness, $fn = 4*res);
  
      rotate([0, 0, screw_line_angle]) translate([5.9, 12, -baseplate_thickness*1.5]) cube([center_hole_plate_radius - 2, center_hole_plate_radius - 11.95, baseplate_thickness*1.5]);
      rotate([0, 0, -screw_line_angle]) translate([-center_hole_plate_radius - 0.3, 12, -baseplate_thickness*1.5]) cube([baseplate_thickness, center_hole_plate_radius - 11.95, baseplate_thickness*1.5]);
    }
  
    translate([-wire_run_x/2, wire_run_bevel_r/2, -wire_run_y]) cube([wire_run_x, 30 + manifold_slop, wire_run_y + 2*manifold_slop]);
    translate([-wire_run_x/2, 0, -wire_run_y + wire_run_bevel_r/2]) cube([wire_run_x, top_center_hole_radius, wire_run_y + 2*top_plate_thickness + 2*manifold_slop]);
    translate([-wire_run_x/2, wire_run_bevel_r/2, -wire_run_y + wire_run_bevel_r/2]) rotate([0, 90, 0]) cylinder(r = wire_run_bevel_r/2, h = wire_run_x, $fn = 3*res);
  
    filament_hole_r = 2.5;
    filament_hole_x = 5;
    filament_hole_y = -5;
    translate([filament_hole_x, filament_hole_y, -baseplate_thickness*1.5 - manifold_slop]) cylinder(r = filament_hole_r, h = baseplate_thickness*1.5 + top_plate_thickness + screw_attachment_thickness + 2*manifold_slop, $fn = 2*res);
    translate([-filament_hole_x, filament_hole_y, -baseplate_thickness*1.5 - manifold_slop]) cylinder(r = filament_hole_r, h = baseplate_thickness*1.5 + top_plate_thickness + screw_attachment_thickness + 2*manifold_slop, $fn = 2*res);
  
  }
}

// Optional raft to anchor generated support materials.
%translate([0, 0, -melamine_thickness])
linear_extrude(height = 0.4)
difference() {
  offset(r = 2)
  projection() {
    filament_wire_guide();
  }
  circle(r = top_center_hole_radius + .7, $fn = 4*res);
}

filament_wire_guide();