class Stats {
  final int level;
  final int xp;
  final int highScore;
  final int bestStreak;
  final int leaderBoard;

  Stats(this.level,this.xp,this.highScore,this.bestStreak,this.leaderBoard);

  Map<String,dynamic> toMap() {
    return {
      'level': level,
      'XP': xp,
      'highScore': highScore,
      'bestStreak': bestStreak,
      'leaderBoard': leaderBoard,
    };
  }

  factory Stats.fromMap(Map<String, dynamic> data) {
    return Stats(data['level'], data['xp'], data['highScore'], data['bestStreak'],data['leaderBoard']);
  }
}