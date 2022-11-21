class User {
  final String? uid;
  final String name;
  final List<String> friends;

  User(this.uid, this.name,this.friends);

  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'name': name,
      'friends': friends
    };
  }

  String toString() {
    return "$name $uid $friends";
  }
  factory User.fromMap(Map<String, dynamic> data) {
    return User(data['uid'], data['name'],data['friends'].cast<String>());
  }
}