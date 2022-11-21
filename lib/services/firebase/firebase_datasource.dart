import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseDataSource{
  FirebaseDataSource._();
  static final instance = FirebaseDataSource._();

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  FirebaseFirestore get fireStore => FirebaseFirestore.instance;
}

