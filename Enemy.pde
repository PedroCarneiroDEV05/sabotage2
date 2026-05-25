// Classe base abstrata para todos os inimigos do jogo.
// Define atributos fundamentais de física e estado (vida, velocidade, status de fuga),
// além de métodos comuns para processamento de dano.
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

  // Métodos implementados pelas subclasses (Helicopter, Parachuter)
  void update() {}
  void display() {}

  // Aplica dano ao inimigo e atualiza seu estado de vida
  void takeDamage(int dmg) {
    hp -= dmg;
    if (hp <= 0) alive = false;
  }

  // Verifica se a entidade ultrapassou as margens limites da tela
  boolean isOffScreen() {
    return (x < -100 || x > width + 100 || y > height + 100);
  }
}
