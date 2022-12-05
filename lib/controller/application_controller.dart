import 'package:geoquiz/controller/dtos/userdto.dart';
import 'package:geoquiz/repository/stats_repository.dart';
import 'package:geoquiz/repository/user_repository.dart';

import '../models/stats.dart';
import '../models/user.dart';
import '../services/firebase/auth.dart';
import 'dtos/frienddto.dart';

/// Routes the incoming requests towards to the business logic
class ApplicationController {
  late UserRepository _userRepository;
  late StatsRepository _statsRepository;

  ApplicationController() {
    _userRepository = UserRepository();
    _statsRepository = StatsRepository();
  }

  /// To initialize the signed user
  Future<void> initializeUser(AuthBase auth) async {
    var uid = auth.currentUser!.uid;
    if (_userRepository.checkUserExist(uid) == false) {
      var name = auth.currentUser?.isAnonymous == true
          ? "Anonymous"
          : auth.currentUser?.email?.split('@')[0];
      var newUser = User(uid, name!, <String>[]);
      _userRepository.setUser(newUser);
      _statsRepository.setStats(uid, Stats(0, 0, 0, 0, 0));
    }
  }

  /// Get user data by Id, returning with a UserDTO instance
  Future<UserDTO> getUserData(userId) async {
    var user = await _userRepository.getUserById(userId).first;
    List<FriendDTO> friends = <FriendDTO>[];
    if (user.friends.isNotEmpty) {
      user.friends.forEach((friendId) async {
        var user = await _userRepository.getUserById(friendId).first;
        friends.add(FriendDTO(user.name, user.uid!));
      });
    }
    // var stats = await _statsRepository.getStats(userId).first;
    // return UserDTO(user.uid!, user.name, friends, stats.level, stats.xp,
    //     stats.highScore, stats.bestStreak, stats.leaderBoard);
    return UserDTO(user.uid!, user.name, friends, 0, 0, 0, 0, 0);
  }

  void updateStats(uid, stats) {
    _statsRepository.setStats(uid, stats);
  }

  void addFriend(userId, newFriendId) {
    _userRepository.addFriends(userId, newFriendId);
  }

  void deleteFriend(userId, newFriendId) {
    _userRepository.removeFriends(userId, newFriendId);
  }

  Future<List<User>> getAllFriendsOptions() async {
    return _userRepository.getAllUsers();
  }
}
