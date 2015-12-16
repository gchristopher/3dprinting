// electronics_holder.scad
//
// A printable "proto-board" concept for holding and wiring carrier boards.
// The board is a frame designed to hold female header strips at 0.1" DIP package spacing
// to provide a socket frame for electronics carried boards. The female headers can be glued
// to the printed frame and then wired similarly to how one might wire sockets soldered into
// a proto board. 
//
// By Gregg Christopher, 2015
// This file is public domain

slop = 0.01;

ps = 0.1 * 25.4;

module pin_strip(min_x, min_y, max_x, max_y) {
  translate([(min_x) * ps, (min_y) * ps])
  square([(max_x - min_x + 1) * ps, (max_y - min_y + 1) * ps]);
  
}

module lpcxpresso_holder() {
  translate([-5 * ps, -12.5 * ps])
  square([ps, 69.6]);
  translate([4 * ps, -12.5 * ps])
  square([ps, 69.6]);
  
  translate([-2 * ps - 0.7, -12.5 * ps, 0])
  square([15.9, 3 * ps]);

  translate([3 * ps - 0.2, -9.5 * ps, 0])
  square([ps, ps]);
}


module motor_driver_holder() {
  translate([-2.5 * ps, 0])
  square([ps, 21.3], center = true);
  translate([2.5 * ps, 0])
  square([ps, 21.3], center = true);
}

module bluefruit_holder() {
  square([ps, 21.3], center = true);
}

module vreg_holder() {
  square([13.5, ps], center = true);
}

module all_holders() {
  translate([-11.5 * ps, 0.5 * ps])
  vreg_holder();
  
  translate([9.5 * ps, 4 * ps])
  bluefruit_holder();
  
  translate([12 * ps, -8 * ps])
  motor_driver_holder();
  
  translate([-12 * ps, -8 * ps])
  motor_driver_holder();
  
  translate([0, 0.5 * ps])
  lpcxpresso_holder();
}

module screw_hole_6_32() {
  translate([0.5 * ps, 0.5 * ps])
  difference() {
    circle(r = 10/2, $fn = 20);
    circle(r = 4.4/2, $fn = 16);
  }
}

mirror([1, 0, 0])
linear_extrude(height = 3) {
  difference() {
    offset(r = 3, $fn = 20)
    all_holders();
    
    offset(r = 0.1) // Add slop to compensate for hole shrinkage?
    all_holders();
  }  
  
  // Cross-braces for lpc holder
  pin_strip(-3, -5, 2, -5);
  pin_strip(-3, 0, 2, 0);
  pin_strip(-3, 5, 2, 5);
  pin_strip(-3, 10, 2, 10);
  pin_strip(-4, 15, 3, 15);
  
  // VReg braces
  pin_strip(-15, -3, -15, -1);
  pin_strip(-10, -3, -10, -2);
  pin_strip(-8, 0, -7, 0);
  
  // Bluefruit braces
  pin_strip(6, 7, 7, 7);
  pin_strip(6, 0, 7, 0);
  pin_strip(9, -3, 9, -2);
  
  // Left motor holder braces
  pin_strip(-13, -12, -12, -12);
  pin_strip(-13, -5, -12, -5);
  
  pin_strip(-8, -12, -7, -12);
  pin_strip(-8, -5, -7, -5);
  
  // Right motor holder braces
  pin_strip(11, -12, 12, -12);
  pin_strip(11, -5, 12, -5);
  
  pin_strip(6, -12, 7, -12);
  pin_strip(6, -5, 7, -5);


  pin_strip(-13, 7, -7, 7);
  pin_strip(11, 7, 12, 7);
  pin_strip(11, 0, 14, 0);
  pin_strip(-15, 1, -15, 5);
  pin_strip(-10, 1, -10, 7);
  pin_strip(14, -3, 14, 5);
  translate([14*ps, 7*ps]) screw_hole_6_32();
  translate([-15*ps, 7*ps]) screw_hole_6_32();

  pin_strip(-13, -16, 12, -16);
  pin_strip(-15, -14, -15, -14);
  pin_strip(14, -14, 14, -14);
  pin_strip(-5, -16, -5, -14);
  pin_strip(4, -16, 4, -14);

  translate([14*ps, -16*ps]) screw_hole_6_32();
  translate([-15*ps, -16*ps]) screw_hole_6_32();
}
