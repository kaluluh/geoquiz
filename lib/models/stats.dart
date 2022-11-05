class Stats {
  final int level;
  final int XP;
  final int highscore;
  final int best_streak;

  Stats(this.level,this.XP,this.highscore,this.best_streak);

  Map<String,dynamic> toMap() {
    return {
      'level': level,
      'XP': XP,
      'highscore': highscore,
      'best_streak': best_streak
    };
  }

  factory Stats.fromMap(Map<String, dynamic> data) {
    return Stats(data['level'], data['XP'], data['highscore'], data['best_streak']);
  }
}