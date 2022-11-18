import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../services/api_path.dart';
import '../services/firebase_datasource.dart';
import '../services/firestore_service.dart';

class UserRepository {
  UserRepository();

  final _service = FirestoreService.instance;
  final _uid = FirebaseDataSource.instance.currentUser!.uid;
  final _database = FirebaseDataSource.instance.fireStore.collection('users');


  Future<void> setUser(User user) => _service.setData(
    path: APIPath.users(_uid),
    data: user.toMap(),
  );

  Stream<User> getUserById(String userId) => _service.documentStream(
    path: APIPath.users(userId),
    builder: (data, documentId) => User.fromMap(data),
  );

  Future<List<User>> getAllUsers() async{
    QuerySnapshot querySnapshot = await _database.get();
    final allData = await querySnapshot.docs.map((doc) =>
        User.fromMap(doc.data() as Map<String, dynamic>)).toList();
    return allData;
  }

  Future<void> addFriends(String userId,String newFriendId) async {
      final user = await getUserById(userId).first;
      user.friends.add(newFriendId);
      setUser(user);
  }

  Future<void> removeFriends(String userId,String newFriendId) async {
    final user = await getUserById(userId).first;
    user.friends.remove(newFriendId);
    setUser(user);
  }
}