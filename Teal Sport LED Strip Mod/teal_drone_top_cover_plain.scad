// teal_drone_top_cover_plain.scad
//
// OpenSCAD implementation of a top cover for the Teal Sport drone that is very
// close in size and shape to that provided by the manufacturer at:
// https://www.thingiverse.com/thing:2597372
//
// This model is intended to serve as a base for further development, while 
// allowing easier and precise changes because it starts from code and a .dxf
// outline instead of a 3d model. 
//
// By Gregg Christopher, 2017
// This file is released under the Creative Commons - Attribution license. 
// http://creativecommons.org/licenses/by/3.0/

// Module summary:
// 
// case_outer_volume() : Exterior dimensions of the plain case.
// case_inner_volume() : Cutout for the interior space of the plain case.
// case_clip_fittings() : Mounting brackets and supports for mating to the drone body.
// case_mounting_clip_holes() : Cutout for the holes in the mounting bracket.
// teal_cover_plain() : A complete plain case assembled from those four volumes.

// Infinitesimal value for ensuring manifold shapes and other special uses. 
slop = 0.01;

include <teal_drone_top_cover_plain_parameters.scad>

// Use a few spheroids to get close to the shape of the bulging ends
// of the plain Teal Drone top cover. This volume can be tweaked to
// make more internal space if needed. 
module approximate_end_bulge() {
  // These were not calculated. They were adjusted by hand until it looked nice.
  hull() {
    color([0, 0, 1, 0.6])
    translate([0, -46.5, mounting_bracket_lip_h - 9])
    scale([.78, .415, 0.25])
    sphere(r = 82, $fn = 120);

    color([0, 0, 1, 0.6])
    translate([0, -41, mounting_bracket_lip_h - 9])
    scale([.795, .428, 0.28])
    sphere(r = 80, $fn = 120);
    
    color([0, 1, 0, 0.6])
    translate([0, -36, mounting_bracket_lip_h - 9])
    scale([.77, .51, 0.29])
    sphere(r = 80, $fn = 120);
  }
}

// The Teal Sport drone has a stylishly slim waistline. Use a toroid
// to trim our bulbous cover shape down to one close to matching.
// The actual contour of the toroid is taken from the drone lip shape.
module toroidal_cutout() {
  // This sequence of geometric operations is NOT the result of any fancy
  // analysis. It just moves the shape to roughly the right place and 
  // scales it to be close to fitting. 
  translate([0, 0, -8])
  scale([0.96, 1, 0.35])
  rotate([90, 0, 0])
  rotate_extrude($fn = 80)
  translate([8, 0])
  projection()
  linear_extrude(height = slop)
  difference() {
    translate([0, -35])
    square([80, 70]);
    import("teal_top_cover_outline.dxf");
  }
}

module case_outer_volume() {
  // Exact case lip, from a projection of the plain Teal Sport drone cover: 
  // https://www.thingiverse.com/thing:2597372
  linear_extrude(height = mounting_bracket_lip_h)
  import("teal_top_cover_outline.dxf");

  // Hull together bulges at either end, then chop the toroidal volume
  // out to make the slimmer center. 
  intersection() {
    difference() {
      hull() {
        approximate_end_bulge();
        mirror([0, 1, 0])
        approximate_end_bulge();
      }
      toroidal_cutout();
    }  
    linear_extrude(height = 50)
    import("teal_top_cover_outline.dxf");
  }
}

module case_inner_volume() {
  // Exact thickness bottom lip guarantees correct mating with the drone.
  translate([0, 0, -slop])
  linear_extrude(height = mounting_bracket_lip_h + 2*slop)
  offset(r = -mounting_bracket_outer_thickness)
  import("teal_top_cover_outline.dxf");
  
  // Since the case is mostly horizontal, the rest of the inner volume is defined by dropping 
  // the outer volume by case_top_thickness mm, then subtracting some material from the rim
  // so that the edge forms a nice printable shape of the desired bracket height. (mounting_bracket_h)
  intersection() {
    difference() {
      translate([0, 0, -case_top_thickness])
      hull() {
        approximate_end_bulge();
        mirror([0, 1, 0])
        approximate_end_bulge();
      }
        
      translate([0, 0, -case_top_thickness])
      toroidal_cutout();
      
      difference() {
        translate([0, 0, mounting_bracket_lip_h])
        linear_extrude(height = mounting_bracket_h - mounting_bracket_lip_h + 10)
        import("teal_top_cover_outline.dxf");
        
        // Remove the edges of the interior area to limit overhang angles.
        translate([0, 0, mounting_bracket_lip_h - slop])
        linear_extrude(height = mounting_bracket_h - mounting_bracket_lip_h + 2*slop, scale = mounting_bracket_slope_scale)
        offset(r = -mounting_bracket_outer_thickness)
        import("teal_top_cover_outline.dxf");      

        // Extend the top of the limited area straught upward to keep the profile concave.
        translate([0, 0, mounting_bracket_h - slop])
        linear_extrude(height = 10)
        scale([mounting_bracket_slope_scale, mounting_bracket_slope_scale])
        offset(r = -mounting_bracket_outer_thickness)
        import("teal_top_cover_outline.dxf");      

      }
    }  
    linear_extrude(height = 50)
    offset(r = -mounting_bracket_outer_thickness)
    import("teal_top_cover_outline.dxf");
  }  
}

module case_mounting_clip_holes() {
  for(pos = mounting_clip_hole_positions) {
    translate([pos[0], pos[1], -slop])
    cylinder(r = mounting_clip_inner_r, h = mounting_bracket_h + 2*slop, $fn = 20);
  }
}

module case_clip_fittings() {
  difference() {
    union() {
      // Mounting clip outer sections
      for(pos = mounting_clip_hole_positions) {
        translate([pos[0], pos[1], 0])
        cylinder(r = mounting_clip_outer_r, h = mounting_bracket_h, $fn = 20);
      }

      // Brace sections
      intersection() {
        case_outer_volume();
        for(pos = mounting_clip_hole_positions) {
          translate([pos[0], pos[1], -slop])
          for(rot = [atan2(-pos[0], pos[1]/2) + 30, atan2(-pos[0], pos[1]/2) - 30])
          rotate([0, 0, rot])
          translate([-mounting_bracket_outer_thickness/4, 0, 0])
          cube([mounting_bracket_outer_thickness/2, 20, mounting_bracket_h]);
        }
      }
    }
    
    case_mounting_clip_holes();
  }
}

module teal_cover_plain() {
  difference() {
    case_outer_volume();
    case_inner_volume();
    case_mounting_clip_holes();
  }
  difference() {
    case_clip_fittings();
    case_mounting_clip_holes();  
  }
}

render() // All those hulls and differences are slow. Pre-render to make life easier. 
teal_cover_plain();

// Compare the generated cover with the provided one?
// TealTopCoverBlank1.STL can be found at: https://www.thingiverse.com/thing:2597372

// %translate([-60+0.35, 80+2.1, -10+0.5])
// rotate([90, 0, 0])
// import("TealTopCoverBlank1.STL", convexity = 10);

// Preview the rotor keep-out area?

for(x = [101, -101]) {
  for(y = [83, -83]) {
    // Prop keep-out area estimates:
    %color([0.3, 0.3, 0.7, 0.4])
    translate([x, y, 8.25])
    cylinder(r = 127/2, h = 10);
  }
}
