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
