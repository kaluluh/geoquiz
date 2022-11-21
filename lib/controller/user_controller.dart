import 'package:geoquiz/controller/dtos/userdto.dart';
import 'package:geoquiz/repository/stats_repository.dart';
import 'package:geoquiz/repository/user_repository.dart';
import 'package:geoquiz/services/auth.dart';

import '../models/stats.dart';
import '../models/user.dart';

class UserController {
  late UserRepository _userRepository;
  late StatsRepository _statsRepository;

  UserController() {
    _userRepository = UserRepository();
    _statsRepository = StatsRepository();
  }

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

  Future<UserDTO> getUserData(userId) async {
    var user = await _userRepository.getUserById(userId).first;
    var stats = await _statsRepository.getStats(userId).first;
   return  UserDTO(user.uid!,
       user.name,
       user.friends,
       stats.level,
       stats.xp,
       stats.highScore,
       stats.highScore,
       stats.leaderBoard);
  }

  // Future<User> _getUser(userId) async {
  //   return await _userRepository.getUserById(userId).first;
  // }
}
