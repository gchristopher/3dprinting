// wheel_parameters.scad
//
// This is a component of a tool to generate Mecanum wheels that meet a variety of
// parameters set in the wheel_parameters.scad file. 
//
// This file contains all the driving parameters for generating the wheel rollers and hub. 
//
// Because of the large number of parameters and the relatively tight constraints of
// mecanum wheels, it takes some tuning to get something that's mechanically workable.
// However, it's easy to change values and watch the entire assembly preview change in
// hub.scad, so the process is not too painful!
//
// By Gregg Christopher, 2015
// This file is public domain. 

// Small "epsilon" value for ensuring manifold geometry. "slop" is easier to type than "manifold."
slop = 0.01;

/* [Main Dimensions] */
// Distance from the hub axle center to the center of the axles of each roller.
wheel_axle_radius = 26;
// Angle of rollers relative to the hub axle. Change this and they're probably not mecanum wheels anymore. 
wheel_angle = 45;
// Number of roller spokes on the hub. 
num_wheels = 7;

// This example is for MR63ZZ bearings, because they are cheap to buy and mecanum wheels use a lot of them.
/* [Bearing Dimensions] */
// Inner diameter of bearing. 
bearing_inner_diameter = 3;
// Outer diameter of bearing, plus extra clearance for printing. Should be a snug fit.
bearing_outer_diameter = 6 + 0.2;
// Width of bearing. 
bearing_width = 2.5;
// Thickness of printed part holding the bearing in place. 
bearing_holder_width = 3;

/* [Bearing Spacer Dimensions] */
// Width of the bearing spacer at the point where it contacts the bearing.
bearing_inner_contact_min_width = 0.4;
// Width of the spacer when at the roller.
bearing_inner_contact_max_width = 1.2;
// Height of the spacer (distance from the bearing to the main body of he roller.
bearing_inner_contact_height = 1.0;

/* [Wheel Hub Dimensions] */
// Outer radius of the main hub holding the roller wheel spokes. Needs to be small enough to allow clearance for the rollers. 
hub_outer_radius = 15;
// Thickness of the hub wheel. 
hub_thickness = 3;

// Amount to trim off outer edge of hub to make it more printable.
hub_printing_trim = 1; 

// Distance from edge of hub to motor. (Clearance for the rollers to spin without hitting the motor or frame.)
hub_motor_distance = 12; 

/* [Hub Inner Spoke Dimensions] */
// Thickness of the angled spoke from the inner hub to the motor shaft holder.
hub_spoke_thickness = 2.5;
// Number of inner spokes. Does not have to be the same as the number of wheel rollers. 
num_spokes = 7;

/* [Motor Shaft Dimensions] */
// Radius of the solid piece holding the motor shaft, this forms the inner axle of the wheel hub. 
motor_attachment_radius = 4;
// Radius of the motor shaft. Extra clearnace for printing is added in this example. 
motor_shaft_r = 1.5 + 0.5;
// Amount to cut off a keyed motor shaft. Extra added to make it more snug in this example. Ideally pressure-fit, unless a set screw or glue is used. 
motor_shaft_key_inset = 0.5 + 0.2; 
// Length of motor shaft holder. 
motor_shaft_length = 9;

// Please disregard that these variable are prefixed "m3". That's just the size the first version was using. 
// These are more arbitrary parameters that can be changed. 
/* [Roller Screw Axle Dimensions] */
// Radius of the screw. (extra size for printing clearance is added in this example.)
m3_screw_r = 1.5 + 0.6;
m3_screw_shaft_length = 20; // Not counting length of head and nut, add 5mm to actual screw length.
// Radius of the nut is calculated to be the circle containing the nut, plus some extra print clearance. 
m3_nut_radius = 5.5 /2 / cos(30) + 0.5;
// Depth of the captive nut holder in the roller piece. 
m3_nut_holder_depth = 3;
// Overall thickness of the solid portion of the roller between the nut and the bearing spacer. 
m3_nut_holder_thickness = 7;
// Captive nut holder widens at the end of the roller to this radius to ease insertion of the nut.
m3_entrance_clearance_r = 4;

// Calculate the thickness of the main hub section that holds the angled outer hub spokes.
wheel_attachment_thickness = (bearing_outer_diameter + bearing_holder_width*2) * sin(wheel_angle) +
                             bearing_width * sin(wheel_angle);
echo(wheel_attachment_thickness);

// Width of the virtual wheel outline filled by the mecanum wheels.
contact_shape_thickness = 25;
// Height (radial measurement) of the virtual wheel outline filled by the mecanum wheels.
contact_shape_height = 16;

// Preview a sample bearing.
// Note that the bearing previewed here does not scale with parameters.
// If you want to see how a different bearing fits, replace this module. 
// This is included as a demonstration for a particular wheel size. It does not scale with other parameters. 
module MR63ZZ_bearing() {
  difference() {
    cylinder(r = bearing_outer_diameter/2, h = bearing_width, center = true, $fn = 30);
    cylinder(r = bearing_inner_diameter/2, h = bearing_width + 2*slop, center = true, $fn = 20);
  }
}

