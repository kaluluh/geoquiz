import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../services/firebase/api_path.dart';
import '../services/firebase/firestore_service.dart';


class UserRepository {
  UserRepository();

  final _service = FirestoreService.instance;
  final _database = FirebaseFirestore.instance.collection('users');


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

  Future<User> getUserByCode(String code) async {
    // Split code at # to get the name and the first 4 letters of uid
    var name = code.split('#')[0];
    var uid = code.split('#')[1];
    // Find first user whose name is equal to the first part of friendCode
    // and whose first 4 letters of uid is equal to the second part of friendCode

    // Loop through all users
    var users = await _database.get();
    for (var user in users.docs) {
      // If the name and the first 4 letters of uid is equal to the code
      if (user.data()['name'] == name && user.id.substring(0, 4) == uid) {
        // Return the user
        return User.fromMap(user.data());
      }
    }
    // If no user is found, return an empty user
    return User('', '', <String>[]);
  }

  Future<bool> isUserExists(String userId) async {
    var user = await getUserById(userId).first;
    return user != null ? true : false;
  }

  Future<bool> checkUserExist(String userId) async {
    try{
      var user = await _database.doc(userId).get();
      return user.exists;
    } catch (e) {
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
      await setUser(user);
  }

  Future<void> removeFriends(String userId,String newFriendId) async {
    final user = await getUserById(userId).first;
    user.friends.remove(newFriendId);
    await setUser(user);
  }
}