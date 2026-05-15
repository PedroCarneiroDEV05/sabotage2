class Helicopter extends Enemy {
  float dropTimer;
  float dropInterval;
  boolean movingRight;
  ArrayList<Parachuter> dropped;

  Helicopter(float x, float y) {
    super(x, y, random(1.5, 3.0), 2);
    this.movingRight = (x < width / 2);
    this.dropInterval = random(120, 240);
    this.dropTimer = dropInterval - 60;
    this.dropped = new ArrayList<Parachuter>();
  }

  void update() {
    x += movingRight ? speed : -speed;
    dropTimer++;

    if (dropTimer >= dropInterval) {
      dropTimer = 0;
      dropped.add(new Parachuter(x, y, wave));
    }

    if (isOffScreen()) {
      alive = false;
      escaped = true;
    }
  }

  void display() {
    pushMatrix();
    rectMode(CENTER);
    fill(80, 80, 80);
    rect(x, y, 60, 20);
    fill(60);
    rect(x + 25, y - 5, 20, 8);
    fill(180, 0, 0);
    ellipse(x, y - 14, 70, 8);
    fill(255, 200, 0);
    ellipse(x, y, 10, 10);
    rectMode(CORNER);
    popMatrix();
  }

  boolean isHit(float bx, float by) {
    return (dist(bx, by, x, y) < 35);
  }
}
