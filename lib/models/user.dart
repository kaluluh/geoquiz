//For sending User data to database
class User {
  final String? uid;
  final String name;
  final List<String> friends;

  User(this.uid, this.name,this.friends);

 // Convert User to Map<String,dynamic>
  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'name': name,
      'friends': friends
    };
  }

  //Show user data easily
  String toString() {
    return "$name $uid $friends";
  }

  //Convert Map<String, dynamic> to User
  factory User.fromMap(Map<String, dynamic> data) {
    return User(data['uid'], data['name'],data['friends'].cast<String>());
  }
}