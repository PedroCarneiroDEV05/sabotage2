// Paraquedista — cai do helicóptero e caminha pelo chão em direção ao centro da tela
class Parachuter extends Enemy {
  boolean landed; // false = caindo | true = andando no chão
  float landY;    // altura do chão

  Parachuter(float x, float y, int currentWave) {
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
  }

  void update() {
    if (!landed) {
      // caindo verticalmente até o chão
      y += speed;
      if (y >= landY) {
        landed = true;
        y = landY;
        playParachuterLandingSound(); 
      }
    } else {
      // após pousar, anda sempre em direção ao centro da tela
      float centerX = width / 2;
      if (x < centerX) {
        x += speed * 0.8; // à esquerda do centro → anda pra direita
      } else {
        x -= speed * 0.8; // à direita do centro → anda pra esquerda
      }
      // se sair da tela = escapou, Pedro conecta com sistema de vidas
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
      line(x - 20, y - 10, x, y); // corda esquerda
      line(x + 20, y - 10, x, y); // corda direita
      noStroke();
    }
    // corpo do paraquedista
    fill(50, 100, 50);
    ellipse(x, y - 8, 14, 14); // cabeça
    rect(x - 6, y, 12, 18);    // corpo
  }

  // usado pelo João para checar colisão com balas
  boolean isHit(float bx, float by) {
    return (dist(bx, by, x, y) < 15);
  }
}
