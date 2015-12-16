#include <SDL.h> // Needed because it messes with main()

#include <iostream>
#include <string>
#include <math.h>

#include <boost/thread.hpp> 
#include <boost/date_time/posix_time/posix_time.hpp>
#include "asynch_serial/buffered_async_serial.h"

#include "sdl_joystick.h"

using namespace boost;
using boost::posix_time::ptime;
using boost::posix_time::time_duration;
//using boost::posix_time::microsec_clock::local_time;

//Analog joystick dead zone
const double JOYSTICK_DEAD_ZONE = 0.15;
#define PI 3.14159265

string mecanum_control() {
  char command[100];

  // Input 0: X -left +right
  // Input 1: Y -up +down
  // Input 2: R -left + right

  double x = (double)controller_state[0][0] / 32768;
  double y = (double)controller_state[0][1] / 32768;

  double r = (double)controller_state[0][2] / 32768;

  double theta;
  double magnitude;

  // Clamp input within the dead zone
  if(x > -JOYSTICK_DEAD_ZONE && x < JOYSTICK_DEAD_ZONE && y > -JOYSTICK_DEAD_ZONE && y < JOYSTICK_DEAD_ZONE) {
    x = 0.0;
    y = 0.0;
    theta = 0.0;
    magnitude = 0.0;
  } else {
    // Turn x and y into polar coordinate (angle, magnitude clamped to 1.0)
    theta = atan2(x, -y);
    if(theta < 0.0) theta += 2*PI;
    magnitude = sqrt(x*x + y*y);
    if(magnitude > 1.0) magnitude = 1.0;
  }

  if(r > -JOYSTICK_DEAD_ZONE && r < JOYSTICK_DEAD_ZONE) r = 0.0;


  // Original wheel positions
  /*
  // wheels: 1: RF 2: RR 3: LR 4: LF
  // forward  =  1  1  1  1  (theta = 0)
  // right    =  1 -1  1 -1  (theta = pi/2)
  // backward = -1 -1 -1 -1  (theta = pi)
  // left     = -1  1 -1  1  (theta = 3 pi/2)

  // Desired motor movement for translation commands at full speed. (Forward/backward, left/right)
  double m1, m2, m3, m4;

  if(theta >= 0.0 && theta < PI/2) {
    m1 = m3 =  1.0;
    m2 = m4 =  1.0 - 4*theta/PI;
  } else if(theta >= PI/2 && theta < PI) {
    m1 = m3 = 1.0 - 4*(theta - PI/2)/PI;
    m2 = m4 = -1.0;
  } else if(theta >= PI && theta < 3*PI/2) {
    m1 = m3 = -1.0;
    m2 = m4 = -1.0 + 4*(theta - PI)/PI;
  } else {
    m1 = m3 = -1.0 + 4*(theta - 3*PI/2)/PI;
    m2 = m4 = 1.0;
  }
  */

  // Swapped wheel positions
  // wheels: 1: RF 2: RR 3: LR 4: LF
  // forward  =  1  1  1  1  (theta = 0)
  // right    = -1  1 -1  1  (theta = pi/2)
  // backward = -1 -1 -1 -1  (theta = pi)
  // left     =  1 -1  1 -1  (theta = 3 pi/2)

  // Desired motor movement for translation commands at full speed. (Forward/backward, left/right)
  double m1, m2, m3, m4;

  if(theta >= 0.0 && theta < PI/2) {
    m1 = m3 =  1.0 - 4*theta/PI;
    m2 = m4 =  1.0;
  } else if(theta >= PI/2 && theta < PI) {
    m1 = m3 = -1.0;
    m2 = m4 = 1.0 - 4*(theta - PI/2)/PI;
  } else if(theta >= PI && theta < 3*PI/2) {
    m1 = m3 = -1.0 + 4*(theta - PI)/PI;
    m2 = m4 = -1.0;
  } else {
    m1 = m3 = 1.0;
    m2 = m4 = -1.0 + 4*(theta - 3*PI/2)/PI;
  }


  // Scale by the magnitude of the control vector
  m1 *= magnitude;
  m2 *= magnitude;
  m3 *= magnitude;
  m4 *= magnitude;

  // Desired motor movement for rotation commands. (Left/right)
  double r1, r2, r3, r4;
  double r_mag = abs(r);

  r1 = -r;
  r2 = -r;
  r3 = r;
  r4 = r;

  // Weighted average the translation and rotation desired movements
  // Avoid the possibility of inflated commands from small inputs
  if(magnitude + r_mag > JOYSTICK_DEAD_ZONE) {
    m1 = (m1 * magnitude + r1 * r_mag) / (magnitude + r_mag);
    m2 = (m2 * magnitude + r2 * r_mag) / (magnitude + r_mag);
    m3 = (m3 * magnitude + r3 * r_mag) / (magnitude + r_mag);
    m4 = (m4 * magnitude + r4 * r_mag) / (magnitude + r_mag);
  }

  cout << "                         " << x << " " << y << " " << theta << " "  << magnitude << " " << r << " " << r1 << " " << r2 << " " << r3 << " " << r4 << endl;
  sprintf(command, "M %d %d %d %d \r\n", (int)(m1 * 255), (int)(m2 * 255), (int)(m3 * 255), (int)(m4 * 255));
  //cout << command << endl;

  //return "M 0 0 0 0\r\n";
  return command;
  
}



int main(int argc, char* argv[]) {
  string port = "COM8";
  if(argc > 1) {
    port = argv[1];
  }
  cout << "Using port: " << port.c_str() << endl;
  try {

    BufferedAsyncSerial serial(port.c_str(),115200);
    this_thread::sleep(posix_time::seconds(2)); // Let the serial port finish initializing

    if(!init_stl()) {
      cout << "Failed to initialize STL." << endl;
    } else {
      ptime now(boost::posix_time::microsec_clock::local_time());
      ptime last_msg(boost::posix_time::microsec_clock::local_time());
      time_duration dt;

      string response;
      string last_command = "M 0 0 0 0\r\n"; // Record last command to avoid spamming the serial line with duplicates.

      serial.writeString(last_command.c_str());
      this_thread::sleep(posix_time::seconds(2));
      cout << "Initial command response: " << serial.readStringUntil("\r\n") << endl;

      bool done = false;
      bool event_happened = false;
      while(!done) {
        // Check for a message from the rover.
        response = serial.readStringUntil("\r\n");
        if(response.length() > 0) {
          cout << "Response: " << response << endl;
        }
        // Check for controller input.
        stl_event_wait(done, event_happened);
        if(!done && event_happened) {
          //cout << "event!" << endl;
          now = boost::posix_time::microsec_clock::local_time();
          dt = now - last_msg;
          if(dt.total_milliseconds() > 20) {
            string command = mecanum_control();
            if(command != last_command) {
              last_msg = now;
              serial.writeString(command.c_str());
              cout << command;
              last_command = command;
            }
          }
        }
      }
    }

    close_stl(); // Free resources and close SDL
    serial.close();
  } catch(boost::system::system_error& e) {
    cout << "Error: " << e.what() << endl;
    return -1;
  }

  return 0;
}
