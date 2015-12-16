#include <vector>
using namespace std;

extern vector<vector<int>> controller_state;

bool init_stl();
void close_stl();
void stl_event_wait(bool &done, bool &event_happened);
