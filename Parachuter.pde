// Inimigo terrestre secundário. Lançado pelos helicópteros, cai até o solo.
// Ao tocar o chão, inicia marcha retilínea em direção à base central do jogador.
class Parachuter extends Enemy {
  boolean landed; 
  float landY;

  Parachuter(float x, float y, int currentWave) {
    // O valor de vida escala baseado na wave em que o paraquedista é gerado,
    // variando de 1 HP em níveis iniciais até 4 HP nas waves tardias (20+)
    super(x, y, 1.0,
      currentWave >= 20 ? 4 :
      currentWave >= 9  ? 3 :
      currentWave >= 6  ? 2 : 1
    );
    this.landed = false;
    this.landY = height - 40;
    this.escaped = false;
  }

  // Atualiza física de queda livre (até landY) e posterior caminhada para o centro.
  void update() {
    if (!landed) {
      y += speed;
      if (y >= landY) {
        landed = true;
        y = landY;
        if (gameState == PLAYING) {
          playParachuterLandingSound();
        }
      }
    } else {
      float centerX = width / 2;
      if (x < centerX) {
        x += speed * 0.8;
      } else {
        x -= speed * 0.8;
      }

      // Consome a entidade se ela colidir com as coordenadas da base (margem 15px)
      if (abs(x - centerX) < 15) {
        alive = false;
        escaped = true;
      }
    }
  }

  // Define lógica de hitbox composta baseada no estado de queda
  boolean isHit(float bx, float by) {
    // Raio de impacto central do corpo
    boolean hitBody = dist(bx, by, x, y - 5) < 24;
    
    if (!landed) {
      // Quando em queda, inclui hitbox extra representativa da cobertura do tecido (paraquedas)
      boolean hitParachute = dist(bx, by, x, y - 45) < 36;
      return hitBody || hitParachute;
    } else {
      return hitBody;
    }
  }

  // Renderiza formas que compõe o soldado e o paraquedas. Alterna postura ao tocar no solo.
  void display() {
    pushMatrix();
    translate(x, y);
    scale(1.6); 

    rectMode(CENTER);

    // Tecido do paraquedas e tirantes (Somente ativado durante a queda)
    if (!landed) {
      noFill();
      stroke(0, 255, 100, 30);
      strokeWeight(4);
      arc(0, -28, 46, 30, PI, TWO_PI);

      stroke(0, 255, 120);
      strokeWeight(2.0);
      fill(0, 50, 20, 100); 
      arc(0, -28, 46, 30, PI, TWO_PI);
      line(-23, -28, 23, -28); 

      stroke(0, 255, 100, 180);
      strokeWeight(1.0);
      line(-20, -28, -10, -6); 
      line(20, -28, 10, -6); 
    }

    // Corpo central do soldado
    noStroke();
    fill(0, 255, 120);
    ellipse(0, -12, 8, 8); 
    rect(0, -3, 6, 10, 1);

    // Gestos dos braços baseados no estado aéreo/terrestre
    if (!landed) {
      stroke(0, 255, 120);
      strokeWeight(2);
      line(0, -6, -10, -6);
      line(0, -6, 10, -6);
      noStroke();
    } else {
      rect(-5, -4, 4, 2, 1);
      rect(5, -4, 4, 2, 1);
    }

    // Animação rítmica das pernas durante caminhada (calculada globalmente via frameCount)
    if (!landed) {
      rect(-2, 5, 2, 6);
      rect(2, 5, 2, 6);
    } else {
      float step = sin(frameCount * 0.25);
      if (step > 0) {
        rect(-3, 5, 2, 6);
        rect(1, 3, 2, 4);
      } else {
        rect(-1, 3, 2, 4);
        rect(3, 5, 2, 6);
      }
    }

    rectMode(CORNER);
    popMatrix();
  }
}
