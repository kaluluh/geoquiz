class Friend {
  final String uid;
  final String first_name;
  final String last_name;

  Friend(this.uid,this.first_name,this.last_name);

  Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'first_name': first_name,
      'last_name': last_name,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> data) {
    return Friend(data['uid'], data['first_name'], data['last_name']);
  }
}