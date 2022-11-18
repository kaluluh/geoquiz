import '../models/stats.dart';
import '../services/api_path.dart';
import '../services/firebase_datasource.dart';
import '../services/firestore_service.dart';

class StatsRepository {
  StatsRepository();

  final _uid = FirebaseDataSource.instance.currentUser!.uid;
  final _service = FirestoreService.instance;

  Future<void> setStats(Stats stats) => _service.setData(
    path: APIPath.stats(_uid),
    data: stats.toMap(),
  );

  Stream<Stats> getStats() => _service.documentStream(
    path: APIPath.stats(_uid),
    builder: (data, documentId) => Stats.fromMap(data),
  );
}