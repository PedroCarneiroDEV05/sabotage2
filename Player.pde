class Player {

  float angulo = -PI/2;
  float velocidadeRotacao = 0.02;

  float baseX;
  float baseY;

  float tamanhoCano = 55;

  int ultimoTiro = 0;
  int cooldown = 250;

  Player() {

    baseX = width/2;
    baseY = height - 90;
  }

  // =========================
  // UPDATE
  // =========================

  void update() {

    controlarMira();
  }

  // =========================
  // DISPLAY
  // =========================

  void display() {

    desenharCanhao();
  }

  // =========================
  // TIRO
  // =========================

  void shoot() {

    if (millis() - ultimoTiro >= cooldown) {

      bullets.add(new Bullet(angulo, baseX, baseY, tamanhoCano));

      ultimoTiro = millis();
    }
  }

  // =========================
  // CONTROLE
  // =========================

  void controlarMira() {

    if (keyPressed) {

      if (key == 'a' || key == 'A') {
        angulo -= velocidadeRotacao;
      }

      if (key == 'd' || key == 'D') {
        angulo += velocidadeRotacao;
      }
    }

    angulo = constrain(angulo, -PI + 0.3, -0.3);
  }

  // =========================
  // DESENHAR
  // =========================

  void desenharCanhao() {

    pushMatrix();

    translate(baseX, baseY);

    scale(0.65);

    noStroke();

    fill(0, 80);

    ellipse(0, 25, 170, 35);

    fill(40);

    ellipse(-45, 10, 45, 45);

    ellipse(45, 10, 45, 45);

    fill(120);

    ellipse(-45, 10, 18, 18);

    ellipse(45, 10, 18, 18);

    fill(70);

    stroke(120);

    strokeWeight(2);

    rectMode(CENTER);

    rect(0, -5, 120, 35, 10);

    fill(100);

    rect(0, -15, 90, 10, 5);

    fill(90);

    ellipse(0, -10, 35, 35);

    pushMatrix();

    rotate(angulo);

    noStroke();

    fill(20, 100);

    rect(25, 8, tamanhoCano, 10, 5);

    fill(130);

    stroke(180);

    strokeWeight(2);

    rect(25, 0, tamanhoCano, 18, 8);

    fill(200, 200, 220);

    rect(25, -4, tamanhoCano - 12, 3, 3);

    fill(90);

    ellipse(25 + tamanhoCano/2, 0, 18, 18);

    fill(40);

    ellipse(25 + tamanhoCano/2, 0, 7, 7);

    popMatrix();

    popMatrix();
  }
}