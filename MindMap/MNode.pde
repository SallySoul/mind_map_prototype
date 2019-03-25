class MNode {
  PVector pos;
  PVector force;
  float size;
  float gap;
  String message;
  
  MNode (PVector start_pos, float start_size) {
    pos = start_pos;
    size = start_size;

    force = new PVector(0.0, 0.0);
    gap = 5.0;
  }

  void addForce(Mnode neighbor) {
    float desired_distance = gap + this.size + neighbor.size;
    actual distance = (this.pos - neighbor.pos).mag();

    if actual_distance < desired_distance {
      PVector force = (this.pos - neighbor.pos).normalize() * (desired_distance - actual_distance);
      this.force += force;
      this.force += new PVector(random(-0.001, 0.001), random(-0.001, 0.001));
    }
  }

  void update(float elapsedTime) {
     
  }
  
  void draw() {
    ellipse(pos.x, pos.y, size, size);
  }
}
