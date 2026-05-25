// Inimigo aéreo primário. Percorre a tela horizontalmente em linha reta
// e gera paraquedistas (Parachuter) baseados no seu contador interno.
class Helicopter extends Enemy {
  float dropTimer;
  float dropInterval;
  boolean movingRight;
  ArrayList<Parachuter> dropped;

  Helicopter(float x, float y) {
    super(x, y, random(1.2, 2.2), 2);
    this.movingRight = (x < width / 2);
    this.dropInterval = random(120, 240);
    this.dropTimer = dropInterval - 60;
    this.dropped = new ArrayList<Parachuter>();
  }

  // Atualiza física horizontal e avalia o lançamento de paraquedistas.
  void update() {
    x += movingRight ? speed : -speed;
    dropTimer++;

    // Garante que o drop ocorra apenas dentro da zona segura (visível) da tela
    if (dropTimer >= dropInterval) {
      if (x >= 55 && x <= width - 55) {
        dropTimer = 0;
        dropped.add(new Parachuter(x, y, wave));
      }
    }

    // Helicópteros que ultrapassam a tela contam como escapados (alive = false, escaped = true)
    if (isOffScreen()) {
      alive = false;
      escaped = true;
    }
  }

  // Verifica colisão radial do projétil com o chassi do helicóptero
  boolean isHit(float bx, float by) {
    return (dist(bx, by, x, y) < 48);
  }

  // Renderiza a entidade completa com efeitos de rotação na hélice principal e cauda.
  void display() {
    pushMatrix();
    translate(x, y);

    // Espelha o helicóptero horizontalmente dependendo da direção
    if (movingRight) scale(-2.0, 2.0);
    else scale(2.0, 2.0);

    rectMode(CENTER);
    noStroke();

    // Fuselagem central
    fill(0, 40, 15, 140);
    stroke(0, 255, 120);
    strokeWeight(2);
    rect(0, 0, 50, 18, 5);

    // Cockpit dianteiro
    fill(0, 255, 120, 180);
    noStroke();
    arc(-15, -2, 18, 14, HALF_PI, PI + HALF_PI);

    // Componente de cauda
    fill(0, 40, 15, 140);
    stroke(0, 255, 120);
    strokeWeight(2);
    rect(25, -4, 20, 6, 2);
    rect(35, -9, 4, 12, 1);

    // Trem de pouso
    noFill();
    stroke(0, 255, 120);
    strokeWeight(2);
    line(-15, 9, -15, 14);
    line(15, 9, 15, 14);
    line(-22, 14, 22, 14);

    // Rotor principal (Geração dinâmica via frameCount)
    stroke(0, 255, 120);
    strokeWeight(2);
    line(0, -9, 0, -14);
    
    float rotorW = cos(frameCount * 0.7) * 65;
    stroke(0, 255, 100, 220);
    strokeWeight(2.5);
    line(-rotorW/2, -14, rotorW/2, -14);
    
    stroke(0, 255, 100, 80);
    line(-rotorW/2, -16, -rotorW/2, -12);
    line(rotorW/2, -16, rotorW/2, -12);

    // Rotor de cauda 
    stroke(0, 255, 120);
    strokeWeight(1.5);
    float tailRotorR = sin(frameCount * 0.9) * 12;
    line(35, -9, 35 + tailRotorR, -9 + tailRotorR);
    line(35, -9, 35 - tailRotorR, -9 - tailRotorR);

    noStroke();
    rectMode(CORNER);
    popMatrix();
  }
}
