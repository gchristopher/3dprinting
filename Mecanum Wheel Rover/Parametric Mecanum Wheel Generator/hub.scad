// hub.scad
//
// This is a component of a tool to generate Mecanum wheels that meet a variety of
// parameters set in the wheel_parameters.scad file. 
//
// This file generates a hub to hold the mecanum wheels with a keyed drive shaft hole.
// Among the values that can change are the diameter, width, number of spokes, and
// distance from the hub to the base of the motor shaft. 
//
// Don't forget that when printing mecanum wheel hubs, two of the four hubs need to be mirrored!
// Uncomment the mirror() statement near the bottom of this file to mirror the hub. 
//
// By Gregg Christopher, 2015
// This file is public domain. 

include <wheel_parameters.scad>
use <wheel_shape.scad>

wheel_spoke_length = wheel_axle_radius - hub_outer_radius + hub_thickness;

module hub() {
  difference() {
    union() {
      // Wheel holders:
      for(wheel_num = [1: num_wheels]) {
        rotate([0, 0, 360/num_wheels * (wheel_num-1)])
        rotate([0, 45, 0])
        translate([0, wheel_axle_radius, 0]) {
          difference() {
            union() {
              cylinder(r = bearing_outer_diameter/2 + bearing_holder_width, h = bearing_width, center = true, $fn = 30);
              translate([0, -wheel_spoke_length/2, 0])
              cube([bearing_outer_diameter + bearing_holder_width*2, wheel_spoke_length, bearing_width], center=true);
            }
            cylinder(r = bearing_outer_diameter/2, h = bearing_width + 2*slop, center = true, $fn = 30);
          }
          // Preview the bearing and wheels. 
          // Note that the bearing previewed here does not scale with parameters.
          // If you want to see how a different bearing fits, replace this module call. 
          %MR63ZZ_bearing();
          %mecanum_wheel_shape_3d();
          mirror([0, 0, 1])
          %mecanum_wheel_shape_3d();
        }
        
      }
      // Main hub body.
      difference() {
        cylinder(r = hub_outer_radius, h = wheel_attachment_thickness, center = true, $fn = 50);
        cylinder(r = hub_outer_radius - hub_thickness, h = wheel_attachment_thickness + 2*slop, center = true, $fn = 50);
      }
      
      // Motor key
      translate([0, 0, hub_motor_distance - wheel_attachment_thickness/2])
      difference() {
        cylinder(r = motor_attachment_radius, h = motor_shaft_length, $fn = 20);
        translate([0, 0, -slop]) intersection() {
          cylinder(r = motor_shaft_r, h = motor_shaft_length + 2*slop, $fn = 20);
          translate([-motor_shaft_r, -motor_shaft_r, 0]) cube([motor_shaft_r*2, motor_shaft_r*2 - motor_shaft_key_inset, motor_shaft_length + 2.5]);
        }
      }
      
      // Hub spokes
      for(spoke_num = [1: num_spokes]) {
        rotate([0, 0, 80 + 360/num_spokes * (spoke_num-1)]) {
          translate([0, 0, -wheel_attachment_thickness/2])
          rotate([90, 0, 0])
          translate([0, 0, -hub_spoke_thickness/2])
          linear_extrude(height = hub_spoke_thickness)
          polygon([[motor_shaft_r + slop, hub_motor_distance],
                   [motor_shaft_r + slop, hub_motor_distance + motor_shaft_length],
                   [hub_outer_radius - hub_thickness + slop, wheel_attachment_thickness],
                   [hub_outer_radius - hub_thickness + slop, 0]]);
        }
      }
    }
    
    translate([0, 0, -wheel_attachment_thickness/2 - slop])
    cylinder(r = 2*wheel_axle_radius, h = hub_printing_trim);
  }

  // Report the slop as a sanity check for printing.   
  spoke_slope = atan((hub_outer_radius - hub_thickness - motor_shaft_r)/(hub_motor_distance));
  echo(str("Spoke overhang slope is: ", spoke_slope));
}

// Module to preview a small gearmotor.
// This is included as a demonstration for a particular motor size.
// It does not scale with other parameters. 
module motor_preview() {
  color([0.7, 0.7, 0.7, 0.7])
  %intersection() {
    cylinder(r = 1.5, h = 9, $fn = 10);
    translate([-1.5, -1.5, 0]) cube([3, 2.5, 9]);
  }

  color([0.7, 0.7, 0.2, 0.7])
  translate([-6, -5, -9.5]) %cube([12, 10, 9.5]);
    
  color([0.7, 0.7, 0.7, 0.7])
  translate([0, 0, -24.5])
  %intersection() {
    cylinder(r = 6, h = 15, $fn = 20);
    translate([-6, -5, 0]) cube([12, 10, 15]);
  }
}

// Preview gearmotor
translate([0,0, hub_motor_distance - wheel_attachment_thickness/2 + motor_shaft_length])
rotate([0, 180, 0])
motor_preview();

// Preview virtual wheel shape
/*  
%rotate_extrude($fn = 50)
translate([wheel_axle_radius, 0, 0])
wheel_shape_2d();
*/
  
// Hub needs to be printed mirrored for 2 of the wheels.
//mirror([1, 0, 0])
hub();

