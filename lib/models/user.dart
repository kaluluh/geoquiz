class User {
  final String? uid;
  final String name;
  final String country;
  final List<String> friends;

  User(this.uid, this.name, this.country,this.friends);

  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'name': name,
      'country': country,
      'friends': friends
    };
  }

  String toString() {
    return "$name $uid $country $friends";
  }
  factory User.fromMap(Map<String, dynamic> data) {
    return User(data['uid'], data['name'], data['country'],data['friends'].cast<String>());
  }
}