import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeApiClient {
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-haiku-4-5';
  static const _anthropicVersion = '2023-06-01';

  final String apiKey;

  ClaudeApiClient(this.apiKey);

  Future<String> call({
    required String systemPrompt,
    required List<Map<String, String>> messages,
    int maxTokens = 1024,
  }) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': _anthropicVersion,
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': maxTokens,
        'system': systemPrompt,
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Claude API 오류 ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    return (content.first as Map<String, dynamic>)['text'] as String;
  }
}
