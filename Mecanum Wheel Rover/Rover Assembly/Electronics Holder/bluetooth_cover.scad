// electronics_cover.scad
//
// The portion of an electronics cover for an upright bluetooth serial module that sticks up 
// from the rest of the electronics.
//
// By Gregg Christopher, 2015
// This file is public domain

slop = 0.01;

ps = 0.1 * 25.4;

// 0, 0 = centered at origin
module pin_strip(min_x, min_y, max_x, max_y) {
  translate([(min_x) * ps, (min_y) * ps])
  square([(max_x - min_x + 1) * ps, (max_y - min_y + 1) * ps]);
  
}


module bluefruit_holder() {
  square([ps, 21.3], center = true);
}

  linear_extrude(height = 38)
  difference() {
    offset(r = 2.9, $fn = 20)
    bluefruit_holder();

    offset(r = 1.5, $fn = 20)
    bluefruit_holder();
  }

  linear_extrude(height = 0.75)
  difference() {
    offset(r = 4, $fn = 20)
    bluefruit_holder();

    offset(r = 1.5, $fn = 20)
    bluefruit_holder();
  }

  translate([0, 0, 38-slop])
  linear_extrude(height = 0.95)
  difference() {
    offset(r = 2.9, $fn = 20)
    bluefruit_holder();
  }

