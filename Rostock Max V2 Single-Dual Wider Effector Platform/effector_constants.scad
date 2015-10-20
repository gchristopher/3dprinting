// effector_constants.scad
// Printable effector platform with a larger center opening for Rostock MAX V2.
// This is a collection of values used to create the objects.
// By Gregg Christopher, 2015
// This file is public domain.
// The Rostock Max V2 is by SeeMeCNC: seemecnc.com

// Manifold assurance.
slop = 0.01;

// M3 arm attachment screw parameters.
arm_screw_r = 1.5;
arm_screw_length = 72;

// Parameters for the arm attachment block.
arm_attachment_width = 37; // It is critical to delta geometery that the arms be identically spaced at the carriage and effector platform! (Or so I have read.)
arm_attachment_height = 10;
arm_attachment_bevel = 1;

// Thickness of the flange for attaching layer fans or other bling.
flange_thickness = 3;

// 6-32 screw hole size. Larger than nominal to counter expected shrinkage of vertically-printed holes.
upright_screw_r = 2.0;

// Parameters for 4-40 screws.
screw_4_40_r = 1.7;
screw_4_40_nut_r = 3.9;
screw_4_40_washer_r = 4.0;
set_screw_offset = 7;

// Fan shroud parameters.
fan_rot = 170;
fan_rot2 = 45;
fan_dy = 18;
fan_screw_attachment_h = 4;

// Parameters relating to the top clamp.
top_clamp_outer_r = 12;
top_clamp_inner_r = 6;
top_clamp_screw_offset = 23;
top_clamp_screw_outer_r = 8;
top_clamp_screw_inner_r = 1.7;

// E3D V6 HotEnd Placement
rotation = 35;
hotend_height = 27.3;
offset = 13;

// Tool distance from effector and spacers.
printed_support_height = hotend_height + 11.7 - arm_attachment_height - 25.4;
spacer_height = hotend_height + 11.7 - arm_attachment_height - printed_support_height;

// Draw a fan case.
module fan_30_mm(holes = 1) {
  color([.5, 1, .5, .8])
  difference() {
    translate([-15, 0, 0]) 
    cube([30, 30, 11]);
    
    if(holes == 1) {
      for(x = [-12, 12]) {
        for(y = [3, 27]) {
          translate([x, y, -slop])
          cylinder(r = 1.5, h = 11 + 2*slop, $fn = 16);
        }
      }
    }
  }
}

