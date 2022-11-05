import 'dart:convert';

import 'friend.dart';

class User {
  final String? uid;
  final String first_name;
  final String last_name;
  final String country;
  final List<dynamic> friends;

  User(this.uid, this.first_name, this.last_name, this.country,[this.friends = const <Friend>[] ]);

  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'first_name': first_name,
      'last_name': last_name,
      'country': country,
      'friends': friends
    };
  }

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(documentId, data['first_name'], data['last_name'], data['country'],data['friends']);
  }
}