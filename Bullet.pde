class Bullet {

  float x;
  float y;

  float velX;
  float velY;

  boolean alive = true;

  Bullet(float angulo, float baseX, float baseY, float tamanhoCano) {

    float saidaCano = 25 + tamanhoCano/2;

    x = baseX + cos(angulo) * saidaCano;

    y = baseY + sin(angulo) * saidaCano;

    float velocidade = 12;

    velX = cos(angulo) * velocidade;

    velY = sin(angulo) * velocidade;
  }

  // =========================
  // UPDATE
  // =========================

  void update() {

    x += velX;

    y += velY;

    velY += 0.15;

    if (x < 0 || x > width || y < 0 || y > height) {

      alive = false;
    }
  }

  // =========================
  // DISPLAY
  // =========================

  void display() {

    fill(255, 120, 40, 70);

    ellipse(x - velX * 1.5, y - velY * 1.5, 10, 10);

    fill(255, 180, 60, 100);

    ellipse(x - velX, y - velY, 7, 7);

    fill(255, 140, 0, 70);

    circle(x, y, 12);

    fill(60);

    stroke(180);

    strokeWeight(1.5);

    ellipse(x, y, 7, 7);

    noStroke();

    fill(255, 220, 120);

    circle(x, y, 3);

    fill(255);

    circle(x - 1, y - 1, 1);
  }
}