import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_session.dart';

class AppDatabase {
  static Database? _db;

  Future<Database> get _instance async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'workout_ai.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE workout_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            notes TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE exercise_sets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER NOT NULL,
            exercise_name TEXT NOT NULL,
            set_number INTEGER NOT NULL,
            weight REAL NOT NULL,
            reps INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (session_id) REFERENCES workout_sessions (id)
          )
        ''');
      },
    );
  }

  // ── Sessions ──────────────────────────────────────────────────────────────

  Future<int> insertSession(WorkoutSession session) async {
    final db = await _instance;
    return db.insert('workout_sessions', session.toMap());
  }

  Future<List<WorkoutSession>> getAllSessions() async {
    final db = await _instance;
    final rows =
        await db.query('workout_sessions', orderBy: 'date DESC');
    return _attachSets(rows.map(WorkoutSession.fromMap).toList());
  }

  Future<List<WorkoutSession>> getRecentSessions({int limit = 5}) async {
    final db = await _instance;
    final rows = await db.query('workout_sessions',
        orderBy: 'date DESC', limit: limit);
    return _attachSets(rows.map(WorkoutSession.fromMap).toList());
  }

  Future<void> updateSessionNotes(int id, String notes) async {
    final db = await _instance;
    await db.update(
      'workout_sessions',
      {'notes': notes},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ── Exercise Sets ─────────────────────────────────────────────────────────

  Future<int> insertSet(ExerciseSet set) async {
    final db = await _instance;
    return db.insert('exercise_sets', set.toMap());
  }

  Future<List<ExerciseSet>> getSetsForSession(int sessionId) async {
    final db = await _instance;
    final rows = await db.query(
      'exercise_sets',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'exercise_name, set_number',
    );
    return rows.map(ExerciseSet.fromMap).toList();
  }

  Future<void> deleteSet(int id) async {
    final db = await _instance;
    await db.delete('exercise_sets', where: 'id = ?', whereArgs: [id]);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<List<WorkoutSession>> _attachSets(
      List<WorkoutSession> sessions) async {
    for (var i = 0; i < sessions.length; i++) {
      final sets = await getSetsForSession(sessions[i].id!);
      sessions[i] = sessions[i].copyWith(sets: sets);
    }
    return sessions;
  }
}
