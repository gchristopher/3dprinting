// teal_drone_top_cover_with_side_bracket_supports.scad


slop = 0.01;



include <teal_drone_top_cover_plain_parameters.scad>
include <teal_drone_top_cover_stocklike_parameters.scad>

use <teal_drone_top_cover_plain.scad>
use <teal_drone_top_cover_stocklike.scad>
use <teal_drone_top_cover_with_side_bracket.scad>

top_cover_with_side_bracket(true, 0);


max_support_height = 40;
camera_cowl_support_endpoints = [ [ [10, 10], [10, -50] ], [ [3.3, 10], [3.3, -50] ] ];
front_vent_cowl_support_endpoints = [ [ [27, 15], [30, -40] ], [ [20, 17], [24, -40] ] ];
rear_vent_cowl_support_endpoints = [ [ [21, 8], [21, 65] ], [ [25, 8], [25, 65] ], [ [11, 30], [20, 65] ], [ [7, 40], [16, 70] ], [ [35, 30], [25, 65] ] ];
sma_jack_cowl_support_endpoints = [ [ [0, 30], [0, 70] ] ];
tilt_bracket_under_cowl_support_endpoints = [ [ [34, -33], [12, -48] ], [ [32, -33], [30, -48] ], [ [30, -33], [40, -40] ] ];




module draw_thin_line(point_1, point_2) {
  length = sqrt(pow(point_2[0] - point_1[0], 2) + pow(point_2[1] - point_1[1], 2));
  rot = atan2(point_1[0] - point_2[0], point_2[1] - point_1[1]);
  
  translate([point_1[0], point_1[1]])
  rotate([0, 0, rot])
  square([0.4, length]);
}





module interior_volume() {
  translate([0, 0, slop])
  case_inner_volume();
}

module interior_volume_thin_shell() {
  difference() {
    translate([0, 0, slop])
    case_inner_volume();
    case_inner_volume();
  }
}

module camera_cowl_support_box_shape() {
  projection() {
    intersection() {
      // Camera bracket and cowling
      difference() {
        translate([0, fpv_camera_position_forward, fpv_camara_position_h]) 
        fpv_camera_holder_outer_shell();
          
        translate([0, fpv_camera_position_forward, fpv_camara_position_h]) {
          fpv_camera_holder_inner_cutout();
            
          fpv_camera_tilt_bracket_cutout();
            
        }
        case_inner_volume();
      }
  
      //}
      //render() // All those hulls and differences are slow. Pre-render to make life easier. 
      //teal_cover_plain();
      
      render()
      translate([0, 0, slop])
      case_inner_volume();
            
    }
  
    translate([0, fpv_camera_position_forward, fpv_camara_position_h])
    fpv_camera_tilt_bracket();
  }
}

module camera_cowl_support_region() {
  difference() {
    intersection() {
      projection()
      difference() {
        translate([0, fpv_camera_position_forward, fpv_camara_position_h])
        fpv_camera_holder_inner_cutout();
        render();
        case_inner_volume();
      }
      projection()
      translate([0, fpv_camera_position_forward, fpv_camara_position_h]) 
      fpv_camera_holder_outer_shell();
    }
    projection()
    translate([0, fpv_camera_position_forward, fpv_camara_position_h])
    fpv_camera_tilt_bracket();
  }
}


//module camera_cowl 



//camera_cowl_support_region();

//projection() {
    //translate([0, fpv_camera_position_forward, fpv_camara_position_h])
    //fpv_camera_holder_inner_cutout();
  
    //translate([0, fpv_camera_position_forward, fpv_camara_position_h]) {
      //fpv_camera_holder_inner_cutout();
      //fpv_camera_tilt_bracket_cutout();
    //}
    //translate([0, sma_connector_position_rear, sma_connector_position_h])
    //sma_connector_bracket_cutout();
    //front_vent_cowling_cutout();
    //rear_vent_cowling_cutout();
    //fpv_camera_tilt_bracket_under_cowling_cutout();
    //mirror([1, 0, 0])
    //fpv_camera_tilt_bracket_under_cowling_cutout();
//}

//fpv_camera_tilt_bracket_under_cowling_cutout();

module camera_cutout_support_region() {
  difference() {
    projection()
    intersection() {
      translate([0, fpv_camera_position_forward, fpv_camara_position_h])
      fpv_camera_holder_inner_cutout();
      render()
      interior_volume_thin_shell();
    }
    offset(r = slop)
    camera_cowl_support_region();
    
    projection()
    translate([0, fpv_camera_position_forward, fpv_camara_position_h])
    fpv_camera_tilt_bracket();  
  }
}

module sma_cowling_support_box_shape() {
  projection()
  intersection() {
    // SMA jack and cowling
    translate([0, sma_connector_position_rear, sma_connector_position_h])
    difference() {
      sma_connector_bracket();
      sma_connector_bracket_cutout();
    }
    interior_volume_thin_shell();
  }
}

module front_vent_support_region() {
  difference() {
    projection()
    intersection() {
      front_vent_cowling_cutout();
      interior_volume_thin_shell();
    }
    offset(r = 0.4 + 2*slop)
    camera_cowl_support_region();
    
    offset(r = -0.4 + slop)
    camera_cowl_support_box_shape();
  }
}

module rear_vent_support_region() {
  difference() {
    projection()
    intersection() {
      rear_vent_cowling_cutout();
      interior_volume_thin_shell();
    }
    projection() {
      difference() {
        front_vent_cowling_cutout();
        interior_volume();
      }
    }
    offset(r = -0.4 + slop)
    projection()
    translate([0, sma_connector_position_rear, sma_connector_position_h])
    sma_connector_bracket();
  }
}



module tilt_bracket_under_cowling_support_region() {
  difference() {
    projection() {
      fpv_camera_tilt_bracket_under_cowling_shape();
      mirror([1, 0, 0])
      fpv_camera_tilt_bracket_under_cowling_shape();
    }
    offset(r = -0.4 + slop)
    camera_cowl_support_box_shape();
  }
}


module tilt_bracket_under_cowl_supports() {
  intersection() {
    // Perimeter support for tilt bracket under cowling.
    linear_extrude(height = max_support_height, convexity = 10) {
      difference() {
        offset(r = -slop)
        tilt_bracket_under_cowling_support_region();
        offset(r = -0.4)
        tilt_bracket_under_cowling_support_region();
      }
      intersection() {
        for(endpoint_pairs = tilt_bracket_under_cowl_support_endpoints) {
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
          mirror([1, 0])
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        }
        offset(r = -2*slop)
        tilt_bracket_under_cowling_support_region();
      }
    }
    
    difference() {
      interior_volume();
      fpv_camera_tilt_bracket_under_cowling_cutout();
      mirror([1, 0, 0])
      fpv_camera_tilt_bracket_under_cowling_cutout();
    }
  }
}
  
module front_vent_cowl_supports() {
  intersection() {
    linear_extrude(height = max_support_height, convexity = 10) {
      // Front vent cowl support perimeter
      difference() {
        offset(r = -slop)
        front_vent_support_region();
        offset(r = -0.4 + slop)
        front_vent_support_region();
      }
      intersection() {
        for(endpoint_pairs = front_vent_cowl_support_endpoints) {
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
          mirror([1, 0])
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        }
        offset(r = -2*slop)
        front_vent_support_region();
      }
    }

    union() {
      interior_volume();
      translate([0, 0, slop])
      front_vent_cowling_cutout();
    }
  }
}


module rear_vent_cowl_supports() {
  intersection() {
    linear_extrude(height = max_support_height, convexity = 10) {
      // Rear vent cowl support perimeter
      difference() {
        offset(r = -slop)
        rear_vent_support_region();
        offset(r = -0.4 + slop)
        rear_vent_support_region();
      }
      intersection() {
        for(endpoint_pairs = rear_vent_cowl_support_endpoints) {
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
          mirror([1, 0])
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        }
        offset(r = -2*slop)
        rear_vent_support_region();
      }
    }    
    union() {
      interior_volume();
      translate([0, 0, slop])
      rear_vent_cowling_cutout();
    }
  }
}

module sma_jack_cowl_supports() {
  // Perimeter supports for SMA jack cowling.
  intersection() {
    linear_extrude(height = max_support_height, convexity = 10)
    difference() {
      offset(r = -slop)
      sma_cowling_support_box_shape();
      offset(r = -0.4 + slop)
      sma_cowling_support_box_shape();
    }
  
    interior_volume();
  }

  intersection() {
    linear_extrude(height = max_support_height, convexity = 10)
    intersection() {
      for(endpoint_pairs = sma_jack_cowl_support_endpoints) {
        draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        mirror([1, 0])
        draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
      }
      hull()
      offset(r = -0.4 + 2*slop)
      sma_cowling_support_box_shape();
    }
    union() {
      translate([0, sma_connector_position_rear, sma_connector_position_h])
      sma_connector_bracket_cutout();
      interior_volume();
    }
  }
}

module camera_cowl_supports() {
  // Perimeter support for camera cowling and tilt bracket.
  difference() {
    intersection() {
      linear_extrude(height = max_support_height, convexity = 10)
      difference() {
        offset(r = -slop)
        camera_cowl_support_box_shape();
        offset(r = -0.4 + slop)
        camera_cowl_support_box_shape();
      }
      
      interior_volume();
        
    }
    hull()
    translate([0, fpv_camera_position_forward, fpv_camara_position_h])
    fpv_camera_tilt_bracket();  
  }

  intersection() {
  
    linear_extrude(height = max_support_height, convexity = 10)
    intersection() {
      for(endpoint_pairs = camera_cowl_support_endpoints) {
        draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        mirror([1, 0])
        draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
      }
      offset(r = slop)
      camera_cowl_support_region();
    }
    
    union() {
      translate([0, fpv_camera_position_forward, fpv_camara_position_h])
      fpv_camera_holder_inner_cutout();
      //translate([0, fpv_camera_position_forward, fpv_camara_position_h - slop])
      //fpv_camera_holder_outer_shell();      
      interior_volume();
    }
  }
}


module camera_lense_cutout_support() {
  // Perimeter support for camera lense cutout.
  intersection() {
    linear_extrude(height = max_support_height, convexity = 10)
    difference() {
      offset(r = 0.4)
      camera_cutout_support_region();
      camera_cutout_support_region();
    }
    interior_volume();
  }
}

module remaining_interior_volume_to_support() {
  difference() {
    projection()
    interior_volume();
    
    //offset(r = -slop)
    //hull()
    camera_cowl_support_box_shape();
    camera_cowl_support_region();
    front_vent_support_region();
    rear_vent_support_region();
    camera_cutout_support_region();
    hull()
    sma_cowling_support_box_shape();
    tilt_bracket_under_cowling_support_region();
  }
}

module remaining_interior_supports() {
  intersection() {
    linear_extrude(height = max_support_height, convexity = 10)
    intersection() {
      union() {
        plain_case_center_area_support_endpoints = [ [ [0, 12], [23, 9] ], [ [0, 20], [20, 0] ], [ [4, 5], [2, 40] ], [ [10, 3], [4, 40] ], [ [18, 0], [4, 45] ], [ [20, 18], [4, 45] ], [ [3, 38], [20, 35] ] ];
        
        for(endpoint_pairs = plain_case_center_area_support_endpoints) {
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
          mirror([1, 0])
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        }
            
        plain_case_edge_area_support_endpoints = [ [ [25, 33], [60, 34] ], [ [25, -33], [60, -34] ], [ [25, 21], [60, 21] ], [ [25, -21], [60, -21] ], [ [25, 10], [60, 10] ], [ [25, -10], [60, -10] ] , [ [10, -38], [40, -70] ] ];
        
        for(endpoint_pairs = plain_case_edge_area_support_endpoints) {
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
          mirror([1, 0])
          draw_thin_line(endpoint_pairs[0], endpoint_pairs[1]);
        }
      }
      remaining_interior_volume_to_support();
    }
    
    interior_volume();
  }
}



camera_cowl_supports();
front_vent_cowl_supports();
rear_vent_cowl_supports();
sma_jack_cowl_supports();
camera_lense_cutout_support();
tilt_bracket_under_cowl_supports();
remaining_interior_supports();


      