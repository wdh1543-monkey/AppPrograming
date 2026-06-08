import 'package:flutter/foundation.dart';
import '../domain/entities/exercise_set.dart';
import '../domain/entities/workout_session.dart';
import '../domain/services/workout_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final _service = WorkoutService();

  List<WorkoutSession> _sessions = [];
  WorkoutSession? _currentSession;
  final List<ExerciseSet> _pendingSets = [];
  bool _isLoading = false;

  List<WorkoutSession> get sessions => _sessions;
  WorkoutSession? get currentSession => _currentSession;
  List<ExerciseSet> get pendingSets => List.unmodifiable(_pendingSets);
  bool get isLoading => _isLoading;
  bool get hasActiveSession => _currentSession != null;
  List<WorkoutSession> get recentSessions => _sessions.take(5).toList();

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _sessions = await _service.loadAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> startSession() async {
    final id = await _service.startSession();
    _currentSession = WorkoutSession(id: id, date: DateTime.now());
    _pendingSets.clear();
    notifyListeners();
  }

  void addPendingSet(String exerciseName, double weight, int reps) {
    if (_currentSession == null) return;
    final existing =
        _pendingSets.where((s) => s.exerciseName == exerciseName).length;
    _pendingSets.add(ExerciseSet(
      sessionId: _currentSession!.id!,
      exerciseName: exerciseName,
      setNumber: existing + 1,
      weight: weight,
      reps: reps,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void removePendingSet(int index) {
    if (index < 0 || index >= _pendingSets.length) return;
    _pendingSets.removeAt(index);
    notifyListeners();
  }

  Future<void> saveSession({String? notes}) async {
    if (_currentSession == null) return;
    for (final set in _pendingSets) {
      await _service.saveSet(set);
    }
    await _service.finalizeSession(_currentSession!.id!, notes);
    _currentSession = null;
    _pendingSets.clear();
    await init();
  }

  void cancelSession() {
    _currentSession = null;
    _pendingSets.clear();
    notifyListeners();
  }
}
