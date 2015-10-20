// extruder_holders.scad
// Angled EzStruder Holders for Rostock MAX V2.
// By Gregg Christopher, 2015
// This file is GPL v3. (I think, from inclusion of code from the Prusa i3)
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

// Some of the shapes presented here are derivatives of the from the SeeMeCNC github: https://github.com/seemecnc
// License information was not found in that github. 
// Files refererenced and distributed with this holder design may be subject to additional copyright 
// restrictions, most likely noncommercial use. 
// Please contact seemecnc.com for any possible commercial use of these files.  

// Includes some relatively trivial code from the Prusa i3 repository: https://github.com/josefprusa/Prusa3

include <extruder_constants.scad>
use <nut_clamp.scad>

// Set to nonzeo to add Micky-Mouse-style pads to print corners to help prevent lifting.
add_corner_pads = 0;

module stupid_corner_pad() {
  if(add_corner_pads) {
    cylinder(r = 10, h = 0.6, $fn = 30);
  }
}

// Cutout for screw hole and clearance for screw head and nut/
module screw_bracket_cutout() {
  translate([0, 0, bracket_wall_thickness + nut_clearance_r]) rotate([-90, 0, 0]) translate([0, 0, -extra_screw_depth]) cylinder(r = screw_hole_r, h = bracket_wall_thickness + extra_screw_depth + 2*manifold_slop, $fn = res);
  translate([-nut_clearance_r + manifold_slop, bracket_wall_thickness + manifold_slop, bracket_wall_thickness + manifold_slop]) cube([2*nut_clearance_r - 2*manifold_slop, 2*bracket_length, 2*nut_clearance_r + bracket_wall_thickness - manifold_slop]);
}

// Extra material to brace the section where the two holder halves are screwed together. 
module screw_bracket() {  
  difference() {
    union() {
      translate([-bracket_wall_thickness - nut_clearance_r, 0, 0]) cube([bracket_wall_thickness * 2 + nut_clearance_r*2, bracket_wall_thickness, bracket_wall_thickness + 2*nut_clearance_r]);

      intersection() {
        translate([-bracket_wall_thickness - nut_clearance_r, bracket_wall_thickness - manifold_slop, bracket_wall_thickness - manifold_slop]) cube([bracket_wall_thickness, bracket_length, 2*nut_clearance_r]);
        translate([-bracket_wall_thickness - nut_clearance_r - manifold_slop, bracket_wall_thickness, 0]) scale([1, bracket_length / (2*nut_clearance_r + bracket_wall_thickness), 1]) rotate([0, 90, 0]) cylinder(r = 2*nut_clearance_r + bracket_wall_thickness, h = bracket_wall_thickness + 2*manifold_slop, $fn = 4*res);
      }
      
      intersection() {
        translate([nut_clearance_r, bracket_wall_thickness - manifold_slop, bracket_wall_thickness - manifold_slop]) cube([bracket_wall_thickness, bracket_length, 2*nut_clearance_r]);
        translate([nut_clearance_r - manifold_slop, bracket_wall_thickness, 0]) scale([1, bracket_length / (2*nut_clearance_r + bracket_wall_thickness), 1]) rotate([0, 90, 0]) cylinder(r = 2*nut_clearance_r + bracket_wall_thickness, h = bracket_wall_thickness + 2*manifold_slop, $fn = 4*res);
      }
    }

    screw_bracket_cutout();
  }
}

// Extra serious looking.
module super_professional_eyes() {
  translate([-15, 250]) scale([25.4, 25.4]) import("screwballcnc.dxf", convexity = 10);  
}

// Side structure holding EzStruder in place. Reinforces the otherwise minimal holder shape. 
module motor_side_brace() {
  // Blocks to sqare off the side of the lifters to connect to the support brace.
  translate([motor_holder_size/2 - lifter_radius, -motor_holder_size/2 - lifter_bottom_distance, 0]) cube([lifter_radius, lifter_radius, ezstruder_mount_height]);
  translate([motor_holder_size/2 - lifter_radius, -motor_x_size/2 - lifter_radius, 0]) cube([lifter_radius, lifter_radius, ezstruder_mount_height]);
  // Beveled end
  translate([motor_holder_size/2, -motor_holder_size/2 - lifter_bottom_distance + motor_side_brace_width, 0]) cylinder(r = motor_side_brace_width, h = ezstruder_mount_height, $fn = 10*res);
  translate([motor_holder_size/2, -motor_holder_size/2 - lifter_bottom_distance + motor_side_brace_width, 0]) cube([motor_side_brace_width, motor_holder_size/2 + lifter_bottom_distance - motor_side_brace_width - motor_x_size/2, ezstruder_mount_height]);
  
  translate([motor_holder_size/2, -motor_x_size/2, ezstruder_mount_height*3/4]) 
  scale([1, brace_bevel_scale, 1]) 
  rotate([0, 90, 0]) cylinder(r = ezstruder_mount_height/4, h = motor_side_brace_width, $fn = 10*res);
  
  translate([motor_holder_size/2, -motor_x_size/2, 0]) 
  difference() {
    cube([motor_side_brace_width, motor_brace_length, ezstruder_mount_height*3/4]);

    translate([-manifold_slop, motor_x_size/2 + motor_holder_size/2, ezstruder_mount_height*3/4])
    scale([1, (motor_brace_length - ezstruder_mount_height/4*brace_bevel_scale)/(ezstruder_mount_height*3/4 - baseplate_thickness), 1]) 
    rotate([0, 90, 0]) cylinder(r = ezstruder_mount_height*3/4 - baseplate_thickness, h = motor_side_brace_width + 2*manifold_slop, $fn = 10*res);
  }  
}

// Nema17 preview shape copied from the prusa i3 code: https://github.com/josefprusa/Prusa3
module nema17(places=[1,1,1,1], size=15.5, h=10, holes=false, shadow=false, $fn=24){
  for (i=[0:3]) {
    if (places[i] == 1) {
      rotate([0, 0, 90*i]) translate([size, size, 0]) {
        if (holes) {
          rotate([0, 0, -90*i])  translate([0,0,-10]) screw(r=1.7, slant=false, head_drop=13, $fn=$fn, h=h+12);
        } else {
          rotate([0, 0, -90*i]) cylinder(h=h, r=5.5, $fn=$fn);
        }
      }
    }
  }
  if (shadow != false) {
    %translate ([0, 0, shadow+21+3]) cube([42,42,42], center = true);
    // Preview extra clearance for heat sink and cooling fan.
    color([0.9, 0.5, 0.5, 0.5])
    %translate ([0, 0, shadow+21+3+33.5]) cube([42,42,25], center = true);

    //flange
    %translate ([0, 0, shadow+21+3-21-1]) cylinder(r=11,h=2, center = true, $fn=20);
    //shaft
    %translate ([0, 0, shadow+21+3-21-7]) cylinder(r=2.5,h=14, center = true);
  }
}


// Complete structure to hold a single EZStruder
module ezstruder_mount() {
  difference() {
    union() {
      // Lifter section copied from V4 sheet ezstruder bracket pieces.
      translate([0, 0, 0]) linear_extrude(height = ezstruder_mount_height) translate([-lifter_x_pos, -lifter_y_pos]) scale([25.4, 25.4]) import("ezstruder_lifter.dxf", convexity = 20);

      // Base plate to brace the motor. Not sure how structural this really is.
      translate([-motor_holder_size/2, -motor_holder_size/2, 0]) cube([motor_holder_size, motor_holder_size, baseplate_thickness]);

      // Support brace on either side of the ezstruder bracket to add rigidity and maybe look cool. 
      motor_side_brace();
      mirror([1, 0, 0]) motor_side_brace();
    }
    
    translate([0, 0, -manifold_slop]) linear_extrude(height = baseplate_thickness + 2*manifold_slop) translate([-motor_cutout_x_pos, -motor_cutout_y_pos]) scale([25.4, 25.4]) import("motor_screw_cutout.dxf", convexity = 10);

    translate([-15.5, -36.3, -manifold_slop])
    cylinder(r = screw_hole_r*1.1, h = ezstruder_mount_height + 2*manifold_slop, $fn = 12);

    translate([15.5, -36.3, -manifold_slop])
    cylinder(r = screw_hole_r*1.1, h = ezstruder_mount_height + 2*manifold_slop, $fn = 12);
  }
  
  // Preview size and position 
  translate([0, 0, ezstruder_mount_height + 10]) mirror([0, 0, 1]) nema17([0, 0, 0, 0], thickness=10, shadow=7);
  
  filament_model_length = 54;
  %translate([-6.3, 0, 31.7]) rotate([90, 0, 0]) translate([0, 0, -filament_model_length/2]) cylinder(r = 1.75/2, h = filament_model_length, $fn = 10);
  
  // Preview EZStruder position on mount
  %color([0, 0, 0.6, 0.8]) translate([21, -3.1, ezstruder_mount_height]) rotate([0, 0, 180]) {
    import("70784 HEM PART A.STL", convexity = 20);
    import("70786 HEM PART B.STL", convexity = 20);
  }
}


filament_path_arc = 45; // degrees angle for planned filament path leading to extruder. Also the angle for the bowden tube.
filament_path_radius = 130; // radius of path taken by filament to extruder. Not chosen for a precise value, just used to guesstimate a good position for the extruder. 

// Variables to calculate symmetrical filament path
filament_sync_x = 55;
filament_sync_y = 83;
filament_sync_z = 26;

left_x = filament_sync_x - 49.7;
left_y = filament_sync_y + 30.9;

right_x = -12.2 - filament_sync_x;
right_y = filament_sync_y - 30.5;

// Preview symmetrical position of filament before it enters the EZStruder. 
//for(ii = [-filament_sync_x, filament_sync_x]) translate([ii, filament_sync_y, filament_sync_z]) color([1, 0, 0, 0.5]) %sphere(r = 1.75/2);

module left_ezstruder_mount() {
  difference() {
    union() {
      // EZStuder Holder
      translate([left_x, left_y, 0]) rotate([0, 0, -filament_path_arc])
      translate([motor_holder_size/2 + motor_side_brace_width, motor_holder_size/2, -baseplate_thickness/2]) rotate([0, 0, 180]) ezstruder_mount();

      // Structural pieces connecting the screw attachment block to the extruder holder.
      
      // Block just below the screw attachment section
      translate([0, 0, -baseplate_thickness/2]) cube([screw2_dist + screw1_dist - center_hole_plate_radius, 75, baseplate_thickness]);
      // Fill in a small triangular section missed by the above block
      translate([8, 72 - manifold_slop, -baseplate_thickness/2]) cube([37, 8, baseplate_thickness]);

      // Center section that joins to the other extruder holder
      translate([-center_hole_plate_radius/2 - 5, baseplate_thickness*1.5, -baseplate_thickness/2]) cube([15 + center_hole_plate_radius/2, 101.5-5.5, baseplate_thickness]);

      // Fill in the triangle between the other two sections and the extruder holder
      translate([-7, 96, -baseplate_thickness/2]) 
      rotate([0, 0, -filament_path_arc]) cube([45, 23, baseplate_thickness]);
      
      // Screw brackets  
      translate([-center_hole_plate_radius/2, screw_bracket_1_pos, 0])
      difference() { 
        rotate([0, screw_line_angle - 90, 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, -90]) screw_bracket();
        translate([0, -bracket_wall_thickness - nut_clearance_r - manifold_slop, -bracket_wall_thickness -baseplate_thickness/2 - manifold_slop]) cube([10, bracket_wall_thickness * 2 + nut_clearance_r*2 + manifold_slop*2, bracket_wall_thickness]);
      }
      translate([-center_hole_plate_radius/2, screw_bracket_2_pos, 0]) 
      difference() { 
        rotate([0, screw_line_angle - 90, 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, -90]) screw_bracket();
        translate([0, -bracket_wall_thickness - nut_clearance_r - manifold_slop, -bracket_wall_thickness -baseplate_thickness/2 - manifold_slop]) cube([10, bracket_wall_thickness * 2 + nut_clearance_r*2 + manifold_slop*2, bracket_wall_thickness]);
      }
    }

    // Cutouts for screw attachments to the top plate
    for(pos = [screw1_dist, screw2_dist]) {
      translate([pos - center_hole_plate_radius/2, -manifold_slop, 0]) rotate([-90, 0, 0]) cylinder(r = screw_hole_r, h = 2*screw_attachment_thickness + nut_gap_thickness + 2*manifold_slop + 5, $fn = 2*res);
      translate([pos - center_hole_plate_radius/2 - nut_gap_width/2, screw_attachment_thickness, -baseplate_thickness/2 - manifold_slop]) cube([nut_gap_width, nut_gap_thickness, baseplate_thickness + 2*manifold_slop]);
    }
    
    // Angled cutout so the two extruder mounts sit flush.
    translate([-center_hole_plate_radius/2 - manifold_slop, 0, 0])
    rotate([0, 90+screw_line_angle, 0])
    translate([0, 0, -2*baseplate_thickness])
    cube([motor_holder_size, 10*motor_holder_size, 4*baseplate_thickness + 2*manifold_slop]);

    // Angled cutout for the top section to make more room for wires
    rotate([0, 90+screw_line_angle, 0])
    translate([0, -manifold_slop, -2*baseplate_thickness])
    cube([motor_holder_size, baseplate_thickness*1.5, 4*baseplate_thickness + 2*manifold_slop]);

    // Screw bracket cutouts  
    translate([-center_hole_plate_radius/2, screw_bracket_1_pos, 0]) rotate([0, screw_line_angle - 90, 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, -90]) screw_bracket_cutout();
    translate([-center_hole_plate_radius/2, screw_bracket_2_pos, 0]) rotate([0, screw_line_angle - 90, 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, -90]) screw_bracket_cutout();

    // Rostock printers should have eyeballs cut into them. These are designed to inspire confidence in the quality of the engineering.
    translate([25, 60, -baseplate_thickness/2 - manifold_slop]) rotate([0, 0, 160])  
    linear_extrude(height = baseplate_thickness + 2*manifold_slop) super_professional_eyes();

    // Purely cosmetic outer cutout to make the outline curvy
    translate([70.1, 43.52, -baseplate_thickness/2 - manifold_slop])
    scale([1, 2, 1])
    cylinder(h = baseplate_thickness + 2*manifold_slop, r = 13.5, $fn = 40);
  }

  // Optional pads to help hold the corners down while printing
  translate([65, -3, -baseplate_thickness/2]) stupid_corner_pad();
  translate([5, -3, -baseplate_thickness/2]) stupid_corner_pad();
  translate([-8, 15, -baseplate_thickness/2]) stupid_corner_pad();
  translate([-8, 115, -baseplate_thickness/2]) stupid_corner_pad();
  translate([108, 110, -baseplate_thickness/2]) stupid_corner_pad();
  translate([55, 165, -baseplate_thickness/2]) stupid_corner_pad();
}

module right_ezstruder_mount() {
  difference() {
    union() {
      // EZStuder Holder
      translate([right_x, right_y, 0]) rotate([0, 0, filament_path_arc])
      translate([motor_holder_size/2 + motor_side_brace_width, motor_holder_size/2, -baseplate_thickness/2]) rotate([0, 0, 180]) {
        ezstruder_mount();
      }
      
      // Structural pieces connecting the screw attachment block to the extruder holder.
      
      // Block just below the screw attachment section
      translate([-(screw2_dist + screw1_dist - center_hole_plate_radius), 0, -baseplate_thickness/2]) 
      cube([screw2_dist + screw1_dist - center_hole_plate_radius, 70, baseplate_thickness]);

      // Center section that joins to the other extruder holder
      translate([-25, baseplate_thickness*1.5, -baseplate_thickness/2]) cube([30 + center_hole_plate_radius/2, 101.5-5.5, baseplate_thickness]);

      // Fill in the triangle between the other two sections and the extruder holder
      translate([-32, 51, -baseplate_thickness/2]) 
      rotate([0, 0, filament_path_arc]) cube([52, 27, baseplate_thickness]);
        
      // Fill in a gap on the upper edge of the ezstruder holder
      translate([-63.7, 49, -baseplate_thickness/2]) 
      rotate([0, 0, filament_path_arc]) cube([10, 10, baseplate_thickness]);
 
      // Screw brackets  
      translate([center_hole_plate_radius/2, screw_bracket_1_pos, 0]) 
      difference() { 
        rotate([0, 90 - screw_line_angle , 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, 90]) screw_bracket();
        translate([-10, -bracket_wall_thickness - nut_clearance_r - manifold_slop, -bracket_wall_thickness -baseplate_thickness/2 - manifold_slop]) cube([10, bracket_wall_thickness * 2 + nut_clearance_r*2 + manifold_slop*2, bracket_wall_thickness]);
      }
      translate([center_hole_plate_radius/2, screw_bracket_2_pos, 0]) 
      difference() { 
        rotate([0, 90 - screw_line_angle , 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, 90]) screw_bracket();
        translate([-10, -bracket_wall_thickness - nut_clearance_r - manifold_slop, -bracket_wall_thickness -baseplate_thickness/2 - manifold_slop]) cube([10, bracket_wall_thickness * 2 + nut_clearance_r*2 + manifold_slop*2, bracket_wall_thickness]);
      }
   }

    // Cutouts for screw attachments to the top plate
    for(pos = [-screw1_dist, -screw2_dist]) {
      translate([pos + center_hole_plate_radius/2, -manifold_slop, 0]) rotate([-90, 0, 0]) cylinder(r = screw_hole_r, h = 2*screw_attachment_thickness + nut_gap_thickness + 2*manifold_slop + 15, $fn = 2*res);
      translate([pos + center_hole_plate_radius/2 - nut_gap_width/2, screw_attachment_thickness, -baseplate_thickness/2 - manifold_slop]) cube([nut_gap_width, nut_gap_thickness, baseplate_thickness + 2*manifold_slop]);
    }

    // Angled cutout so the two extruder mounts sit flush.
    translate([center_hole_plate_radius/2 - manifold_slop, 0, 0])
    rotate([0, 90-screw_line_angle, 0])
    translate([0, 0, -2*baseplate_thickness])
      cube([motor_holder_size, 10*motor_holder_size, 6*baseplate_thickness + 2*manifold_slop]);

    // Angled cutout for the top section to make more room for wires
    rotate([0, 90-screw_line_angle, 0])
    translate([0, -manifold_slop, -2*baseplate_thickness])
      cube([motor_holder_size, baseplate_thickness*1.5, 4*baseplate_thickness + 2*manifold_slop]);

    // Rostock printers should have eyeballs cut into them. These are designed to inspire confidence in the quality of the engineering.
    translate([-30, 55, -baseplate_thickness/2 - manifold_slop]) rotate([0, 0, 193])  
    linear_extrude(height = baseplate_thickness + 2*manifold_slop) super_professional_eyes();

    // Screw bracket cutouts  
    translate([center_hole_plate_radius/2, screw_bracket_1_pos, 0]) rotate([0, 90 - screw_line_angle , 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, 90]) screw_bracket_cutout();
    translate([center_hole_plate_radius/2, screw_bracket_2_pos, 0]) rotate([0, 90 - screw_line_angle , 0]) translate([0, 0, -baseplate_thickness/2 - bracket_depth_offset]) rotate([0, 0, 90]) screw_bracket_cutout();

    // Purely cosmetic outer cutout to make the outline curvy
    translate([-65.9, 34.5, -baseplate_thickness/2 - manifold_slop])
    scale([1, 2.6, 1])
    cylinder(h = baseplate_thickness + 2*manifold_slop, r = 6, $fn = 40);
  }
  
  // Optional pads to help hold the corners down while printing
  translate([-65, -3, -baseplate_thickness/2]) stupid_corner_pad();
  translate([0, -3, -baseplate_thickness/2]) stupid_corner_pad();
  translate([8, 15, -baseplate_thickness/2]) stupid_corner_pad();
  translate([8, 115, -baseplate_thickness/2]) stupid_corner_pad();
  translate([-118, 100, -baseplate_thickness/2]) stupid_corner_pad();
  translate([-65, 155, -baseplate_thickness/2]) stupid_corner_pad();
}

// Render left EZStruder mount
translate([center_hole_plate_radius/2 + 10, 0, 0]) {
  left_ezstruder_mount();
  %translate([screw1_dist - center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) mirror([0, 1, 0]) nut_clamp();  
  %translate([screw2_dist - center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) nut_clamp();  
}

// Render right EZStruder mount
translate([-center_hole_plate_radius/2 - 10, 0, 0]) {
  right_ezstruder_mount();
  %translate([-screw1_dist + center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) mirror([0, 1, 0]) nut_clamp();  
  %translate([-screw2_dist + center_hole_plate_radius/2, 0, 0 ]) rotate([-90, 0, 0]) nut_clamp();  
}

