// Gerencia a persistência e ordenação das pontuações (Leaderboard).
// Mantém os 5 melhores registros salvos localmente num arquivo de texto.
class RankingSystem {
  ArrayList<ScoreEntry> entries;
  int maxEntries = 5;
  String filePath = "ranking.txt";

  RankingSystem() {
    entries = new ArrayList<ScoreEntry>();
    load();
    
    // Popula com pontuações fictícias caso seja a primeira execução do jogo
    if (entries.isEmpty()) {
      addScore("PEDRO", 9999);
      addScore("VITOR", 8500);
      addScore("KAYNAN", 7000);
      addScore("PILOTO", 5000);
      addScore("RECRUTA", 3000);
      save();
    }
  }

  // Adiciona uma nova pontuação se for alta o suficiente para entrar no top 5
  void addScore(String name, int points) {
    ScoreEntry newEntry = new ScoreEntry(name, points);

    if (entries.size() < maxEntries) {
      entries.add(newEntry);
      sortRanking();
      save();
      return;
    }

    ScoreEntry worst = entries.get(entries.size() - 1);

    if (points > worst.points) {
      entries.remove(entries.size() - 1);
      entries.add(newEntry);
      sortRanking();
      save();
    }
  }

  // Ordena a lista de forma decrescente
  void sortRanking() {
    entries.sort((a, b) -> b.points - a.points);
  }

  // Carrega as pontuações armazenadas no disco
  void load() {
    entries.clear();
    String[] lines = loadStrings(filePath);

    if (lines == null) {
      save();
      return;
    }

    for (String line : lines) {
      String[] parts = split(line, ":");
      if (parts.length != 2) continue;
      
      String name = parts[0];
      int points = int(parts[1]);
      entries.add(new ScoreEntry(name, points));
    }

    sortRanking();
    while (entries.size() > maxEntries) {
      entries.remove(entries.size() - 1);
    }
  }

  // Salva o estado atual do ranking no disco
  void save() {
    String[] lines = new String[entries.size()];
    for (int i = 0; i < entries.size(); i++) {
      lines[i] = entries.get(i).toFileLine();
    }
    saveStrings(filePath, lines);
  }

  // Renderiza a lista crua de jogadores e pontuações (sem o cabeçalho)
  void display(float x, float y) {
    textAlign(CENTER);
    textSize(24);
    
    for (int i = 0; i < entries.size(); i++) {
      ScoreEntry entry = entries.get(i);
      text((i + 1) + ". " + entry.name + " - " + entry.points, x, y + i * 45);
    }
  }
}
