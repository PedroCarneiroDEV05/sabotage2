/**
 * Estrutura de dados simples para armazenar registros individuais no Hall da Fama.
 * Facilita a persistência e a ordenação (Sort) dentro do RankingSystem.
 */
class ScoreEntry {
  String name;
  int points;

  ScoreEntry(String name, int points) {
    this.name = name;
    this.points = points;
  }

  String toFileLine() {
    return name + ":" + points;
  }
} 
