import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/workout_provider.dart';
import '../widgets/workout_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout = context.watch<WorkoutProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('운동 히스토리')),
      body: workout.isLoading
          ? const Center(child: CircularProgressIndicator())
          : workout.sessions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fitness_center,
                          size: 64,
                          color: theme.colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Text(
                        '운동 기록이 없습니다',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '홈 화면에서 운동을 기록해보세요',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: workout.sessions.length,
                  itemBuilder: (_, i) =>
                      WorkoutCard(session: workout.sessions[i]),
                ),
    );
  }
}
