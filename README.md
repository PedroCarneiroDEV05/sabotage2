# SABOTAGE 2

Projeto desenvolvido para a disciplina de Desenvolvimento de Games, inspirado no clássico *Sabotage*.

---

# Sobre o Projeto

Sabotage 2 é um jogo de ação em estilo arcade desenvolvido utilizando Processing e Java. O projeto tem como objetivo recriar a experiência clássica dos jogos retrô da década de 1980, trazendo melhorias de fluidez, organização estrutural e responsividade, mantendo a essência visual e mecânica do jogo original.

O jogador controla uma torre de defesa equipada com uma arma antiaérea responsável por proteger a base contra helicópteros inimigos e soldados paraquedistas.

O principal objetivo do jogo é sobreviver o maior tempo possível, eliminando inimigos antes que consigam invadir a base do jogador.

---

# Mecânicas e Sistemas

- Movimentação lateral do jogador;
- Sistema de disparos;
- Helicópteros inimigos;
- Sistema de paraquedistas;
- Sistema de colisão;
- Sistema de pontuação;
- Progressão dinâmica de dificuldade;
- Sistema de pause;
- Tela de ranking;
- Interface retrô inspirada em jogos arcade clássicos;
- Sistema de efeitos sonoros;
- Registro de pontuações com nomes dos jogadores.

---

# Tecnologias Utilizadas

- Processing
- Java
- Git
- GitHub
- Visual Studio Code

---

# Arquitetura do Projeto

O projeto foi estruturado de forma modular utilizando múltiplos arquivos `.pde`, separando responsabilidades entre os diferentes sistemas do jogo.

A arquitetura principal é centralizada no arquivo `Sabotage2.pde`, responsável pelo gerenciamento dos estados do jogo, integração dos sistemas, renderização das telas e controle geral da execução.

Os demais arquivos são responsáveis por funcionalidades específicas, como:

- gerenciamento do jogador;
- gerenciamento de projéteis;
- gerenciamento de inimigos;
- sistema de ranking;
- sistema de pontuação;
- gerenciamento de sons;
- sistema de explosões;
- controle de colisões e eventos.

Essa organização facilita a manutenção do projeto, o trabalho em equipe e a escalabilidade do desenvolvimento.

---

# Estrutura do Projeto

```text
Sabotage2/
│
├── Sabotage2.pde
├── Player.pde
├── Bullet.pde
├── Enemy.pde
├── Helicopter.pde
├── Parachuter.pde
├── Explosion.pde
├── ScoreSystem.pde
├── RankingSystem.pde
├── SoundManager.pde
│
├── data/
│   ├── sprites/
│   ├── sounds/
│   └── fonts/
```

---

# Como Executar

## 1. Instalar o Processing

Faça o download do Processing através do site oficial:

```text
https://processing.org/download
```

---

## 2. Clonar o Repositório

```bash
git clone https://github.com/PedroCarneiroDEV05/sabotage2.git
```

---

## 3. Abrir o Projeto

Abra a pasta do projeto no Processing.

---

## 4. Executar o Projeto

Execute o arquivo:

```text
Sabotage2.pde
```

---

# Objetivo Acadêmico

Este projeto foi desenvolvido como atividade avaliativa da disciplina de Desenvolvimento de Games, com foco em:

- lógica de programação;
- desenvolvimento de jogos 2D;
- organização de projetos;
- arquitetura de software;
- manipulação de sprites;
- sistemas de colisão;
- implementação de mecânicas arcade;
- trabalho em equipe;
- controle de versão com Git e GitHub.

---

# Integrantes

| Nome | Matrícula |
|------|------|
| João Vitor Costa Praxedes | 01710907 |
| Kaynan Rafael Guerra de Freitas | 01702989 |
| Levi Henrique Salles da Silva | 01706233 |
| Pedro Henrique Carneiro Vasconcelos | 01720880 |
| Vitor Queiroz Guerra | 01718322 |

---

# Referências

## Processing Official Website

```text
https://processing.org/
```

---

## Wikipedia – Sabotage (1981)

```text
https://en.wikipedia.org/wiki/Sabotage_(video_game)
```

---

## Wikipedia – Paratrooper (1982)

```text
https://en.wikipedia.org/wiki/Paratrooper_(video_game)
```

---

## RetroGames – Paratrooper

```text
https://www.retrogames.cz/play_616-DOS.php
```

---

# Status do Projeto

Projeto em desenvolvimento acadêmico.

Atualmente o projeto possui:

- estrutura principal do jogo;
- gerenciamento de estados;
- HUD;
- menu inicial;
- sistema de pause;
- tela de ranking;
- arquitetura base para integração dos sistemas;
- estrutura modular para desenvolvimento em equipe.
