//For sending Statistics data to Database
class Stats {
  final int level;
  final int xp;
  final int highScore;
  final int bestStreak;
  final int leaderBoard;

  Stats(this.level,this.xp,this.highScore,this.bestStreak,this.leaderBoard);

  //Convert Stats to Map<String,dynamic>
  Map<String,dynamic> toMap() {
    return {
      'level': level,
      'XP': xp,
      'highScore': highScore,
      'bestStreak': bestStreak,
      'leaderBoard': leaderBoard,
    };
  }
  //Convert Map<String,dynamic> to Stats
  factory Stats.fromMap(Map<String, dynamic> data) {
    return Stats(data['level'], data['XP'], data['highScore'], data['bestStreak'],data['leaderBoard']);
  }
}