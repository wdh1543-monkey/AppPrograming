import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/chat_provider.dart';
import '../../application/workout_provider.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    final history = context.read<WorkoutProvider>().recentSessions;
    context.read<ChatProvider>().sendMessage(text, history);
    _scheduleScrollToBottom();
  }

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final theme = Theme.of(context);

    if (chat.messages.isNotEmpty) _scheduleScrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 코치'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: '대화 초기화',
            onPressed: () => context.read<ChatProvider>().clearMessages(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!chat.hasApiKey)
            _Banner(
              message: 'API 키가 없습니다. .env 파일에 CLAUDE_API_KEY를 설정하세요.',
              color: theme.colorScheme.errorContainer,
              textColor: theme.colorScheme.onErrorContainer,
            ),
          if (chat.error != null)
            _Banner(
              message: chat.error!,
              color: theme.colorScheme.errorContainer,
              textColor: theme.colorScheme.onErrorContainer,
            ),
          Expanded(
            child: chat.messages.isEmpty
                ? _EmptyHint(theme: theme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: chat.messages.length,
                    itemBuilder: (_, i) =>
                        ChatBubble(message: chat.messages[i]),
                  ),
          ),
          if (chat.isLoading)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 8),
                  Text('AI가 답변 중...', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '오늘 운동 계획을 물어보세요',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: 'chat_send',
                    onPressed: chat.isLoading ? null : _send,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String message;
  final Color color;
  final Color textColor;

  const _Banner(
      {required this.message,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(message,
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor)),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final ThemeData theme;

  const _EmptyHint({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 64, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              '"오늘 어깨랑 삼두 할게,\n지난주보다 강도 조금 올려줘"',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
