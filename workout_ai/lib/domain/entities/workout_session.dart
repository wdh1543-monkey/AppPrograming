import 'exercise_set.dart';

class WorkoutSession {
  final int? id;
  final DateTime date;
  final String? notes;
  final List<ExerciseSet> sets;

  const WorkoutSession({
    this.id,
    required this.date,
    this.notes,
    this.sets = const [],
  });

  double get totalVolume =>
      sets.fold(0.0, (sum, s) => sum + s.weight * s.reps);

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  factory WorkoutSession.fromMap(Map<String, dynamic> map) => WorkoutSession(
        id: map['id'] as int?,
        date: DateTime.parse(map['date'] as String),
        notes: map['notes'] as String?,
      );

  WorkoutSession copyWith({List<ExerciseSet>? sets, String? notes}) =>
      WorkoutSession(
        id: id,
        date: date,
        notes: notes ?? this.notes,
        sets: sets ?? this.sets,
      );
}
