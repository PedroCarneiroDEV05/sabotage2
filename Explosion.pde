class Explosion {
  ArrayList<Particle> particles;

  Explosion(float x, float y) {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < 30; i++) {
      particles.add(new Particle(x, y));
    }
  }

  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  boolean isFinished() {
    return particles.isEmpty();
  }
}

class Particle {
  PVector position;
  PVector velocity;
  float lifespan;

  Particle(float x, float y) {
    position = new PVector(x, y);
    float angle = random(TWO_PI);
    float speed = random(1, 6); 
    velocity = new PVector(cos(angle) * speed, sin(angle) * speed);
    lifespan = 255; 
  }

  void update() {
    position.add(velocity);
    lifespan -= 8; 
  }

  void display() {
    noStroke();
    fill(255, 150, 0, lifespan); 
    circle(position.x, position.y, 5); 
  }

  boolean isDead() {
    return lifespan < 0;
  }
}
