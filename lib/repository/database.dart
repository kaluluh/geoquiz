import 'package:geoquiz/services/api_path.dart';

import '../models/city.dart';
import '../models/stats.dart';
import '../models/user.dart';
import '../services/firestore_service.dart';

abstract class Database {
  Future<void> setUserDetails(User userData);
  Stream<User> userDetailStream();

  Future<void> setStats(Stats stats);
  Stream<Stats> getStats();

  Future<void> setCityDetails(City city);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setUserDetails(User userData) => _service.setData(
      path: APIPath.users(uid),
      data: userData.toMap(),
  );

  @override
  Stream<User> userDetailStream() => _service.documentStream(
    path: APIPath.users(uid),
    builder: (data, documentId) => User.fromMap(data),
  );

  @override
  Future<void> setStats(Stats stats) => _service.setData(
    path: APIPath.stats(uid),
    data: stats.toMap(),
  );

  @override
  Stream<Stats> getStats() => _service.documentStream(
    path: APIPath.stats(uid),
    builder: (data, documentId) => Stats.fromMap(data),
  );

  @override
  Future<void> setCityDetails(City city) => _service.setData(
    path: APIPath.cities(uid, city.name),
    data: city.toMap(),
  );
}