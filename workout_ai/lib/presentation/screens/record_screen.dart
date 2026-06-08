import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/workout_provider.dart';
import '../widgets/set_input_form.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final workout = context.read<WorkoutProvider>();
      if (!workout.hasActiveSession) await workout.startSession();
    });
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final workout = context.read<WorkoutProvider>();
    if (workout.pendingSets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('세트를 하나 이상 추가해주세요')),
      );
      return;
    }
    await workout.saveSession(notes: _notesCtrl.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('운동 기록이 저장되었습니다 💪')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workout = context.watch<WorkoutProvider>();
    final theme = Theme.of(context);

    final grouped = <String, List<dynamic>>{};
    for (final s in workout.pendingSets) {
      grouped.putIfAbsent(s.exerciseName, () => []).add(s);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기록'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            workout.cancelSession();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SetInputForm(
              onAdd: (exercise, weight, reps) =>
                  workout.addPendingSet(exercise, weight, reps),
            ),
            const SizedBox(height: 16),
            if (grouped.isNotEmpty) ...[
              Text('입력된 세트',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: grouped.entries.map((entry) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            ...entry.value.map((s) {
                              final idx = workout.pendingSets.indexWhere((x) =>
                                  x.exerciseName == s.exerciseName &&
                                  x.setNumber == s.setNumber);
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                    '${s.setNumber}세트  ${s.weight}kg × ${s.reps}회'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 18),
                                  onPressed: idx >= 0
                                      ? () => workout.removePendingSet(idx)
                                      : null,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ] else
              const Expanded(child: SizedBox()),
            const SizedBox(height: 8),
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: '메모 (선택)',
                hintText: '오늘 운동 특이사항을 기록하세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('기록 저장'),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
