import 'package:geoquiz/controller/dtos/userdto.dart';
import 'package:geoquiz/repository/stats_repository.dart';
import 'package:geoquiz/repository/user_repository.dart';

import '../models/stats.dart';
import '../models/user.dart';
import '../services/firebase/auth.dart';
import 'dtos/Friend.dart';

//Routes the incoming requests towards to the business logic
class UserController {
  late UserRepository _userRepository;
  late StatsRepository _statsRepository;

  UserController() {
    _userRepository = UserRepository();
    _statsRepository = StatsRepository();
  }

  //To set the user data
  Future<void> setUserData(AuthBase auth) async {
    var uid = auth.currentUser!.uid;
    if(_userRepository.checkUserExist(uid) == false){
      var name = auth.currentUser?.isAnonymous == true ? "anonymous": auth.currentUser?.email?.split('@')[0];
      var newUser = User(uid,
          name!,
          <String>[]);
      _userRepository.setUser(newUser);
      _statsRepository.setStats(uid,Stats(0,0,0,0,0));
    }
  }

  //Get user data by Id, returning with a UserDTO instance
  Future<UserDTO> getUserData(userId) async {
    var user = await _userRepository.getUserById(userId).first;
    List<Friend> friends = <Friend>[];
    if(user.friends.isNotEmpty){
      user.friends.forEach((friendId) async {
        var user = await _userRepository.getUserById(friendId).first;
        friends.add(Friend(user.name, user.uid!));
      });
    }
    var stats = await _statsRepository.getStats(userId).first;
   return UserDTO(user.uid!,
       user.name,
       friends,
       stats.level,
       stats.xp,
       stats.highScore,
       stats.highScore,
       stats.leaderBoard);
  }

  void updateStats(uid,stats) {
    // TO DO .. DTO CLASS
    _statsRepository.setStats(uid, stats);
  }

  void addFriend(userId,newFriendId) {
    _userRepository.addFriends(userId, newFriendId);
  }

  void deleteFriend(userId,newFriendId) {
    _userRepository.removeFriends(userId, newFriendId);
  }

  Future<List<User>> getAllFriendsOptions() async {
    return _userRepository.getAllUsers();
  }
}
