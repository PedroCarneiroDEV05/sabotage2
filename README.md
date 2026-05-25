# Sabotage 2

## Descrição
Projeto de jogo arcade inspirado no clássico Sabotage. Desenvolvido nativamente em Processing (Java), o projeto resgata mecânicas e a estética retrô arcade focando em arquitetura de software organizada, sistemas modernos de loop e game feel tático.

## Sistemas Implementados
O projeto conta com os seguintes sistemas arquitetados para performance e estabilidade:
* **Helicópteros:** Inimigos aéreos com patrulha e drop dinâmico baseado em timers.
* **Paraquedistas:** Máquina de estados baseada no ar (queda livre amortecida) e solo (marcha em eixo linear).
* **Tiros:** Disparos baseados na angulação geométrica exata do canhão no instante do gatilho.
* **Colisão:** Checagem iterativa estrita do contato entre vetores ativos do cenário contra as _hitboxes_ em lote.
* **Explosões:** Gerenciador independente de partículas instanciadas dotado de atrito multiplicativo e física gravitacional.
* **Ranking:** Algoritmo I/O persistente de pontuações focado em leitura/escrita e reordenação limitando um grid de cinco registros.
* **Hall da Fama:** Abstração e formatação customizada via texto resgatando visual estético.
* **Pause / Game Over:** Segmentação exata via matriz de estados de controle. O update global pausa, enquanto a máquina visual opera de fundo.
* **HUD Vetorial:** Interface de dados do ambiente processada sob técnicas de _glow_, imitando luz de tubos de televisão convencionais (CRT).
* **Waves:** Algoritmo procedural de aumento de densidade. Dispensa limite superior para o nível ou vida dos adversários e o _spawn rate_.
* **Progressão de Dificuldade:** Escalabilidade temporal acoplada à variação do número de frames, garantindo o tempo orgânico e contínuo.
* **Controle do Canhão:** Matrizes _push/pop_ operando unicamente nas margens seguras preestabelecidas.
* **Registro de Piloto:** Coleta contínua e validação tipificada pelo teclado, convertida internamente via parsing sem bibliotecas auxiliares de User Interface.
* **Sistema de Áudio:** Classes de wrapper estrutural desenhadas unicamente para o isolamento dos carregamentos para não poluir o setup primário da aplicação.

## Sistemas em Desenvolvimento
* Revisão refinada da coleta automática via _Garbage Collector_ sob intensos ciclos paralelos de processamento de classes de resíduos de Explosão em rodadas prolongadas.

## Tecnologias Utilizadas
* Processing
* Java
* Git
* GitHub
* Visual Studio Code

## Arquitetura do Projeto
A arquitetura assegura estrita separação de preceitos e responsabilidades matemáticas (_update_ paramétrico) e visuais (_render_). A comunicação se desenvolve pela máquina central que detém uma gama de propriedades da vida em memória (listas genéricas) e repassa os _ticks_ lógicos a cada módulo abstrato autônomo individualmente. A complexidade do cenário se desenvolve horizontalmente.

## Estrutura dos Arquivos
* `Sabotage2.pde`: Controller mor e orquestrador global. Loop master da matriz da engine de estado, de inputs base e renderização top-level.
* `Enemy.pde`: Superclasse basilar para toda entidade orgânica contendo assinaturas de status unificado para gerenciar vida.
* `Helicopter.pde`: Especialização geradora que cuida primariamente da gestão temporal contínua da instância autônoma sobre invasores secundários.
* `Parachuter.pde`: Instância híbrida orientada com transição dependente do choque no eixo limite central de coordenadas (chão).
* `Bullet.pde`: Projétil encapsulado linear autônomo.
* `Explosion.pde`: Gestor efêmero autônomo de fragmentos que executa e sinaliza a auto destruição visual ao controlador master quando sem vida ativa.
* `Player.pde`: Receptor direto contendo o vetor restrito espacial do canhão, limites numéricos polares de _stroke_ e recargas numéricas.
* `RankingSystem.pde`: Interface modular voltada à conversão estruturada da memória para o disco primário.
* `ScoreSystem.pde`: Data class definidora simplificada do formato POJO dos líderes do rank.
* `SoundManager.pde`: Isola em arquivo dedicado a responsabilidade total pelas vias e acoplamentos dos canais digitais do sistema interno Sound.

## Execução do Projeto
**Requisitos:** IDE do Processing funcional.
**Dependências:** Adição via repositório de recursos oficial do Processing da "Sound" via bibliotecas internas (_Sketch > Import_).
**Como Abrir / Executar:**
1. Confirme a alocação padronizada na pasta raiz chamada nativamente `Sabotage2`.
2. Não desconfigure a integridade ou caminhos dos recursos no diretório `data/sounds`.
3. Inicie através do arquivo raiz `Sabotage2.pde` dentro da ferramenta.
4. Execute via Run na barra de contexto primária de atalhos.

## Controles
* **Teclas A-Z**: Registro autoral na lista (Input name text).
* **ENTER**: Função estrita de _Proceed / Confirm / Start_ global base.
* **ESPAÇO**: Gatilho operacional de acionamento bélico do tanque.
* **BACKSPACE**: Exclusão paramétrica em interfaces tipográficas.
* **P**: Acionador alternativo restrito de Pausa instantânea da _gameplay_.
* **R**: Comando fixo unificado de _Restart / Reset state_ global completo.
* **TAB**: Visualização do banco do hall geral a partir de interfaces estáticas.
* **ESC**: Comando hierárquico retrocedente nas árvores de interface.

## Status do Projeto
Estado Atual: **Release / Operacionalmente Estável**.
As métricas globais e funcionais foram testadas com sucesso: colisões e comportamentos lineares cumprem plenamente as propostas matemáticas em alto padrão paramétrico e de forma fluida a cada nova iteração. A performance é mantida.

## Referências
* Sabotage original (1981, Apple II - Mark Allen).
* Estruturação de lógicas orgânicas do site nativo para _Processing Reference_, e matriz de jogos Arcade 2D matemáticos dos anos 80.
