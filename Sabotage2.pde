// =========================
// GAME STATES
// =========================

final int MENU = 0;
final int PLAYING = 1;
final int GAME_OVER = 2;
final int RANKING = 3;
final int PAUSED = 4;

int gameState = MENU;


// =========================
// GLOBAL VARIABLES
// =========================

int score = 0;
int playerLives = 3;
int gameTime = 0;
int gameDifficulty = 1;


// =========================
// ENTITY LISTS
// =========================

ArrayList<Bullet> bullets;
ArrayList<Helicopter> helicopters;
ArrayList<Parachuter> parachuters;
ArrayList explosions;
Player player;


// =========================
// DEBUG E TRANSIÇÕES
// =========================

boolean debugMode = false;
int transitionAlpha = 0;
boolean gameRunning = false;


// =========================
// SETUP PRINCIPAL
// =========================

void setup() {

  size(1000, 700);

  bullets = new ArrayList();

  helicopters = new ArrayList<Helicopter>();

  parachuters = new ArrayList<Parachuter>();

  explosions = new ArrayList();

  player = new Player();

  initializeGame();
}


// =========================
// INICIALIZAÇÃO DA PARTIDA
// =========================

void initializeGame() {

  score = 0;

  playerLives = 3;

  gameTime = 0;

  gameDifficulty = 1;

  wave = 1;

  spawnTimer = 0;

  spawnInterval = 300;
}


// =========================
// LOOP PRINCIPAL
// =========================

void draw() {

  background(0);

  switch(gameState) {

    case MENU:
      drawMenu();
      break;

    case PLAYING:
      runGame();
      break;

    case GAME_OVER:
      drawGameOver();
      break;

    case RANKING:
      drawRanking();
      break;

    case PAUSED:
      drawPauseMenu();
      break;
  }
}


// =========================
// MENU PRINCIPAL
// =========================

void drawMenu() {

  background(0);

  stroke(40);

  for (int i = 0; i < width; i += 40) {

    line(i, 0, i, height);
  }

  for (int i = 0; i < height; i += 40) {

    line(0, i, width, i);
  }

  noStroke();

  fill(255);

  textAlign(CENTER);

  textSize(110);

  text("SABOTAGE 2", width / 2, height / 2 - 180);

  rectMode(CENTER);

  rect(width / 2, height / 2 + 20, 120, 25);

  rect(width / 2 + 40, height / 2 - 20, 80, 20);

  rect(width / 2, height / 2 - 10, 40, 50);

  textSize(18);

  text("P = Pausar | TAB = Ranking", width / 2, height - 50);

  text("Os Rapazes Studio", width / 2, height - 20);

  if ((frameCount / 30) % 2 == 0) {

    textSize(28);

    text("Pressione ENTER para começar", width / 2, height - 100);
  }
}


// =========================
// CONTROLES GLOBAIS
// =========================

void keyPressed() {

  if (keyCode == ENTER) {

    gameRunning = true;

    gameState = PLAYING;
  }

  if (key == 'p' || key == 'P') {

    if (gameState == PLAYING) {

      gameState = PAUSED;

    } else if (gameState == PAUSED) {

      gameState = PLAYING;
    }
  }

  if (key == 'r' || key == 'R') {

    restartGame();
  }

  if (keyCode == TAB) {

    gameState = RANKING;
  }

  if (keyCode == ESC) {

    key = 0;

    if (gameState == RANKING || gameState == PAUSED) {

      gameState = MENU;
    }
  }

  if (key == 'f' || key == 'F') {

    debugMode = !debugMode;
  }
  
  //Atirar 
  if (key == ' ') {

  player.shoot();
}
}


// =========================
// GAMEPLAY PRINCIPAL
// =========================

void runGame() {

  if (!gameRunning) {

    return;
  }

  updateSystems();

  checkCollisions();

  renderSystems();

  renderHUD();
}


// =========================
// UPDATE DOS SISTEMAS
// =========================

void updateSystems() {
  if (frameCount % 10 == 0) {

    score++;
  }

  gameTime++;

  // DIFICULDADE PROGRESSIVA
  if (gameTime % 1800 == 0) {

    increaseWave();

    gameDifficulty = wave;
  }
  
  //Update Player
  player.update();
  
  //Update Tiros
  for (int i = bullets.size() - 1; i >= 0; i--) {

  Bullet b = (Bullet) bullets.get(i);

  b.update();

  if (!b.alive) {

    bullets.remove(i);
    }
  }
    
  // SPAWN DOS HELICÓPTEROS
  updateSpawn(helicopters);

  // =========================
  // UPDATE HELICÓPTEROS
  // =========================

  for (int i = helicopters.size() - 1; i >= 0; i--) {

    Helicopter h = helicopters.get(i);

    h.update();

    // =========================
    // TRANSFERE PARAQUEDISTAS
    // =========================

    for (int j = h.dropped.size() - 1; j >= 0; j--) {

      parachuters.add(h.dropped.get(j));

      h.dropped.remove(j);
    }

    // HELICÓPTERO REMOVIDO
    if (!h.alive) {

      helicopters.remove(i);
    }
  }

  // =========================
  // UPDATE PARAQUEDISTAS
  // =========================

  for (int i = parachuters.size() - 1; i >= 0; i--) {

    Parachuter p = parachuters.get(i);

    p.update();

    if (!p.alive) {

      if (p.escaped) {

        playerLives--;
      }

      parachuters.remove(i);
    }
  }

  // GAME OVER
  if (playerLives <= 0) {

    gameState = GAME_OVER;
  }

  // ===================================================
  // INTEGRAÇÃO FUTURA COM BULLETS
  // ===================================================
  // adicionar:
  // update das balas
  // direção dos tiros
  // velocidade
  // remoção automática
  // limite de disparos

  // ===================================================
  // INTEGRAÇÃO FUTURA COM EXPLOSIONS
  // ===================================================
  // adicionar:
  // partículas
  // explosões
  // efeitos visuais
  // impacto ao destruir inimigos
}


// =========================
// COLISÕES
// =========================

void checkCollisions() {

  // FUTURAMENTE:
  // bala vs inimigo
  // player vs inimigo
  // explosão vs inimigo
  // colisão com cenário
}


// =========================
// RENDERIZAÇÃO
// =========================

void renderSystems() {

  background(20);

  // CHÃO
  fill(35);

  rect(0, height - 40, width, 40);

  // HELICÓPTEROS
  for (Helicopter h : helicopters) {

    h.display();
  }

  // PARAQUEDISTAS
  for (Parachuter p : parachuters) {

    p.display();
  }
  
  //Balas
  for (int i = 0; i < bullets.size(); i++) {

  Bullet b = (Bullet) bullets.get(i);

  b.display();
}

  // FUTURAMENTE:
  // render bullets
  // render player
  // render explosões
  // render partículas
}


// =========================
// HUD
// =========================

void renderHUD() {

  rectMode(CORNER);

  fill(0, 150);

  rect(10, 10, 260, 170);

  fill(255);

  textAlign(LEFT);

  textSize(24);

  text("SCORE: " + score, 20, 40);

  text("VIDAS: " + playerLives, 20, 80);

  text("DIFICULDADE: " + gameDifficulty, 20, 120);

  text("TEMPO: " + gameTime / 60, 20, 160);

  text("FPS: " + int(frameRate), width - 140, 40);

  if (debugMode) {

    fill(0, 255, 0);

    text("DEBUG MODE", width - 180, 80);

    text("HELICOPTERS: " + helicopters.size(), width - 250, 120);

    text("PARACHUTERS: " + parachuters.size(), width - 250, 160);
  }
}


// =========================
// GAME OVER
// =========================

void drawGameOver() {

  background(0);

  fill(255);

  textAlign(CENTER);

  textSize(70);

  text("GAME OVER", width / 2, height / 2);

  textSize(25);

  text("Pressione R para reiniciar", width / 2, height / 2 + 80);

  textSize(30);

  text("Pontuação Final: " + score, width / 2, height / 2 + 60);
}


// =========================
// MENU DE PAUSA
// =========================

void drawPauseMenu() {

  fill(0, 180);

  rectMode(CORNER);

  rect(0, 0, width, height);

  fill(255);

  textAlign(CENTER);

  textSize(60);

  text("PAUSADO", width / 2, height / 2);

  textSize(24);

  text("Pressione P para continuar", width / 2, height / 2 + 60);
}


// =========================
// RANKING
// =========================

void drawRanking() {

  background(0);

  fill(255);

  textAlign(CENTER);

  textSize(60);

  text("RANKING", width / 2, 100);

  stroke(255);

  line(width / 2 - 200, 150, width / 2 + 200, 150);

  noStroke();

  textSize(24);

  text("1. PEDRO - 9999", width / 2, 240);

  text("2. VITOR - 8500", width / 2, 300);

  text("3. KAYNAN - 7000", width / 2, 360);

  text("Pressione ESC para voltar", width / 2, height - 80);
}


// =========================
// RESTART
// =========================

void restartGame() {

  initializeGame();

  bullets.clear();

  helicopters.clear();

  parachuters.clear();

  explosions.clear();

  gameRunning = false;

  gameState = MENU;
}