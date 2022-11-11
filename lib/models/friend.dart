class Friend {
  final String uid;
  final String name;

  Friend(this.uid,this.name);

  Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'name': name
    };
  }

  factory Friend.fromMap(Map<String, dynamic> data) {
    return Friend(data['uid'], data['name']);
  }
}