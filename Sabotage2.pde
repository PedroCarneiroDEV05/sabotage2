// =========================
// GAME STATES
// =========================
// MENU = Tela inicial
// PLAYING = Gameplay principal
// GAME_OVER = Tela de derrota
// RANKING = Tela de ranking
// PAUSED = Tela de pausa

final int MENU = 0;
final int PLAYING = 1;
final int GAME_OVER = 2;
final int RANKING = 3;
final int PAUSED = 4;

int gameState = MENU;


// =========================
// GLOBAL VARIABLES
// =========================
// score = pontuação atual do jogador
// playerLives = vidas restantes
// gameTime = tempo total da partida
// gameDifficulty = dificuldade dinâmica do jogo
// enemySpawnTimer = controle de spawn dos inimigos

int score = 0;
int playerLives = 3;
int gameTime = 0;
int gameDifficulty = 1;
int enemySpawnTimer = 0;


// =========================
// ENTITY LISTS
// =========================
// bullets = armazenará todos os tiros do jogador
// enemies = armazenará todos os os inimigos
// explosions = armazenará explosões e efeitos visuais

ArrayList bullets;
ArrayList enemies;
ArrayList explosions;


// =========================
// DEBUG E TRANSIÇÕES
// =========================
// debugMode = ativa informações extras na tela
// transitionAlpha = poderá ser usado futuramente para fades/transições
// gameRunning = controla se a gameplay está realmente ativa

boolean debugMode = false;
int transitionAlpha = 0;
boolean gameRunning = false;


// =========================
// SETUP PRINCIPAL
// =========================
// Aqui é feita toda inicialização do jogo

void setup() {

  size(1000, 700);

  bullets = new ArrayList();

  enemies = new ArrayList();

  explosions = new ArrayList();

  initializeGame();
}


// =========================
// INICIALIZAÇÃO DA PARTIDA
// =========================
// Reinicia variáveis globais do jogo
// Futuramente poderá resetar:
// - player
// - armas
// - dificuldade avançada
// - sistema de ondas

void initializeGame() {

  score = 0;

  playerLives = 3;

  gameTime = 0;

  gameDifficulty = 1;

  enemySpawnTimer = 0;
}


// =========================
// LOOP PRINCIPAL
// =========================
// draw() roda continuamente durante toda execução do jogo

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
// Futuramente pode adicionar:
// - animações
// - logo animada
// - música de menu
// - fundo com partículas
// - botões interativos

void drawMenu() {

  background(0);

  // GRID VISUAL RETRÔ/MILITAR
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

  // DESENHO DA ARMA TEMPORÁRIA
  // Futuramente substituir por sprite real
  rectMode(CENTER);

  rect(width / 2, height / 2 + 20, 120, 25);

  rect(width / 2 + 40, height / 2 - 20, 80, 20);

  rect(width / 2, height / 2 - 10, 40, 50);

  textSize(18);

  text("P = Pausar | TAB = Ranking", width / 2, height - 50);

  text("Os Rapazes Studio", width / 2, height - 20);

  // TEXTO PISCANDO
  if ((frameCount / 30) % 2 == 0) {

    textSize(28);

    text("Pressione ENTER para começar", width / 2, height - 100);
  }
}


// =========================
// CONTROLES GLOBAIS
// =========================
// Aqui ficam todos os inputs principais do jogo

void keyPressed() {

  // INICIAR GAMEPLAY
  if (keyCode == ENTER) {

    gameRunning = true;

    gameState = PLAYING;
  }

  // PAUSE
  if (key == 'p' || key == 'P') {

    if (gameState == PLAYING) {

      gameState = PAUSED;

    } else if (gameState == PAUSED) {

      gameState = PLAYING;
    }
  }

  // RESTART
  if (key == 'r' || key == 'R') {

    restartGame();
  }

  // RANKING
  if (keyCode == TAB) {

    gameState = RANKING;
  }

  // VOLTAR MENU
  if (keyCode == ESC) {

    key = 0;

    if (gameState == RANKING || gameState == PAUSED) {

      gameState = MENU;
    }
  }

  // DEBUG MODE
  if (key == 'f' || key == 'F') {

    debugMode = !debugMode;
  }

  // ===================================================
  // FUTURA INTEGRAÇÃO COM PLAYER
  // ===================================================
  // Quando João finalizar Player.pde:
  // adicionar:
  // player.handleInput();
  //
  // Também adicionar:
  // movimentação
  // tiro
  // animações
  // troca de direção
  // recoil
}


// =========================
// GAMEPLAY PRINCIPAL
// =========================
// Controla toda execução do jogo

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
// Atualiza toda lógica do jogo

void updateSystems() {

  // SCORE TEMPORÁRIO
  if (frameCount % 10 == 0) {

    score++;
  }

  gameTime++;

  enemySpawnTimer++;

  // DIFICULDADE DINÂMICA
  if (gameTime % 600 == 0) {

    gameDifficulty++;
  }

  // SPAWN TEMPORÁRIO
  if (enemySpawnTimer >= 120) {

    enemySpawnTimer = 0;

    println("Spawnar inimigo");
  }

  // GAME OVER
  if (playerLives <= 0) {

    gameState = GAME_OVER;
  }

  // TESTE TEMPORÁRIO DE DANO
  if (gameTime % 900 == 0) {

    playerLives--;
  }

  // ===================================================
  // FUTURA INTEGRAÇÃO COM ENEMY SYSTEM
  // ===================================================
  // Quando Kaynan finalizar Enemy.pde:
  //
  // adicionar:
  // update dos inimigos
  // IA dos helicópteros
  // movimentação
  // spawn real
  // dificuldade dinâmica
  // spawn por waves
  //
  // Também integrar:
  // Enemy Helicopter
  // Enemy Soldier
  // Parachuter System
  //
  // ===================================================
  // FUTURA INTEGRAÇÃO COM BULLETS
  // ===================================================
  // Quando Vitor finalizar Bullet.pde:
  //
  // adicionar:
  // update das balas
  // remoção de balas
  // velocidade
  // direção
  // limite de tiros
  //
  // ===================================================
  // FUTURA INTEGRAÇÃO COM EXPLOSIONS
  // ===================================================
  // Quando Levi finalizar Explosion.pde:
  //
  // adicionar:
  // efeitos visuais
  // partículas
  // animações de explosão
  // impacto visual
}


// =========================
// COLISÕES
// =========================
// Futuramente será um dos sistemas mais importantes

void checkCollisions() {

  // ===================================================
  // FUTURAMENTE:
  // ===================================================
  // bala vs inimigo
  // player vs inimigo
  // explosão vs player
  // explosão vs inimigo
  // colisão com cenário
  // colisão com limites da tela
}


// =========================
// RENDERIZAÇÃO
// =========================
// Renderiza entidades do jogo

void renderSystems() {

  background(20);

  // ===================================================
  // FUTURAMENTE:
  // ===================================================
  // render player
  // render bullets
  // render enemies
  // render explosions
  // render particles
  // render background animado
}


// =========================
// HUD
// =========================
// Exibe informações do jogador

void renderHUD() {

  rectMode(CORNER);

  fill(0, 150);

  rect(10, 10, 260, 170);

  fill(255);

  textAlign(LEFT);

  textSize(24);

  text("SCORE: " + score, 20, 40);

  text("VIDAS: " + playerLives, 20, 80);

  text("FPS: " + int(frameRate), width - 140, 40);

  text("DIFICULDADE: " + gameDifficulty, 20, 120);

  text("TEMPO: " + gameTime / 60, 20, 160);

  // DEBUG
  if (debugMode) {

    fill(0, 255, 0);

    text("DEBUG MODE", width - 180, 80);

    text("ENTITIES: " + enemies.size(), width - 180, 120);

    text("BULLETS: " + bullets.size(), width - 180, 160);
  }

  // ===================================================
  // FUTURAMENTE:
  // ===================================================
  // barra de vida
  // munição
  // armas
  // kill streak
  // mini mapa
  // combo system
}


// =========================
// GAME OVER
// =========================
// Tela de derrota

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

  // FUTURAMENTE:
  // salvar score automaticamente no ranking
}


// =========================
// MENU DE PAUSA
// =========================

void drawPauseMenu() {

  // FUTURAMENTE:
  // renderizar gameplay ao fundo
  // adicionar opções
  // adicionar sons

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
// Sistema temporário de ranking

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

  // ===================================================
  // FUTURA INTEGRAÇÃO COM RANKING SYSTEM
  // ===================================================
  // Quando Pedro finalizar RankingSystem.pde:
  //
  // adicionar:
  // salvamento local
  // leitura de score
  // nome do jogador
  // top scores
  // ranking persistente
}


// =========================
// RESTART
// =========================
// Reinicia completamente a partida

void restartGame() {

  initializeGame();

  bullets.clear();

  enemies.clear();

  explosions.clear();

  gameRunning = false;

  gameState = MENU;

  // FUTURAMENTE:
  // resetar player
  // resetar armas
  // resetar dificuldade
  // resetar partículas
}
