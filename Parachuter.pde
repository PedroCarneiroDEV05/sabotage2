// Paraquedista — cai do helicóptero e caminha pelo chão até sair da tela
class Parachuter extends Enemy {
  boolean landed; // false = caindo | true = andando no chão
  float landY;    // altura do chão
  boolean movingRight;

  Parachuter(float x, float y, int currentWave, boolean movingRight) {
    // HP aumenta progressivamente por tier de wave:
    // wave  1-5  → 1 HP
    // wave  6-8  → 2 HP
    // wave  9-19 → 3 HP (antecipado pra wave 9 pra suavizar spike da 10)
    // wave 20+   → 4 HP (compensa o spawn alto das waves tardias)
    super(x, y, 1.2,
      currentWave >= 20 ? 4 :
      currentWave >= 9  ? 3 :
      currentWave >= 6  ? 2 : 1
    );
    this.landed = false;
    this.landY = height - 40;
    this.escaped = false;
    this.movingRight = movingRight;
  }

  void update() {
    if (!landed) {
      // caindo
      y += speed;
      if (y >= landY) {
        landed = true;
        y = landY;
      }
    } else {
      // andando no chão após pousar
      x += movingRight ? speed * 0.8 : -speed * 0.8;
      // sair pela lateral = escapou, conta como dano ao jogador
      if (x < -20 || x > width + 20) {
        alive = false;
        escaped = true;
      }
    }
  }

  void display() {
    noStroke();
    // paraquedas — só aparece enquanto está no ar
    if (!landed) {
      fill(255, 255, 255, 180);
      arc(x, y - 30, 50, 40, PI, TWO_PI);
      stroke(200);
      line(x - 20, y - 10, x, y);
      line(x + 20, y - 10, x, y);
      noStroke();
    }
    // corpo do paraquedista
    fill(50, 100, 50);
    ellipse(x, y - 8, 14, 14); // cabeça
    rect(x - 6, y, 12, 18);    // corpo
  }

  // check de colisão das balas
  boolean isHit(float bx, float by) {
    return (dist(bx, by, x, y) < 15);
  }
}
