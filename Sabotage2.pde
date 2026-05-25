/**
 * Sabotage 2 - Arquivo Principal (Main Controller)
 * 
 * Este é o coração arquitetural do jogo. Responsável por inicializar 
 * os sistemas isolados (Player, Áudio, Ranking), controlar a máquina 
 * de estados finitos global (Menus, Gameplay, Game Over) e orquestrar 
 * o Game Loop primário (Update e Render).
 *
 * A arquitetura foi construída visando a separação estrita de lógicas 
 * matemáticas (updateSystems) das lógicas visuais e vetoriais (renderSystems).
 */
import processing.sound.*;// ==========================================
// CONSTANTES E ESTADOS DO JOGO
// ==========================================
final int MENU = 0;
final int PLAYING = 1;
final int GAME_OVER = 2;
final int RANKING = 3;
final int PAUSED = 4;
final int RANKING_CHOICE = 5;
final int NAME_INPUT = 6;

int gameState = MENU;

// ==========================================
// VARIÁVEIS GLOBAIS DE GAMEPLAY
// ==========================================
int score = 0;
int playerLives = 3;
int gameTime = 0;
int gameDifficulty = 1;

int wave = 1;
int spawnTimer = 0;
int spawnInterval = 360; 

boolean useRanking = false;
String playerNameInput = "";

RankingSystem rankingSystem;

// ==========================================
// LISTAS DE ENTIDADES E OBJETOS PRINCIPAIS
// ==========================================
ArrayList<Bullet> bullets;
ArrayList<Helicopter> helicopters;
ArrayList<Parachuter> parachuters;
ArrayList<Explosion> explosions;

Player player; 
Helicopter menuHeli; 
Parachuter menuPara; 

// ==========================================
// DEBUG E CONTROLE DE ESTADO
// ==========================================
boolean debugMode = false;
int transitionAlpha = 0;
boolean gameRunning = false;

// ==========================================
// SETUP & INICIALIZAÇÃO
// ==========================================
void setup() {
  size(1000, 700);
  bullets = new ArrayList<Bullet>();
  helicopters = new ArrayList<Helicopter>();
  parachuters = new ArrayList<Parachuter>();
  explosions = new ArrayList<Explosion>();
  
  player = new Player();
  initSounds();
  rankingSystem = new RankingSystem();
  
  initializeGame();
}

void initializeGame() {
  score = 0;
  playerLives = 3;
  gameTime = 0;
  gameDifficulty = 1;
  wave = 1;
  spawnTimer = 0;
  spawnInterval = 360; 
}

void restartGame() {
  stopHelicopterSound(); 
  initializeGame();
  
  bullets.clear();
  helicopters.clear();
  parachuters.clear();
  explosions.clear();
  
  player = new Player();
  gameRunning = false;
  gameState = MENU;
}

// ==========================================
// LOOP PRINCIPAL DO JOGO
// ==========================================
void draw() {
  background(0);

  switch(gameState) {
    case MENU: drawMenu(); break;
    case PLAYING: runGame(); break;
    case GAME_OVER: drawGameOver(); break;
    case RANKING: drawRanking(); break;
    case PAUSED: drawPauseMenu(); break;
    case RANKING_CHOICE: drawRankingChoice(); break;
    case NAME_INPUT: drawNameInput(); break;
  }
}

void runGame() {
  if (!gameRunning) return;
  updateSystems();
  checkCollisions();
  renderSystems();
  renderHUD();
}

// ==========================================
// LÓGICA E FÍSICA DOS SISTEMAS
// ==========================================
void updateSystems() {
  if (frameCount % 10 == 0) score++;
  gameTime++;

  // Progressão linear de dificuldade (Novas waves a cada 45 segundos / 2700 frames)
  if (gameTime > 0 && gameTime % 2700 == 0) {
    increaseWave();
    gameDifficulty = wave;
  }

  updateSpawn(helicopters);

  for (int i = helicopters.size() - 1; i >= 0; i--) {
    Helicopter h = helicopters.get(i);
    h.update();

    // Transfere os paraquedistas lançados para a lista principal
    if (h.dropped.size() > 0) {
      parachuters.addAll(h.dropped);
      h.dropped.clear();
    }

    if (!h.alive) {
      helicopters.remove(i);
    }
  }

  for (int i = parachuters.size() - 1; i >= 0; i--) {
    Parachuter p = parachuters.get(i);
    p.update();

    if (!p.alive) {
      if (p.escaped) playerLives--;
      parachuters.remove(i);
    }
  }

  if (playerLives <= 0) {
    if (useRanking) {
      rankingSystem.addScore(playerNameInput, score);
    }
    gameState = GAME_OVER;
  }

  player.update();

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    if (!b.alive) bullets.remove(i);
  }

  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion e = explosions.get(i);
    e.update();
    if (e.isFinished()) explosions.remove(i);
  }
}

void checkCollisions() {
  // Iteração de trás para frente evita ConcurrentModificationException 
  // durante remoção simultânea de projéteis e inimigos
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);

    // 1. Projétil vs Helicópteros
    for (int j = helicopters.size() - 1; j >= 0; j--) {
      Helicopter h = helicopters.get(j);
      if (h.alive && h.isHit(b.x, b.y)) {
        b.alive = false;
        h.takeDamage(1); 
        
        if (!h.alive) {
          playHelicopterExplosionSound(); 
          explosions.add(new Explosion(h.x, h.y));
          score += 100;
        }
        break;
      }
    }
    
    if (!b.alive) continue;

    // 2. Projétil vs Paraquedistas
    for (int k = parachuters.size() - 1; k >= 0; k--) {
      Parachuter p = parachuters.get(k);
      if (p.alive && p.isHit(b.x, b.y)) {
        b.alive = false; 
        p.takeDamage(1); 
        
        if (!p.alive) {
          playParachuterExplodeSound();
          explosions.add(new Explosion(p.x, p.y));
          score += 50; 
        }
        break;
      }
    }
  }
}

// ==========================================
// SISTEMA DE SPAWN
// ==========================================
void updateSpawn(ArrayList<Helicopter> hList) {
  spawnTimer++;

  if (spawnTimer >= spawnInterval) {
    spawnTimer = 0;
    // O número máximo de helicópteros em tela acompanha a wave
    int maxHelis = min(8, wave);
    if (hList.size() < maxHelis) {
      spawnHelicopter(hList);
    }
  }
}

void spawnHelicopter(ArrayList<Helicopter> hList) {
  float spawnX = (random(1) > 0.5) ? -60 : width + 60;
  float spawnY = random(40, 160);

  Helicopter h = new Helicopter(spawnX, spawnY);
  h.speed += 0.08 * min(wave - 1, 20);

  // Reduz gradualmente o intervalo entre drops conforme a wave avança
  float di = max(90, 360 - 35 * (wave - 1));
  h.dropInterval = di;
  h.dropTimer = h.dropInterval - 45; 

  hList.add(h);
}

void increaseWave() {
  wave++;
  spawnInterval = max(80, 360 - 40 * (wave - 1));
}

// ==========================================
// CONTROLES DE ENTRADA DO JOGADOR
// ==========================================
void keyPressed() {
  if (gameState == MENU) {
    if (keyCode == ENTER) {
      gameState = RANKING_CHOICE;
      playShootSound(); 
      return;
    }
  }

  if (gameState == RANKING_CHOICE) {
    if (key == '1') {
      useRanking = true;
      playerNameInput = "";
      gameState = NAME_INPUT;
      playShootSound();
    } else if (key == '2') {
      useRanking = false;
      playerNameInput = "CONVIDADO";
      gameRunning = true;
      gameState = PLAYING;
      playShootSound();
    } else if (keyCode == ESC) {
      key = 0;
      gameState = MENU;
    }
    return;
  }

  if (gameState == NAME_INPUT) {
    if (keyCode == ENTER) {
      if (playerNameInput.trim().length() > 0) {
        gameRunning = true;
        gameState = PLAYING;
        playShootSound();
      }
    } else if (keyCode == BACKSPACE) {
      if (playerNameInput.length() > 0) {
        playerNameInput = playerNameInput.substring(0, playerNameInput.length() - 1);
        playParachuterLandingSound(); 
      }
    } else if (keyCode == ESC) {
      key = 0;
      gameState = RANKING_CHOICE;
    } else {
      char c = Character.toUpperCase(key);
      if (playerNameInput.length() < 10 && c >= 'A' && c <= 'Z') {
        playerNameInput += c;
        playShootSound(); 
      }
    }
    return;
  }

  if (key == 'p' || key == 'P') {
    if (gameState == PLAYING) gameState = PAUSED;
    else if (gameState == PAUSED) gameState = PLAYING;
  }

  if (key == 'r' || key == 'R') {
    restartGame();
  }

  if (keyCode == TAB) {
    if (gameState == MENU) gameState = RANKING;
  }

  if (keyCode == ESC) {
    key = 0;
    if (gameState == RANKING || gameState == PAUSED) {
      gameState = MENU;
    }
  }

  if (key == 'f' || key == 'F') {
    debugMode = !debugMode;
    playShootSound();
  }

  if (key == ' ' && gameState == PLAYING) {
    Bullet newBullet = player.shoot();
    if (newBullet != null) {
      bullets.add(newBullet);
      playShootSound();
    }
  }
}

// ==========================================
// RENDERIZAÇÃO (MÉTODOS VISUAIS E TELAS)
// ==========================================

void renderSystems() {
  background(0);

  // Grade de fundo fósforo verde
  stroke(0, 30, 10);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  for (Bullet b : bullets) b.display();
  player.display();
  for (Helicopter h : helicopters) h.display();
  for (Parachuter p : parachuters) p.display();
  for (Explosion e : explosions) e.display();

  // Chão iluminado
  float groundY = height - 40;
  stroke(0, 255, 100, 30);
  strokeWeight(6);
  line(0, groundY, width, groundY);
  
  stroke(0, 255, 120);
  strokeWeight(2.5);
  line(0, groundY, width, groundY);
  
  stroke(0, 180, 80);
  strokeWeight(1.5);
  line(0, groundY + 6, width, groundY + 6);
  
  stroke(0, 80, 35, 150);
  strokeWeight(1.5);
  for (int xPos = 0; xPos < width; xPos += 15) {
    line(xPos, groundY + 8, xPos, height);
  }
  noStroke();

  // Scanlines CRT globais
  stroke(0, 18);
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) {
    line(0, y, width, y);
  }
  noStroke();
}

void renderHUD() {
  rectMode(CORNER);
  textAlign(LEFT);
  textSize(20);

  drawGlowText("SCORE: " + score, 40, 35, color(0, 255, 120));

  color livesValColor = color(0, 255, 120);
  if (playerLives == 1) {
    if ((frameCount / 20) % 2 == 0) livesValColor = color(255, 50, 50); 
  }
  
  drawGlowText("VIDAS: ", 250, 35, color(0, 255, 120));
  drawGlowText(String.valueOf(playerLives), 325, 35, livesValColor);

  drawGlowText("WAVE: " + wave, 460, 35, color(0, 255, 120));

  int seg = (gameTime / 60) % 60;
  int min = (gameTime / 3600);
  drawGlowText("TEMPO: " + nf(min, 2) + ":" + nf(seg, 2), 640, 35, color(0, 255, 120));

  drawGlowText("FPS: " + int(frameRate), 880, 35, color(0, 180, 80));

  if (debugMode) {
    textSize(16);
    drawGlowText("DEBUG MODE", 40, 70, color(255, 180, 0));
    drawGlowText("HELICOPTERS: " + helicopters.size(), 200, 70, color(255, 180, 0));
    drawGlowText("PARACHUTERS: " + parachuters.size(), 420, 70, color(255, 180, 0));
    drawGlowText("BULLETS: " + bullets.size(), 640, 70, color(255, 180, 0));
  }
}

void drawGlowText(String txt, float x, float y, color c) {
  fill(red(c), green(c), blue(c), min(alpha(c), 40));
  text(txt, x - 1, y); text(txt, x + 1, y);
  text(txt, x, y - 1); text(txt, x, y + 1);
  fill(c);
  text(txt, x, y);
}

void drawMenu() {
  background(0);

  stroke(0, 35, 12);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  if (menuHeli == null || !menuHeli.alive) {
    boolean fromLeft = random(1) > 0.5;
    menuHeli = new Helicopter(fromLeft ? -80 : width + 80, 80);
    menuHeli.speed = 1.6; 
    menuHeli.movingRight = fromLeft;
  }
  menuHeli.update();
  menuHeli.display();

  if (menuPara == null || !menuPara.alive) {
    menuPara = new Parachuter(random(150, width - 150), 60, 1);
    menuPara.speed = 0.9;
  }
  menuPara.update();
  menuPara.display();

  textAlign(CENTER);
  
  textSize(110);
  fill(0, 255, 100, 20);
  text("SABOTAGE 2", width / 2 + 2, height / 2 - 178);
  text("SABOTAGE 2", width / 2 - 2, height / 2 - 182);
  fill(0, 255, 100, 50);
  text("SABOTAGE 2", width / 2 + 1, height / 2 - 179);
  fill(0, 255, 120);
  text("SABOTAGE 2", width / 2, height / 2 - 180);

  float menuAngulo = -PI/2 + sin(frameCount * 0.018) * 1.1; 
  player.drawCannonAt(width / 2, height / 2 + 65, 0.9, menuAngulo);

  noStroke();
  fill(0, 180, 80);
  textSize(18);
  text("P = Pausar | TAB = Ranking", width / 2, height - 50);
  fill(0, 140, 60);
  text("Os Rapazes Studio", width / 2, height - 20);

  float pulseAlpha = 110 + 115 * sin(frameCount * 0.08);
  fill(0, 255, 100, pulseAlpha);
  textSize(26);
  text("Pressione ENTER para começar", width / 2, height - 100);

  stroke(0, 22); 
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) line(0, y, width, y);
  noStroke();
}

void drawRankingChoice() {
  background(0);

  stroke(0, 35, 12);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  fill(0, 15, 5, 235); 
  stroke(0, 255, 120, 90);
  strokeWeight(5);
  rect(width / 2 - 300, height / 2 - 200, 600, 400, 16);
  
  noFill();
  stroke(0, 255, 120, 200);
  strokeWeight(2);
  rect(width / 2 - 294, height / 2 - 194, 588, 388, 12);
  noStroke();

  textAlign(CENTER);
  textSize(46);
  drawGlowText("MODO DE JOGO", width / 2, height / 2 - 130, color(0, 255, 120));

  stroke(0, 200, 90, 150);
  strokeWeight(2);
  line(width / 2 - 220, height / 2 - 100, width / 2 + 220, height / 2 - 100);
  noStroke();

  textSize(24);
  rectMode(CENTER);
  
  fill(0, 45, 18, 160);
  stroke(0, 255, 120, 120);
  strokeWeight(1.8);
  rect(width / 2, height / 2 - 40, 400, 54, 8);
  noStroke();
  drawGlowText("[1] REGISTRAR PILOTO", width / 2, height / 2 - 32, color(0, 255, 120));

  fill(0, 45, 18, 160);
  stroke(0, 255, 120, 120);
  strokeWeight(1.8);
  rect(width / 2, height / 2 + 40, 400, 54, 8);
  noStroke();
  drawGlowText("[2] JOGAR COMO CONVIDADO", width / 2, height / 2 + 48, color(0, 255, 120));

  rectMode(CORNER);
  textSize(18);
  drawGlowText("Pressione ESC para voltar ao Menu Principal", width / 2, height / 2 + 145, color(0, 150, 60));

  stroke(0, 20);
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) line(0, y, width, y);
  noStroke();
}

void drawNameInput() {
  background(0);

  stroke(0, 35, 12);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  stroke(0, 255, 120, 80);
  strokeWeight(5);
  noFill();
  rect(width / 2 - 300, height / 2 - 200, 600, 400, 16);
  stroke(0, 255, 120, 180);
  strokeWeight(2);
  rect(width / 2 - 294, height / 2 - 194, 588, 388, 12);
  noStroke();

  textAlign(CENTER);
  textSize(42);
  drawGlowText("REGISTRO DE PILOTO", width / 2, height / 2 - 130, color(0, 255, 120));

  stroke(0, 200, 90, 150);
  strokeWeight(2);
  line(width / 2 - 220, height / 2 - 100, width / 2 + 220, height / 2 - 100);
  noStroke();

  textSize(22);
  drawGlowText("INSIRA SUA IDENTIFICAÇÃO (MAX 10 LETRAS)", width / 2, height / 2 - 50, color(0, 200, 80));

  fill(0, 35, 12, 200);
  stroke(0, 255, 120);
  strokeWeight(2.5);
  rectMode(CENTER);
  rect(width / 2, height / 2 + 20, 350, 65, 8);
  noStroke();

  textSize(34);
  String showName = playerNameInput;
  if ((frameCount / 20) % 2 == 0) showName += "_";
  else showName += " ";
  drawGlowText(showName, width / 2, height / 2 + 30, color(0, 255, 120));

  rectMode(CORNER);
  textSize(18);
  drawGlowText("Letras A-Z | BACKSPACE para apagar | ENTER para confirmar", width / 2, height / 2 + 95, color(0, 180, 80));
  drawGlowText("Pressione ESC para voltar", width / 2, height / 2 + 145, color(0, 150, 60));

  stroke(0, 20);
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) line(0, y, width, y);
  noStroke();
}

void drawRanking() {
  background(0);

  stroke(0, 35, 12);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  fill(0, 15, 5, 235); 
  stroke(0, 255, 120, 90);
  strokeWeight(5);
  rect(width / 2 - 320, 50, 640, 540, 16);
  
  noFill();
  stroke(0, 255, 120, 200);
  strokeWeight(2);
  rect(width / 2 - 314, 56, 628, 528, 12);
  noStroke();

  textAlign(CENTER);
  textSize(56);
  drawGlowText("SABOTAGE HALL OF FAME", width / 2, 115, color(0, 255, 120));

  stroke(0, 200, 90, 150);
  strokeWeight(2);
  line(width / 2 - 260, 145, width / 2 + 260, 145);
  noStroke();

  textSize(22);
  textAlign(LEFT);
  drawGlowText("POS", width / 2 - 250, 175, color(0, 255, 100));
  drawGlowText("PILOTO", width / 2 - 120, 175, color(0, 255, 100));
  textAlign(RIGHT);
  drawGlowText("PONTUAÇÃO", width / 2 + 250, 175, color(0, 255, 100));

  stroke(0, 200, 90, 150);
  strokeWeight(2.5);
  line(width / 2 - 260, 190, width / 2 + 260, 190);
  noStroke();

  textSize(26);
  for (int i = 0; i < rankingSystem.entries.size(); i++) {
    ScoreEntry entry = rankingSystem.entries.get(i);
    float yPos = 240 + i * 55;

    stroke(0, 80, 30, 80);
    strokeWeight(1);
    line(width / 2 - 260, yPos + 15, width / 2 + 260, yPos + 15);
    noStroke();

    color entryColor = (i == 0) ? color(255, 215, 0) : color(0, 230, 100);

    textAlign(LEFT);
    drawGlowText("#" + (i + 1), width / 2 - 250, yPos, entryColor);
    drawGlowText(entry.name, width / 2 - 120, yPos, entryColor);
    
    textAlign(RIGHT);
    drawGlowText(String.valueOf(entry.points), width / 2 + 250, yPos, entryColor);
  }

  textSize(20);
  textAlign(CENTER);
  float pulseBack = 130 + 125 * sin(frameCount * 0.08);
  drawGlowText("Pressione ESC para voltar ao Menu", width / 2, 545, color(0, 255, 120, pulseBack));

  stroke(0, 20);
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) line(0, y, width, y);
  noStroke();
}

void drawGameOver() {
  background(0);

  stroke(35, 5, 5);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  stroke(255, 50, 50, 60);
  strokeWeight(5);
  noFill();
  rect(width / 2 - 300, height / 2 - 180, 600, 360, 16);
  stroke(255, 50, 50, 180);
  strokeWeight(2);
  rect(width / 2 - 294, height / 2 - 174, 588, 348, 12);

  textAlign(CENTER);
  
  float pulseRed = 180 + 75 * sin(frameCount * 0.12);
  textSize(64);
  drawGlowText("MISSÃO FRACASSADA", width / 2, height / 2 - 110, color(255, 50, 50, pulseRed));

  stroke(255, 50, 50, 100);
  strokeWeight(1.5);
  line(width / 2 - 250, height / 2 - 60, width / 2 + 250, height / 2 - 60);
  noStroke();

  textSize(24);
  drawGlowText("RELATÓRIO DE COMBATE", width / 2, height / 2 - 30, color(255, 100, 100));
  
  textSize(22);
  drawGlowText("PILOTO: " + (playerNameInput.trim().length() > 0 ? playerNameInput : "CONVIDADO"), width / 2 - 100, height / 2 + 15, color(255, 200, 200));
  drawGlowText("DIFICULDADE: WAVE " + wave, width / 2 + 100, height / 2 + 15, color(255, 200, 200));
  
  textSize(36);
  drawGlowText("SCORE: " + score, width / 2, height / 2 + 75, color(255, 255, 100));

  stroke(255, 50, 50, 100);
  strokeWeight(1.5);
  line(width / 2 - 250, height / 2 + 105, width / 2 + 250, height / 2 + 105);
  noStroke();

  textSize(20);
  float pulseText = 140 + 115 * sin(frameCount * 0.08);
  drawGlowText("Pressione 'R' para REINICIAR", width / 2, height / 2 + 140, color(255, 80, 80, pulseText));

  stroke(0, 22);
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) line(0, y, width, y);
  noStroke();
}

void drawPauseMenu() {
  fill(0, 195);
  rectMode(CORNER);
  rect(0, 0, width, height);

  stroke(0, 45, 15);
  strokeWeight(1);
  for (int i = 0; i < width; i += 40) line(i, 0, i, height);
  for (int i = 0; i < height; i += 40) line(0, i, width, i);

  stroke(0, 255, 120, 80);
  strokeWeight(4);
  noFill();
  rect(width / 2 - 250, height / 2 - 120, 500, 240, 12);
  stroke(0, 255, 120, 180);
  strokeWeight(1.5);
  rect(width / 2 - 245, height / 2 - 115, 490, 230, 8);

  textAlign(CENTER, CENTER);
  textSize(52);
  drawGlowText("SISTEMA PAUSADO", width / 2, height / 2 - 40, color(0, 255, 120));

  textSize(20);
  float pulseText = 150 + 105 * sin(frameCount * 0.1);
  drawGlowText("Pressione 'P' para CONTINUAR", width / 2, height / 2 + 25, color(0, 255, 100, pulseText));
  drawGlowText("Pressione 'R' para REINICIAR", width / 2, height / 2 + 60, color(0, 200, 80));

  stroke(0, 15);
  strokeWeight(1);
  for (int y = 0; y < height; y += 4) line(0, y, width, y);
  noStroke();
}
