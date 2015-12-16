// spacer.scad
//
// A small spacer to provide structure between the body frame and electronics
// holder board of a small mecanum wheel rover.
//
// By Gregg Christopher, 2015
// This file is public domain

screw_6_32_r = 4.4/2;
slop = 0.01;

total_height = 1.5 * 25.4;

module spacer() {
  difference() {
    cylinder(r = 10/2, h = total_height - 8, $fn = 20);
    translate([0, 0, -slop])
    cylinder(r = screw_6_32_r, h = total_height - 8 + 2*slop, $fn = 20);
  }
  translate([0, 0, total_height - 8 - slop])
  difference() {
    cylinder(r = 10/2, h = 8, $fn = 20);
    translate([0, 0, -slop]) {
      cylinder(r = screw_6_32_r, h = 8 + 2*slop, $fn = 20);
      translate([-5 - slop, 0, 0])
      cube([10 + 2*slop, 5 + slop, 8 + 2*slop]);
    }
  }
}

spacer();


