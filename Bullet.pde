// Representa o projétil disparado pela torreta do jogador.
// A bala viaja em linha reta baseada no ângulo do cano no instante do disparo.
class Bullet {
  float x, y;
  float velX, velY;
  boolean alive = true;

  Bullet(float angulo, float baseX, float baseY, float tamanhoCano) {
    // Calcula a posição inicial na ponta do cano (escala compensada em 0.65)
    float saidaCano = (25 + tamanhoCano / 2) * 0.65;
    x = baseX + cos(angulo) * saidaCano;
    y = baseY + sin(angulo) * saidaCano;

    // Define vetor de velocidade linear constante
    float velocidade = 9.5;
    velX = cos(angulo) * velocidade;
    velY = sin(angulo) * velocidade;
  }

  // Atualiza posição do projétil e destrói caso saia da tela
  void update() {
    x += velX;
    y += velY;

    if (x < 0 || x > width || y < 0 || y > height) {
      alive = false;
    }
  }

  // Desenha a bala com rastro e efeito incandescente
  void display() {
    // Rastro traseiro
    fill(255, 120, 40, 70);
    ellipse(x - velX * 1.5, y - velY * 1.5, 10, 10);
    
    fill(255, 180, 60, 100);
    ellipse(x - velX, y - velY, 7, 7);

    // Corpo principal da bala
    fill(255, 140, 0, 70);
    circle(x, y, 12);
    
    fill(60);
    stroke(180);
    strokeWeight(1.5);
    ellipse(x, y, 7, 7);

    // Núcleo iluminado
    noStroke();
    fill(255, 220, 120);
    circle(x, y, 3);
    
    fill(255);
    circle(x - 1, y - 1, 1);
  }
}