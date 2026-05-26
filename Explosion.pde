// Gerenciador de explosões. Mantém e atualiza o ciclo de vida
// de um grupo de partículas isoladas.
class Explosion {
  ArrayList<Particle> particles;

  Explosion(float x, float y) {
    particles = new ArrayList<Particle>();
    // Gera uma quantidade controlada de detritos para manter performance
    for (int i = 0; i < 30; i++) {
      particles.add(new Particle(x, y));
    }
  }

  // Atualiza física e gerencia a remoção segura de partículas apagadas
  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  // Renderiza todas as partículas ativas
  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }

  // Verifica se o efeito terminou totalmente
  boolean isFinished() {
    return particles.isEmpty();
  }
}

// Representa um fragmento unitário da explosão.
// Possui física de atrito, gravidade leve e brilho arcade (CRT).
class Particle {
  PVector position;
  PVector velocity;
  float lifespan;

  Particle(float x, float y) {
    position = new PVector(x, y);
    // Dispara a partícula em um ângulo aleatório com velocidade inicial variável
    float angle = random(TWO_PI);
    float speed = random(1, 6); 
    velocity = new PVector(cos(angle) * speed, sin(angle) * speed);
    lifespan = 255; 
  }

  // Aplica fricção, gravidade e dissipa a energia da partícula ao longo do tempo
  void update() {
    position.add(velocity);
    
    // Fricção (Desaceleração gradual simulando dissipação de energia)
    velocity.mult(0.95);
    
    // Gravidade sutil simulando o peso dos estilhaços caindo
    velocity.y += 0.15;
    
    // O fade-out consome o tempo de vida da partícula
    lifespan -= 8; 
  }

  // Desenha a partícula em duas camadas (Glow externo translúcido e núcleo sólido)
  void display() {
    noStroke();
    
    // Camada 1: Aura/brilho translúcido (Laranja neon intenso)
    fill(255, 120, 0, lifespan * 0.4); 
    circle(position.x, position.y, 9); 
    
    // Camada 2: Núcleo denso e brilhante (Amarelo elétrico)
    fill(255, 220, 100, lifespan); 
    circle(position.x, position.y, 4); 
  }

  // Informa ao gerenciador se a partícula já dissipou totalmente
  boolean isDead() {
    return lifespan < 0;
  }
}
