class Enemy {
  float x, y;
  float speed;
  int hp;
  boolean alive;
  boolean escaped;

  Enemy(float x, float y, float speed, int hp) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.hp = hp;
    this.alive = true;
    this.escaped = false;
  }

  void update() {}

  void display() {}

  void takeDamage(int dmg) {
    hp -= dmg;
    if (hp <= 0) alive = false;
  }

  boolean isOffScreen() {
    return (x < -100 || x > width + 100 || y > height + 100);
  }
}

// === SPAWN / DIFICULDADE ===

int wave = 1;
int spawnTimer = 0;
int spawnInterval = 300;

void updateSpawn(ArrayList<Helicopter> helicopters) {
  spawnTimer++;
  if (spawnTimer >= spawnInterval) {
    spawnTimer = 0;
    if (helicopters.size() < 5) {
      spawnHelicopter(helicopters);
    }
  }
}

void spawnHelicopter(ArrayList<Helicopter> helicopters) {
  float spawnX = (random(1) > 0.5) ? -60 : width + 60;
  float spawnY = random(40, 160);

  Helicopter h = new Helicopter(spawnX, spawnY);

  h.speed += 0.3 * min(wave - 1, 19);

  float di = max(80, h.dropInterval - 20 * min(wave - 1, 14));
  if (wave == 10) di = max(di, 115);
  h.dropInterval = di;
  h.dropTimer = h.dropInterval - 60;

  helicopters.add(h);
}

void increaseWave() {
  wave++;
  spawnInterval = max(150, spawnInterval - 20);
}
