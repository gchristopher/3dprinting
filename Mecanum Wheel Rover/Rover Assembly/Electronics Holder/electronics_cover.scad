// electronics_cover.scad
//
// A printable cover for an electronics holder board.
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
  }
}

module electronics_outline() {
  difference() {
    union() {
      offset(r = 3, $fn = 20)
      all_holders();

      pin_strip(-15, -16, 14, 7);
      pin_strip(-4, 6, 3, 15);

      translate([-37/2, 18])
      square([37, 30]);
      
      translate([14*ps, 7*ps]) screw_hole_6_32();
      translate([-15*ps, 7*ps]) screw_hole_6_32();
      translate([14*ps, -16*ps]) screw_hole_6_32();
      translate([-15*ps, -16*ps]) screw_hole_6_32();
    }

  }
}

mirror([1, 0, 0])
difference() {
  union() {
    translate([0, 0, -0.75])
    linear_extrude(height = 0.75)
    offset(r = .6, $fn = 20)
    electronics_outline();
    
    linear_extrude(height = 7.5)
    difference() {
      offset(r = .6, $fn = 20)
      electronics_outline();
    
      offset(r = -1, $fn = 20)
      electronics_outline();
    }
    
    translate([0, 0, 5.5])
    linear_extrude(height = 2)
    difference() {
      offset(r = 1.25, $fn = 20)
      electronics_outline();
    
      offset(r = 0.3, $fn = 20)
      electronics_outline();
    }
    
    translate([0, 0, 7.5])
    linear_extrude(height = 2)
    difference() {
      offset(r = 1.9, $fn = 20)
      electronics_outline();
    
      //offset(r = 1, $fn = 20)
      offset(r = 0.3, $fn = 20)
      electronics_outline();
    }
    
    intersection() {
      union() {
        translate([0, 0, 9.5])
        linear_extrude(height = 1.8)
        difference() {
          offset(r = 1.9, $fn = 20)
          electronics_outline();
        
          offset(r = 0.3, $fn = 20)
          electronics_outline();
        }

        translate([0, 0, 9.5 + 1.8])
        linear_extrude(height = 2)
        difference() {
          offset(r = 1.9, $fn = 20)
          electronics_outline();
        
          offset(r = -1.1, $fn = 20)
          electronics_outline();
        }
      }
      translate([-100/2, -3, 9.5])
      cube([100, 15, 10]);
    }
  }

  translate([9.5 * ps + 0.5, 4 * ps, -1])
  linear_extrude(height = 2)
  offset(r = 1.5, $fn = 20)
  bluefruit_holder();    
  
  translate([-50/2, 45, -1])
  cube([50, 30, 20]);
  
  translate([-45/2, -45, 4])
  cube([45, 10, 10]); 
}




