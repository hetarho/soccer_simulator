class ClubSeasonStat {
  final int seasonId;
  int won;
  int drawn;
  int lost;
  int gf;
  int ga;

  ClubSeasonStat({
    required this.seasonId,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.gf = 0,
    this.ga = 0,
  });

  int get gd => gf - ga; // 골득실

  int get pts => won * 3 + drawn; // 승점

  void win() {
    won++;
  }

  void lose() {
    lost++;
  }

  void draw() {
    drawn++;
  }

  void scored() {
    gf++;
  }

  void conceded() {
    ga++;
  }
}
