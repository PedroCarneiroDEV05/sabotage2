// Controla a torre de defesa (canhão antiaéreo) operada pelo jogador.
// Gerencia posição, rotação do cano (mirar), lógica de disparo e renderização.
class Player {
  float angulo = -PI/2;
  float velocidadeRotacao = 0.02;

  float baseX;
  float baseY;
  float tamanhoCano = 55;

  int ultimoTiro = 0;
  int cooldown = 250; // Tempo mínimo entre disparos em milissegundos

  Player() {
    baseX = width / 2;
    // O domo fica alinhado ao solo com base no fator de escala (0.65)
    baseY = height - 56.25;
  }

  void update() {
    controlarMira();
  }

  // Registra e processa um novo disparo se o cooldown for respeitado
  Bullet shoot() {
    if (millis() - ultimoTiro >= cooldown) {
      ultimoTiro = millis();
      return new Bullet(angulo, baseX, baseY, tamanhoCano);
    }
    return null;
  }

  // Lê entrada do teclado (A/D) e ajusta a rotação do cano limitando ângulos
  void controlarMira() {
    if (keyPressed) {
      if (key == 'a' || key == 'A') angulo -= velocidadeRotacao;
      if (key == 'd' || key == 'D') angulo += velocidadeRotacao;
    }
    // Restringe o canhão entre -180 e 0 graus (meio círculo superior)
    angulo = constrain(angulo, -PI + 0.3, -0.3);
  }

  void display() {
    drawCannonAt(baseX, baseY, 0.65, angulo);
  }

  // Renderiza a estrutura da base e o cano dinâmico.
  // Separado em método auxiliar para permitir reuso no menu principal e manter a coesão visual.
  void drawCannonAt(float x, float y, float scaleFactor, float currentAngle) {
    pushMatrix();
    translate(x, y);
    scale(scaleFactor);

    // ==========================================
    // ESTRUTURA BLINDADA (BASE)
    // ==========================================
    fill(0, 32, 14, 220);
    stroke(0, 255, 120);
    strokeWeight(2.5);
    
    // Suportes laterais chanfrados
    beginShape();
    vertex(-110, 90); vertex(-82, 25); vertex(-50, 25); vertex(-50, 90);
    endShape(CLOSE);
    
    beginShape();
    vertex(50, 90); vertex(50, 25); vertex(82, 25); vertex(110, 90);
    endShape(CLOSE);

    // Bloco central principal
    rectMode(CORNERS);
    rect(-50, 25, 50, 90, 2);
    
    // Detalhes industriais (painéis e rebites)
    stroke(0, 255, 120, 100);
    strokeWeight(1.5);
    line(-25, 30, -25, 85);
    line(25, 30, 25, 85);
    line(-45, 55, 45, 55);
    
    noStroke();
    fill(0, 255, 120);
    ellipse(-75, 45, 4, 4); ellipse(-65, 75, 4, 4);
    ellipse(75, 45, 4, 4); ellipse(65, 75, 4, 4);
    ellipse(-38, 42, 3, 3); ellipse(38, 42, 3, 3);
    ellipse(-38, 68, 3, 3); ellipse(38, 68, 3, 3);

    // ==========================================
    // DOMO SUPERIOR E CANO GIRATÓRIO
    // ==========================================
    noFill();
    stroke(0, 255, 100, 25);
    strokeWeight(10);
    arc(0, 25, 150, 150, PI, TWO_PI);
    stroke(0, 255, 100, 55);
    strokeWeight(6);
    arc(0, 25, 150, 150, PI, TWO_PI);

    stroke(0, 255, 120);
    strokeWeight(3.5);
    fill(0, 45, 18, 140);
    arc(0, 25, 150, 150, PI, TWO_PI);
    line(-75, 25, 75, 25); 

    fill(0, 70, 25, 200);
    stroke(0, 220, 100);
    strokeWeight(2);
    rectMode(CENTER);
    rect(0, 15, 60, 20, 4);

    pushMatrix();
    rotate(currentAngle);

    noFill();
    stroke(0, 255, 100, 40);
    strokeWeight(8);
    rect(25, 0, tamanhoCano, 16, 4);

    fill(0, 50, 20, 160);
    stroke(0, 255, 120);
    strokeWeight(2.5);
    rect(25, 0, tamanhoCano, 16, 4);

    fill(0, 255, 120);
    rect(25, 0, tamanhoCano - 15, 3, 2);

    fill(0, 40, 15);
    stroke(0, 255, 120);
    ellipse(25 + tamanhoCano/2, 0, 16, 16);
    fill(0, 255, 120);
    ellipse(25 + tamanhoCano/2, 0, 6, 6);

    popMatrix();
    rectMode(CORNER);
    popMatrix();
  }
}