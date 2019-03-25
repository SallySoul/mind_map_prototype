enum Mode {
  Visual,
  Insert,
  Default,
}

color modeColor(Mode mode) {
  color result;
  switch (mode) {
    case Visual:
      result = color(0, 102, 153);
      break;
    case Insert:
      result = color(0, 204, 102);
      break;
    case Default:
      result = color(102, 153, 153);
      break;
    default:
      result = color(0, 0, 0);
      break;
  }
  return result;
}

void startTransitionToDefault() {
  global_mode = Mode.Default;
  last_mode_color = mode_color;
  mode_color = modeColor(Mode.Default);
  mode_transition = 0.0;
  
  selected_mnode = null;
}

void startTransitionToInsert() {
  global_mode = Mode.Insert; 
  last_mode_color = mode_color;
  mode_color = modeColor(Mode.Insert);
  mode_transition = 0.0;
  
  if (selected_mnode == null) {
    PVector pos = new PVector(float(width / 2) + random(-0.001, 0.001), float(height / 2) + random(-0.001, 0.001));
    selected_mnode = new MNode(pos, 100.0);
    node_list.add(selected_mnode);
  }
}

void startTransitionToVisual() {
  global_mode = Mode.Visual; 
  last_mode_color = mode_color;
  mode_color = modeColor(Mode.Visual);
  mode_transition = 0.0;
}

color interpolateColors(color c1_arg, color c2_arg, float t) {
  // We need to copy these colors so we can take them apart
  color c1 = c1_arg;
  color c2 = c2_arg;
  
  // Get all their components seperated;
  float c1_a = float((c1 >> 24) & 0xFF);
  float c1_r = float((c1 >> 16) & 0xFF);
  float c1_g = float((c1 >> 8) & 0xFF);
  float c1_b = float(c1 & 0xFF);   
  float c2_a = float((c2 >> 24) & 0xFF);
  float c2_r = float((c2 >> 16) & 0xFF);
  float c2_g = float((c2 >> 8) & 0xFF);
  float c2_b = float(c2 & 0xFF);
  
  float ti = 1.0 - t;
  return color(
    int(ti * c1_r + t * c2_r),
    int(ti * c1_g + t * c2_g),
    int(ti * c1_b + t * c2_b),
    int(ti * c1_a + t * c2_a)
  );
}

// Global mode and related colors
Mode global_mode = Mode.Default;
color mode_color = modeColor(Mode.Default);
color last_mode_color = modeColor(Mode.Default);
float mode_transition = 1.0;
float mode_transition_time = 250.0;

// The selected Node, and other node things
MNode selected_mnode = null;
ArrayList<MNode> node_list = new ArrayList();

// Timing related stuff
int last_frame = 0;

void setup() {
  size(1000, 1000);
  println("Setup!");
}

void draw() {
  int current_time = millis();
  float elapsed_time = float(current_time - last_frame);
  last_frame = current_time;
  
  if (mode_transition < 1.0) {
    // Update mode_transition by fraction of time completed
    mode_transition += elapsed_time / mode_transition_time;
    constrain(mode_transition, 0.0, 1.0);
    
    // Interpolate between current and last mode colors
    float ti = 1.0 - mode_transition;
    color transition_color = interpolateColors(last_mode_color, mode_color, mode_transition);
    background(transition_color);
  } else {
    background(mode_color);
  }
 
  for (MNode node_1: nodelist) {
    for (MNode node_2: nodelist) {
      node_1.add_force(node_2);
    } 
  }
  for (MNode node: node_list) {
    node.update();
    node.draw(); 
  }
}

void keyPressed() {
  if (key == ESC) {
    // This prevents Processing from quiting due to escape
    key = 0;
    startTransitionToDefault();
   } //<>//
   
   if (global_mode == Mode.Insert && selected_mnode != null) {
     return;
   }
   
   switch (key) {
     case ' ': startTransitionToInsert();
       break;
     case 'v': startTransitionToVisual();
       break;
   }
}
