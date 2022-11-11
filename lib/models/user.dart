import 'friend.dart';

class User {
  final String? uid;
  final String name;
  final String country;
  final List<dynamic> friends;

  User(this.uid, this.name, this.country,[this.friends = const <Friend>[] ]);

  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'name': name,
      'country': country,
      'friends': friends
    };
  }

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(documentId, data['name'], data['country'],data['friends']);
  }
}