import 'package:geoquiz/controller/dtos/userdto.dart';

import '../models/stats.dart';
import '../services/firebase/auth.dart';
import 'application_controller.dart';

class PostGameStats{
  PostGameStats({required this.xpGained, required this.score, required this.bestStreak});

  final xpGained;
  final score;
  final bestStreak;
}

class StatsController{
  StatsController({
    required this.auth,
    required this.userController
  });

  final AuthBase auth;
  final ApplicationController userController;

  static const int xpToNextLevel = 1000;

  Future<UserDTO> userData() async {
    return await userController.getUserData(auth.currentUser!.uid);
  }

  Future<int> getNewXp(int xp) async {
    var stats = await userData();
    var xpP = (stats.xp + xp) % xpToNextLevel;
    return xpP;
  }

  Future<int> getNewLevel(int xp) async {
    var stats = await userData();
    var level = stats.level + ((stats.xp + xp) / xpToNextLevel).floor().toInt();
    return level;
  }

  Future<void> setStats(PostGameStats stats) async {
    var user = await userData();
    var newStats = Stats(
      await getNewLevel(stats.xpGained),
      await getNewXp(stats.xpGained),
      user.highScore < stats.score ? stats.score : user.highScore,
      user.bestStreak < stats.bestStreak ? stats.bestStreak : user.bestStreak,
      user.leaderBoard + 1
    );
    userController.updateStats(auth.currentUser!.uid, newStats);
  }
}