// Helicóptero — voa horizontalmente e solta paraquedistas periodicamente
class Helicopter extends Enemy {
  float dropTimer;              // contador de frames até o próximo drop
  float dropInterval;           // intervalo entre drops (diminui com as waves)
  boolean movingRight;          // direção do voo
  ArrayList<Parachuter> dropped; // paraquedistas soltos neste frame — Pedro coleta no draw()

  Helicopter(float x, float y) {
    super(x, y, random(1.5, 3.0), 2); // HP fixo em 2
    this.movingRight = (x < width / 2); // vem da esquerda → vai pra direita e vice-versa
    this.dropInterval = random(120, 240);
    this.dropTimer = dropInterval - 60; // começa quase na hora de soltar o primeiro
    this.dropped = new ArrayList<Parachuter>();
  }

  void update() {
    x += movingRight ? speed : -speed; // movimento horizontal
    dropTimer++;

    // solta um paraquedista quando o timer chega no intervalo
    if (dropTimer >= dropInterval) {
      dropTimer = 0;
      dropped.add(new Parachuter(x, y, wave)); // paraquedista herda posição e wave atual
    }

    // sair da tela = escapou, Pedro conecta com sistema de vidas
    if (isOffScreen()) {
      alive = false;
      escaped = true;
    }
  }

  void display() {
    pushMatrix();
    rectMode(CENTER);
    fill(80, 80, 80);
    rect(x, y, 60, 20);         // corpo principal
    fill(60);
    rect(x + 25, y - 5, 20, 8); // cauda
    fill(180, 0, 0);
    ellipse(x, y - 14, 70, 8);  // hélice
    fill(255, 200, 0);
    ellipse(x, y, 10, 10);      // cockpit
    rectMode(CORNER);
    popMatrix();
  }

  // usado pelo João para checar colisão com balas
  boolean isHit(float bx, float by) {
    return (dist(bx, by, x, y) < 35);
  }
}
