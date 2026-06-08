class ExerciseSet {
  final int? id;
  final int sessionId;
  final String exerciseName;
  final int setNumber;
  final double weight; // kg
  final int reps;
  final DateTime createdAt;

  const ExerciseSet({
    this.id,
    required this.sessionId,
    required this.exerciseName,
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'session_id': sessionId,
        'exercise_name': exerciseName,
        'set_number': setNumber,
        'weight': weight,
        'reps': reps,
        'created_at': createdAt.toIso8601String(),
      };

  factory ExerciseSet.fromMap(Map<String, dynamic> map) => ExerciseSet(
        id: map['id'] as int?,
        sessionId: map['session_id'] as int,
        exerciseName: map['exercise_name'] as String,
        setNumber: map['set_number'] as int,
        weight: (map['weight'] as num).toDouble(),
        reps: map['reps'] as int,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
