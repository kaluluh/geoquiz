import '../models/stats.dart';
import '../services/api_path.dart';
import '../services/firebase_datasource.dart';
import '../services/firestore_service.dart';

class StatsRepository {
  StatsRepository();

  final _service = FirestoreService.instance;

  Future<void> setStats(uid,Stats stats) => _service.setData(
    path: APIPath.stats(uid),
    data: stats.toMap(),
  );

  Stream<Stats> getStats(uid) => _service.documentStream(
    path: APIPath.stats(uid),
    builder: (data, documentId) => Stats.fromMap(data),
  );
}