# 테스트 — workout_ai

> 프레임워크: Flutter Test (flutter_test) · 도구: `flutter test`

---

## 테스트 실행

### 전체 실행

```bash
cd workout_ai
flutter test
```

### 특정 파일 실행

```bash
flutter test test/unit/workout_service_test.dart
flutter test test/widget/chat_screen_test.dart
```

### 상세 출력

```bash
flutter test --reporter expanded
```

---

## 테스트 구조

```
workout_ai/
└── test/
    ├── unit/
    │   ├── workout_service_test.dart   # 운동 CRUD 로직
    │   ├── ai_coach_service_test.dart  # 프롬프트 구성 검증
    │   └── database_test.dart          # SQLite 스키마 / CRUD
    └── widget/
        ├── chat_screen_test.dart       # 채팅 UI 렌더링
        ├── record_screen_test.dart     # 기록 입력 폼
        └── home_screen_test.dart       # 홈 화면 카드 표시
```

---

## 단위 테스트

### 대상: WorkoutService (운동 기록 CRUD)

`WorkoutService`의 세션 생성 / 세트 저장 / 삭제 로직을 인메모리 DB로 검증한다.

```dart
// test/unit/workout_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_ai/domain/services/workout_service.dart';
import 'package:workout_ai/domain/entities/exercise_set.dart';

void main() {
  late WorkoutService service;

  setUp(() {
    service = WorkoutService(db: InMemoryDatabase());
  });

  test('세션 생성 시 ID가 부여된다', () async {
    final session = await service.createSession(date: '2026-06-14');
    expect(session.id, isNotNull);
  });

  test('세트 저장 후 조회 시 동일 값이 반환된다', () async {
    final session = await service.createSession(date: '2026-06-14');
    final set = ExerciseSet(
      sessionId: session.id!,
      exerciseName: '벤치프레스',
      setNumber: 1,
      weight: 70.0,
      reps: 8,
      createdAt: DateTime.now().toIso8601String(),
    );
    await service.saveExerciseSet(set);
    final sets = await service.getSetsForSession(session.id!);
    expect(sets.length, 1);
    expect(sets.first.exerciseName, '벤치프레스');
  });
}
```

### 대상: AiCoachService (프롬프트 구성)

Claude API를 Mock으로 교체해 프롬프트가 올바르게 구성되는지만 검증한다.

```dart
// test/unit/ai_coach_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_ai/domain/services/ai_coach_service.dart';

class MockClaudeClient implements ClaudeApiClient {
  String? capturedSystem;
  @override
  Future<String> call({required String systemPrompt, required List messages, int maxTokens = 1024}) async {
    capturedSystem = systemPrompt;
    return '오늘은 벤치프레스 3세트를 추천합니다.';
  }
}

void main() {
  test('시스템 프롬프트에 운동 이력이 포함된다', () async {
    final mock = MockClaudeClient();
    final service = AiCoachService(mock);
    await service.chat(messages: [], history: [/* 이전 세션 */]);
    expect(mock.capturedSystem, contains('운동 이력'));
  });
}
```

---

## 위젯 테스트 (통합 관점)

화면 렌더링 + 사용자 입력 흐름을 검증한다.

```dart
// test/widget/chat_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_ai/application/chat_provider.dart';
import 'package:workout_ai/presentation/screens/chat_screen.dart';

void main() {
  testWidgets('메시지 입력 후 전송 시 말풍선이 표시된다', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField), '오늘 운동 추천해줘');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('오늘 운동 추천해줘'), findsOneWidget);
  });

  testWidgets('API 키 없을 때 경고 메시지가 표시된다', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
        child: const MaterialApp(home: ChatScreen()),
      ),
    );
    expect(find.textContaining('API 키'), findsOneWidget);
  });
}
```

---

## 테스트 작성 규약

- 파일명: `<대상>_test.dart`
- 테스트명: 한국어로 **"~할 때 ~이다"** 형식
- Mock은 인터페이스 기반으로 작성 — 실제 DB/API 호출 금지
- `setUp` / `tearDown`으로 상태 격리
- 외부 의존(Claude API) 은 반드시 Mock 처리

---

## 수동 통합 테스트 시나리오

자동화 범위 밖의 흐름은 기기에서 직접 확인한다.

| # | 시나리오 | 기대 결과 | 확인 |
|---|---|---|---|
| 1 | 앱 최초 실행 | 홈 화면 표시, 이전 기록 없음 | ✅ |
| 2 | AI 대화 — "오늘 운동 추천" 입력 | Claude 응답 말풍선 표시 | ✅ |
| 3 | 운동 기록 입력 (벤치 70kg × 8) | 기록 화면에 저장됨 | ✅ |
| 4 | 히스토리 화면 조회 | 저장된 세션 목록 표시 | ✅ |
| 5 | 앱 재시작 후 히스토리 유지 | SQLite에서 복원됨 | ✅ |
| 6 | 네트워크 없이 기록 저장 | 오프라인 동작 정상 | ✅ |
| 7 | API 키 없이 대화 시도 | 오류 메시지 표시 | ✅ |
