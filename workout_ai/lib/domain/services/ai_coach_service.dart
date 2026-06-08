import '../../data/api/claude_api_client.dart';
import '../entities/chat_message.dart';
import '../entities/workout_session.dart';

class AiCoachService {
  final ClaudeApiClient _client;

  AiCoachService(this._client);

  Future<String> chat({
    required List<ChatMessage> messages,
    required List<WorkoutSession> history,
  }) async {
    final systemPrompt = _buildSystemPrompt(history);
    final apiMessages = messages
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();
    return _client.call(systemPrompt: systemPrompt, messages: apiMessages);
  }

  String _buildSystemPrompt(List<WorkoutSession> history) {
    final buf = StringBuffer();
    buf.writeln('당신은 전문 AI 퍼스널 트레이너입니다. 항상 한국어로 답변하세요.');
    buf.writeln('운동 계획 제안 시 구체적인 종목·세트·무게(kg)·횟수를 포함하세요.');
    buf.writeln('볼륨(무게×횟수) 기준으로 성장률을 분석하고 다음 목표를 제안하세요.');

    if (history.isEmpty) {
      buf.writeln('\n운동 기록이 없습니다. 사용자의 목표와 수준을 파악하여 첫 루틴을 제안하세요.');
      return buf.toString();
    }

    buf.writeln('\n## 최근 운동 기록 (최대 5회)');
    for (final session in history.take(5)) {
      buf.writeln('\n### ${_fmtDate(session.date)}');
      final grouped = <String, List<dynamic>>{};
      for (final s in session.sets) {
        grouped.putIfAbsent(s.exerciseName, () => []).add(s);
      }
      for (final entry in grouped.entries) {
        final setsStr =
            entry.value.map((s) => '${s.weight}kg × ${s.reps}회').join(', ');
        buf.writeln('- ${entry.key}: $setsStr');
      }
      if (session.totalVolume > 0) {
        buf.writeln('  총 볼륨: ${session.totalVolume.toStringAsFixed(0)}kg');
      }
    }
    return buf.toString();
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
