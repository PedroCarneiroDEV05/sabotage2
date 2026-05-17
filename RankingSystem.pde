class RankingSystem {
  ArrayList<ScoreEntry> entries;
  int maxEntries = 5;
  String filePath = "ranking.txt";

  RankingSystem() {
    entries = new ArrayList<ScoreEntry>();
    load();
  }

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

  void sortRanking() {
    entries.sort((a, b) -> b.points - a.points);
  }

  void load() {
    entries.clear();

    String[] lines = loadStrings(filePath);

    if (lines == null) {
      save();
      return;
    }

    for (String line : lines) {
      String[] parts = split(line, ":");

      if (parts.length != 2) {
        continue;
      }

      String name = parts[0];
      int points = int(parts[1]);

      entries.add(new ScoreEntry(name, points));
    }

    sortRanking();

    while (entries.size() > maxEntries) {
      entries.remove(entries.size() - 1);
    }
  }

  void save() {
    String[] lines = new String[entries.size()];

    for (int i = 0; i < entries.size(); i++) {
      lines[i] = entries.get(i).toFileLine();
    }

    saveStrings("data/" + filePath, lines);
  }

  void display(float x, float y) {
    textAlign(CENTER);

    textSize(60);

    text("RANKING", x, y);

    stroke(255);
    line(x - 200, y + 50, x + 200, y + 50);

    noStroke();
    textSize(24);
    for (int i = 0; i < entries.size(); i++) {
      ScoreEntry entry = entries.get(i);

      text(
        (i + 1) + ". " + entry.name + " - " + entry.points,
        x,
        y + 140 + i * 60
      );
    }
  }
}
