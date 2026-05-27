/**
 * CreditsOverlay.pde
 * 
 * Sistema isolado de renderização e controle de créditos para o jogo Sabotage 2.
 * Implementa uma overlay preta translúcida e um painel estilo retro-arcade
 * com auto-scroll, controle manual e links clicáveis dos GitHubs da equipe.
 */

boolean showCredits = false;
float creditsScrollY = 0;
float creditsMaxScroll = 1200;
float creditsFadeAlpha = 0;
float creditsScrollSpeed = 0.7; // Velocidade lenta e suave para scroll arcade

boolean linkClickedThisFrame = false;

void resetCredits() {
  creditsScrollY = 0;
  creditsFadeAlpha = 0;
  linkClickedThisFrame = false;
  cursor(ARROW); // Garante cursor padrão ao inicializar/reiniciar
}

void drawCreditsOverlay() {
  // Reseta o cursor para padrão no início do frame. 
  // Caso o mouse esteja sobre um link interativo, o cursor mudará para HAND.
  cursor(ARROW);

  // Consome a ação de clique desta frame
  boolean clickAction = linkClickedThisFrame;
  linkClickedThisFrame = false;

  // 1. Fade-in suave do fundo preto translúcido (alcança 180 de opacidade)
  creditsFadeAlpha = lerp(creditsFadeAlpha, 180, 0.08);
  
  rectMode(CORNER);
  fill(0, creditsFadeAlpha);
  noStroke();
  rect(0, 0, width, height);
  
  // 2. Painel centralizado estilo retro-neon do Sabotage 2
  float panelAlpha = map(creditsFadeAlpha, 0, 180, 0, 235);
  fill(0, 15, 5, panelAlpha); 
  stroke(0, 255, 120, map(creditsFadeAlpha, 0, 180, 0, 90));
  strokeWeight(5);
  rectMode(CENTER);
  rect(width / 2, height / 2, 800, 520, 16);
  
  noFill();
  stroke(0, 255, 120, map(creditsFadeAlpha, 0, 180, 0, 200));
  strokeWeight(2);
  rect(width / 2, height / 2, 788, 508, 12);
  noStroke();
  
  // 3. Renderização do conteúdo com máscara de recorte (clipping)
  // O painel ocupa X de 100 a 900 e Y de 90 a 610.
  // Ajustamos o recorte ligeiramente para dentro das bordas internas.
  clip(106, 96, 788, 508);
  
  // Inicia o auto-scroll após o fade-in estar próximo do fim
  if (creditsFadeAlpha > 170) {
    creditsScrollY += creditsScrollSpeed;
  }
  
  // Desenha os créditos a partir da posição inicial menos o scroll atual
  float startY = height / 2 - 200 - creditsScrollY;
  float totalHeight = renderCreditsContent(startY, clickAction);
  
  // Define o limite máximo de scroll de forma dinâmica
  creditsMaxScroll = max(0, totalHeight - 320);
  
  // Se o scroll passar da altura total mais uma margem, reinicia (efeito retro contínuo)
  if (creditsScrollY > creditsMaxScroll + 150) {
    creditsScrollY = -120; // Inicia um pouco abaixo para transição suave
  }
  
  noClip();
  
  // 4. Instruções de controle abaixo do painel principal (com brilho pulsante)
  float pulse = 130 + 125 * sin(frameCount * 0.08);
  textAlign(CENTER, CENTER);
  textSize(16);
  drawGlowText("Pressione ESC ou C para fechar | UP/DOWN para rolar | Clique nos links do GitHub", width / 2, height / 2 + 285, color(0, 255, 120, pulse));
}

float renderCreditsContent(float startY, boolean clickAction) {
  float cy = startY;
  
  // Cabeçalho dos Créditos
  textAlign(CENTER, TOP);
  textSize(38);
  drawGlowText("SABOTAGE 2", width / 2, cy, color(0, 255, 120));
  cy += 45;
  
  textSize(18);
  drawGlowText("Desenvolvido por:", width / 2, cy, color(0, 180, 80));
  cy += 24;
  
  textSize(28);
  drawGlowText("Os Rapazes Studio", width / 2, cy, color(0, 255, 120));
  cy += 45;
  
  // Linha divisória
  stroke(0, 255, 120, 80);
  strokeWeight(2);
  line(width / 2 - 200, cy, width / 2 + 200, cy);
  noStroke();
  cy += 25;
  
  textSize(22);
  drawGlowText("EQUIPE DE DESENVOLVIMENTO", width / 2, cy, color(0, 255, 120));
  cy += 50;
  
  // --- Pedro Henrique Carneiro Vasconcelos ---
  cy = drawDeveloperBlock(cy, 
    "Pedro Henrique Carneiro Vasconcelos — 01720880",
    "Lead Developer / Arquitetura Principal",
    new String[] {
      "estrutura geral do projeto",
      "setup/draw",
      "integracao dos sistemas",
      "organizacao do codigo",
      "GitHub/versionamento",
      "correcao de bugs",
      "otimizacao",
      "gameplay feel",
      "testes gerais",
      "gerenciamento tecnico"
    },
    "Arquivo principal: Sabotage2.pde",
    "github.com/PedroCarneiroDEV05",
    clickAction
  );
  
  // --- João Vitor Costa Praxedes ---
  cy = drawDeveloperBlock(cy, 
    "João Vitor Costa Praxedes — 01710907",
    "Player e Sistema de Armas",
    new String[] {
      "movimentacao do jogador",
      "tiros",
      "controle do player",
      "fluidez da movimentacao"
    },
    "Arquivos: Player.pde, Bullet.pde",
    "github.com/JayVPX",
    clickAction
  );
  
  // --- Kaynan Rafael Guerra de Freitas ---
  cy = drawDeveloperBlock(cy, 
    "Kaynan Rafael Guerra de Freitas — 01702989",
    "Sistema de Inimigos",
    new String[] {
      "helicopteros",
      "paraquedistas",
      "spawn de inimigos",
      "dificuldade progressiva"
    },
    "Arquivos: Enemy.pde, Helicopter.pde, Parachuter.pde",
    "github.com/Freitosu",
    clickAction
  );
  
  // --- Levi Henrique Salles da Silva ---
  cy = drawDeveloperBlock(cy, 
    "Levi Henrique Salles da Silva — 01706233",
    "Parte Visual e Efeitos",
    new String[] {
      "explosoes",
      "particulas",
      "efeitos visuais",
      "pequenas animacoes"
    },
    "Arquivo: Explosion.pde",
    "github.com/levi985",
    clickAction
  );
  
  // --- Vitor Queiroz Guerra ---
  cy = drawDeveloperBlock(cy, 
    "Vitor Queiroz Guerra — 01718322",
    "Pontuacao, Ranking e Sons",
    new String[] {
      "sistema de score",
      "ranking",
      "salvar pontuacao",
      "game over",
      "efeitos sonoros"
    },
    "Arquivos: ScoreSystem.pde, RankingSystem.pde, SoundManager.pde",
    "github.com/VitorBionic",
    clickAction
  );
  
  return cy - startY; // Retorna o tamanho total vertical ocupado pelos créditos
}

float drawDeveloperBlock(float cy, String nameRA, String role, String[] responsibilities, String files, String githubUrl, boolean clickAction) {
  // Calcula dinamicamente o tamanho do card do desenvolvedor
  float blockHeight = 60 + responsibilities.length * 18 + 48;
  
  // Fundo escuro do card e borda neon suave
  fill(0, 30, 10, 120);
  stroke(0, 255, 120, 50);
  strokeWeight(1);
  rectMode(CORNER);
  rect(130, cy, 740 - 130, blockHeight, 8);
  noStroke();
  
  float ty = cy + 12;
  
  // Nome e RA do desenvolvedor
  textAlign(LEFT, TOP);
  textSize(16);
  drawGlowText(nameRA, 145, ty, color(0, 255, 120));
  ty += 22;
  
  // Cargo / Função
  textSize(14);
  drawGlowText(role, 155, ty, color(255, 180, 0)); // Dourado/laranja arcade
  ty += 20;
  
  // Cabeçalho de responsabilidades
  textSize(12);
  drawGlowText("Responsabilidades:", 165, ty, color(0, 180, 80));
  ty += 18;
  
  // Lista de responsabilidades (com bullet points)
  textSize(12);
  for (String resp : responsibilities) {
    drawGlowText("• " + resp, 180, ty, color(220, 255, 230));
    ty += 18;
  }
  
  // Arquivos correspondentes
  textSize(12);
  drawGlowText(files, 165, ty, color(0, 200, 255)); // Azul claro futurista
  ty += 18;
  
  // Link do GitHub (Clicável e interativo com hover visual)
  drawGitHubLink(165, ty, githubUrl, clickAction);
  
  cy += blockHeight + 25; // Espaçamento entre os blocos
  return cy;
}

boolean drawGitHubLink(float x, float y, String url, boolean isClickedEvent) {
  String displayText = "GitHub: " + url;
  float txtWidth = textWidth(displayText);
  
  // Caixa de colisão do link de texto
  float x1 = x;
  float x2 = x + txtWidth;
  float y1 = y;
  float y2 = y + 15; // Altura aproximada do texto para tamanho 12
  
  // Verifica se o mouse está sobre o link e se está na área visível recortada (clip)
  boolean isHovered = (mouseX >= x1 && mouseX <= x2 && mouseY >= y1 && mouseY <= y2) 
                      && (mouseY >= 96 && mouseY <= 604);
                      
  if (isHovered) {
    cursor(HAND); // Cursor interativo de link
    
    // Sublinhado estilo link web retro
    stroke(0, 255, 120, 200);
    strokeWeight(1.5);
    line(x1, y2 + 2, x2, y2 + 2);
    noStroke();
    
    // Brilho verde neon destacado no hover
    drawGlowText(displayText, x, y, color(0, 255, 120));
    
    if (isClickedEvent) {
      link("https://" + url); // Abre o navegador padrão do sistema
      return true;
    }
  } else {
    // Cor azul ciano bonita padrão para links normais
    drawGlowText(displayText, x, y, color(0, 180, 255));
  }
  
  return false;
}

// Ouvinte de clique do mouse global do Processing registrado automaticamente
void mousePressed() {
  if (showCredits && (gameState == MENU || gameState == GAME_OVER)) {
    linkClickedThisFrame = true;
  }
}
