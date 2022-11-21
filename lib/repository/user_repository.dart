import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../services/api_path.dart';
import '../services/firebase_datasource.dart';
import '../services/firestore_service.dart';

class UserRepository {
  UserRepository();

  final _service = FirestoreService.instance;
  final _database = FirebaseDataSource.instance.fireStore.collection('users');


  Future<void> setUser(User user) => _service.setData(
    path: APIPath.users(user.uid!),
    data: user.toMap(),
  );

  Future<void> deleteUser (User user) => _service.deleteData(
    path: APIPath.users(user.uid!)
  );

  Stream<User> getUserById(String userId) => _service.documentStream(
    path: APIPath.users(userId),
    builder: (data, documentId) => User.fromMap(data),
  );

  Future<bool> isUserExists(String userId) async {
    var user = await getUserById(userId).first;
    return user != null ? true : false;
  }

  bool checkUserExist(String userId) {
    try {
      bool exist = false;
      _database.doc(userId).get().then((doc) {
        return exist = doc.exists;
      });
       return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

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