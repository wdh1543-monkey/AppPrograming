import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../data/api/claude_api_client.dart';
import '../domain/entities/chat_message.dart';
import '../domain/entities/workout_session.dart';
import '../domain/services/ai_coach_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  AiCoachService? _service;

  static const _uuid = Uuid();

  ChatProvider() {
    final key = dotenv.maybeGet('CLAUDE_API_KEY') ?? '';
    if (key.isNotEmpty && key != 'your_api_key_here') {
      _service = AiCoachService(ClaudeApiClient(key));
    }
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasApiKey => _service != null;

  Future<void> sendMessage(
      String text, List<WorkoutSession> history) async {
    if (text.trim().isEmpty) return;
    _error = null;
    _messages.add(ChatMessage(
      id: _uuid.v4(),
      role: 'user',
      content: text.trim(),
      timestamp: DateTime.now(),
    ));
    _isLoading = true;
    notifyListeners();

    try {
      if (_service == null) {
        throw Exception('API 키가 없습니다. .env 파일에 CLAUDE_API_KEY를 설정하세요.');
      }
      final reply =
          await _service!.chat(messages: _messages, history: history);
      _messages.add(ChatMessage(
        id: _uuid.v4(),
        role: 'assistant',
        content: reply,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }
}
