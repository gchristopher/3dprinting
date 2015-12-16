#include <SDL.h>
#include <iostream>
#include "sdl_joystick.h"

SDL_Joystick* controller = NULL;
vector<vector<int>> controller_state;

bool init_stl() {
  bool success = true;

  //Initialize SDL
  if( SDL_Init( SDL_INIT_JOYSTICK ) < 0 ) {
    cout << "SDL could not initialize! SDL Error: " << SDL_GetError() << endl;
    success = false;
  } else {
    if( SDL_NumJoysticks() < 1 ) { //Check for joysticks
      cout << "No joysticks connected." << endl;
      success = false;
    } else {
      controller = SDL_JoystickOpen( 0 ); //Load joystick
      if( controller == NULL ) {
        cout << "Warning: Unable to open game controller! SDL Error: " <<  SDL_GetError() << endl;
      }
      cout << "Found " << SDL_NumJoysticks() << " joystick(s)." << endl;
      controller_state.resize(3);
      controller_state[0].resize(SDL_JoystickNumAxes(controller));
      controller_state[1].resize(SDL_JoystickNumButtons(controller));
      controller_state[2].resize(SDL_JoystickNumHats(controller));
      cout << "Joystick 0: " << SDL_JoystickNumAxes(controller) << " axis, " << SDL_JoystickNumButtons(controller) << " buttons, " << SDL_JoystickNumHats(controller) << " hats." << endl;
    }
  }

  return success;
}



void close_stl() {
  SDL_JoystickClose( controller );
  controller = NULL;

  SDL_Quit(); //Quit SDL subsystems
}



void stl_event_wait(bool &done, bool &event_happened) {
  SDL_Event e; //Event object.
  done = false;
  event_happened = false;

  // Wait for SDL event.
  if(SDL_PollEvent( &e ) != 0) {
    event_happened = false;
    if( e.type == SDL_QUIT ) {
      done = true;
      return;
    }
    
    if( e.type == SDL_JOYAXISMOTION ) {
      if(e.jaxis.which == 0) {
        event_happened = true;
        controller_state[0][e.jaxis.axis] = e.jaxis.value;
      }
      //cout << "axis: " << e.jaxis.which << " " << (int)e.jaxis.axis << " " << e.jaxis.value << endl;
    } else if (e.type == SDL_JOYBUTTONDOWN || e.type == SDL_JOYBUTTONUP) {
      if(e.jbutton.which == 0) {
        event_happened = true;
        controller_state[1][e.jbutton.button] = e.jbutton.state;
      }
      //cout << "button: " << e.jbutton.which << " " << (int)e.jbutton.button << " " << (int)e.jbutton.state << endl;
    } else if (e.type == SDL_JOYHATMOTION) {
      if(e.jhat.which == 0) {
        event_happened = true;
        controller_state[2][e.jhat.hat] = e.jhat.value;
      }
      //cout << "hat: " << e.jhat.which << " " << (int)e.jhat.hat << " " << (int)e.jhat.value << endl;
    }
  }
}
