import 'frienddto.dart';

/// For easier display of user data
class UserDTO {
  final String uid;
  final String name;
  final List<FriendDTO> friends;
  final int level;
  final int xp;
  final int highScore;
  final int bestStreak;
  final int leaderBoard;

  UserDTO(this.uid, this.name,this.friends,this.level,this.xp,this.highScore,this.bestStreak,this.leaderBoard);
}