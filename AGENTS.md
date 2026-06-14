# AGENTS.md — workout_ai

> AI 에이전트가 이 프로젝트에서 작업할 때 반드시 참조하는 정책 파일.

---

## 프로젝트 개요

**workout_ai** — Claude API 기반 AI 퍼스널 트레이너 앱 (Flutter / Android)

| 항목 | 값 |
|---|---|
| 개발자 | 원동현 (1인) |
| 프레임워크 | Flutter 3.x (Dart) |
| AI | Claude API — `claude-haiku-4-5` |
| 저장소 | sqflite (로컬 SQLite) |
| 상태관리 | Provider (ChangeNotifier) |
| 레포 | `wdh1543-monkey/AppPrograming` |

---

## 아키텍처 규칙

레이어 의존 방향을 반드시 준수한다.

```
Presentation → Application(Provider) → Domain(Service/Entity) → Data(Repository)
```

- **Presentation**(`lib/presentation/`)은 Provider만 참조한다. Service·Repository를 직접 호출하지 않는다.
- **Domain**(`lib/domain/`)은 Flutter·외부 패키지에 의존하지 않는다.
- **Data**(`lib/data/`)에만 `http`, `sqflite` 등 외부 패키지를 사용한다.
- Claude API 호출은 `lib/data/api/claude_api_client.dart` 에서만 한다.

---

## 코딩 규약

- 언어: Dart — null safety 필수, `late` 남용 금지
- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- 비동기: `async/await` 사용, `.then()` 체이닝 금지
- 상태 변경: `notifyListeners()` 호출 전 상태를 먼저 업데이트한다
- API 키: 절대 하드코딩 금지 — `.env` 파일에서만 로드 (`flutter_dotenv`)
- `.env`는 `.gitignore`에 포함 — 커밋 금지

---

## 주요 의사결정 (ADR)

코드 변경 전 아래 ADR을 확인한다. 이미 검토하고 선택한 기술은 재논의 없이 따른다.

| ADR | 결정 | 파일 |
|---|---|---|
| ADR-0001 | 프레임워크: Flutter (React Native npm 충돌로 전환) | `.planning/decisions/ADR-0001-mobile-framework.md` |
| ADR-0002 | 저장소: sqflite (Firebase 제외) | `.planning/decisions/ADR-0002-local-storage.md` |
| ADR-0003 | 상태관리: Provider (Riverpod/Bloc 과함) | `.planning/decisions/ADR-0003-state-management.md` |

새로운 기술 선택 시 `.planning/decisions/ADR-XXXX-<title>.md`를 추가한다.

---

## 금지 사항

- `flutter pub add` 없이 `pubspec.yaml`에 패키지 직접 추가 금지
- `lib/` 밖에 비즈니스 로직 작성 금지
- `flutter_test` 없이 테스트 코드 작성 금지
- API 응답을 Provider에서 직접 파싱 금지 — Service 레이어 경유
- `.env` 파일 커밋 금지

---

## 참조 문서

| 문서 | 위치 |
|---|---|
| 아키텍처 | `docs/architecture.md` |
| 개발환경 설정 | `docs/setup.md` |
| 빌드 및 배포 | `docs/deploy.md` |
| 테스트 | `docs/testing.md` |
| Expo 참고 (현재 미사용) | `workout_ai/AGENTS.md` |

---

## Expo 참고

> `workout_ai/AGENTS.md`에 Expo 관련 메모가 있으나 현재 프로젝트는 Flutter 기반.
> React Native / Expo 코드 생성 금지.
