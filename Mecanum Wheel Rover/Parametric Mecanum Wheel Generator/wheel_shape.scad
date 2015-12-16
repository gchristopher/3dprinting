// wheel_shape.scad
//
// This is a component of a tool to generate Mecanum wheels that meet a variety of
// parameters set in the wheel_parameters.scad file. 
//
// This file generates the shape of a single wheel spoke roller piece (1/2 of a roller) for
// a mecanum wheel. It attempts to shape the spoke to conform to a "virtual wheel" shape
// that is extruded in a circle around the shaft of the wheel, so that when the spokes rotate
// around their individual shafts while the wheel is spinning, the effective possible 
// contact surface with the ground is very close to that virtual wheel shape. 
//
// This is accomplished by taking the intersection of a cylinder defining the possible
// volume of the spoke, and intersecting it with the virtual wheel shape. A slice of
// that intersection is chosen heuristically (i.e. I hardcoded some math/guesswork),
// and that slice is then rotationally extruded to make the spoke shape. 
//
// A few other geometric features, like a bearing spacer and captive nut holder for]
// using a screw as an axle, are then added/cut into the spoke. 
//
// Much more sophisticated approaches are possible, but surprisingly, this simplistic
// approach produced great results for the configurations I tried.
//
// Because of the large number of parameters and the relatively tight constraints of
// mecanum wheels, it takes some tuning to get something that's mechanically workable.
// However, it's easy to change values and watch the entire assembly preview change in
// hub.scad, so the process is not too painful!
//
// By Gregg Christopher, 2015
// This file is public domain. 

include <wheel_parameters.scad>

// Create a 2D shape that will define the "virtual wheel" to which the rollers will
// attempt to conform. Try different shapes to see weird results!
// y = radial dimension
module wheel_shape_2d() {
  // As an example, uncomment the next two lines to test making rollers with
  // very rounded ends to make a less square wheel cross-section. 
  // Warning! This particular shape increases the poly count, and SCAD might
  // be prohibitively slow.
  //offset(r = 4)
  //offset(r = -4)
  square([contact_shape_height, contact_shape_thickness], center = true);
}

// Calculate intersection points to determine an angle to take a slice of the
// wheel profile. This is not remotely an optimal or particularly elegant solution,
// but it worked well for the wheels I wanted to make. 
x1 = cos(wheel_angle) * contact_shape_height/2;
y1 = sin(wheel_angle) * contact_shape_height/2;

y2 = y1 + contact_shape_thickness/2;
x2 = tan(wheel_angle) * y2;

cross_section_angle = atan(contact_shape_thickness/2 / (x1 + x2));

echo(x1);
echo(x2);
echo(y1);
echo(y2);
echo(cross_section_angle);

module mecanum_wheel_shape_3d() {
  difference() {
    // Create the base spoke shape
    rotate_extrude()
    rotate([180, 0, 90])
    intersection() {
      square([100, 100]);
      // Take a slice of the intersection of the virtual wheel and allowable spoke cylinder. 
      projection(cut = true) 
      rotate([0, 45, 0])
      intersection() {
        translate([0, -wheel_axle_radius, 0])
        rotate_extrude($fn = 100)
        translate([wheel_axle_radius, 0, 0])
        wheel_shape_2d();
        
        rotate([0, wheel_angle, 0])
        cylinder(r = contact_shape_height/2, h = 50, center = true, $fn = 30);
      }
    }
    translate([0, 0, -slop]) cylinder(r = 20, h = bearing_width/2 + 2*slop); // Remove material for hub
    translate([0, 0, bearing_width/2]) cylinder(r = m3_screw_r, h = m3_nut_holder_thickness + slop, $fn = 20); // Screw hole
    translate([0, 0, bearing_width/2 + m3_nut_holder_thickness]) cylinder(r = m3_nut_radius, h = m3_nut_holder_depth + slop, $fn = 6); // Nut holder hole
    // Cutout for screw and nut at the end of the roller. 
    translate([0, 0, bearing_width/2 + m3_nut_holder_thickness + m3_nut_holder_depth])
    intersection() {
       remaining_height = x2 - bearing_width/2 - m3_nut_holder_thickness - m3_nut_holder_depth;
       cylinder(r1 = m3_nut_radius, r2 = m3_nut_radius + remaining_height/4, h = remaining_height, $fn = 6);
       cylinder(r = m3_entrance_clearance_r, h = remaining_height, $fn = 30);
    }
    // Cut out some extra clearance around the bearing spacer.
    // This cavity will collect fluff and other junk forever. It's great. 
    translate([0, 0, bearing_width/2 - slop])
    difference() {
      cylinder(r1 = contact_shape_height/2 - 3.5 + bearing_inner_contact_max_width, r2 = contact_shape_height/2 - 3.5, h = bearing_inner_contact_height - 2*slop, $fn = 20); // Screw hole
      translate([0, 0, -slop]) cylinder(r1 = m3_screw_r + bearing_inner_contact_max_width, r2 = m3_screw_r + 2*bearing_inner_contact_max_width - bearing_inner_contact_min_width, h = bearing_inner_contact_height, $fn = 20); // Screw hole
    }
  }
  // Bearing spacer. Larger designs might want to omit this and go with a manufactured spacer matching the selected bearing. 
  translate([0, 0, bearing_width/2 - bearing_inner_contact_height + slop])
  difference() {
    cylinder(r1 = m3_screw_r + bearing_inner_contact_min_width, r2 = m3_screw_r + bearing_inner_contact_max_width, h = bearing_inner_contact_height, $fn = 20);
    translate([0, 0, -slop]) cylinder(r = m3_screw_r, h = bearing_inner_contact_height + 2*slop, $fn = 20);
  }
}

// Position the roller spoke half for printing
rotate([0, 180, 0])
translate([0, 0, -x2 + 0.48])
mecanum_wheel_shape_3d();

