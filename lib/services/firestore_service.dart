import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore store = FirebaseFirestore.instance;

  Stream<Iterable<T>> getCollectionStream<T>(
      String path, T Function(Map<String, dynamic>) converter) {
    print("Get collection items at $path");

    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
    store.collection(path).snapshots();

    return snapshots.map((collectionSnapshot) {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          collectionSnapshot.docs;

      return documents
          .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
        final Map<String, dynamic> data = document.data();
        return converter(data);
      });
    });
  }

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<T> documentStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }
}