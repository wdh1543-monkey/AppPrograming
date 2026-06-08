import '../../data/local/database.dart';
import '../entities/exercise_set.dart';
import '../entities/workout_session.dart';

class WorkoutService {
  final _db = AppDatabase();

  Future<int> startSession() =>
      _db.insertSession(WorkoutSession(date: DateTime.now()));

  Future<List<WorkoutSession>> loadAll() => _db.getAllSessions();

  Future<List<WorkoutSession>> loadRecent({int limit = 5}) =>
      _db.getRecentSessions(limit: limit);

  Future<int> saveSet(ExerciseSet set) => _db.insertSet(set);

  Future<void> deleteSet(int id) => _db.deleteSet(id);

  Future<void> finalizeSession(int sessionId, String? notes) async {
    if (notes != null && notes.isNotEmpty) {
      await _db.updateSessionNotes(sessionId, notes);
    }
  }
}
