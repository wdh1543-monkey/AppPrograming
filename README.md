# workout_ai

> AI 퍼스널 트레이너를 주머니에 — 대화 한 마디로 오늘 운동이 결정되고, 끝나면 기록이 분석된다.

## 개요

혼자 운동하는 중급자를 위한 AI 코칭 앱. Claude API와 대화하며 운동 계획을 받고, 기록하고, 피드백을 얻는다.

| 기술 | 선택 |
|---|---|
| 프레임워크 | Flutter 3.x (Dart) |
| 상태관리 | Provider (ChangeNotifier) |
| 로컬 저장소 | sqflite (SQLite) |
| AI | Claude API (claude-haiku-4-5) |
| HTTP | http 패키지 |

> **참고:** 초기 설계는 React Native (Expo)였으나 11주차 npm 의존성 충돌로 Flutter로 전환 (ADR-0001)

## 빌드 및 실행

```bash
git clone https://github.com/wdh1543-monkey/AppPrograming.git
cd AppPrograming/workout_ai
flutter pub get
copy .env.example .env   # macOS/Linux: cp .env.example .env
# .env 에 CLAUDE_API_KEY 입력
flutter run
```

자세한 설정은 [docs/setup.md](docs/setup.md) 참고.

## 팀 구성

| 이름 | 역할 |
|---|---|
| 원동현 | 1인 개발 |

## 링크

- [WBS 진행 현황](https://wdh1543-monkey.github.io/AppPrograming/)
- [아키텍처 문서](docs/architecture.md)
- [Setup 가이드](docs/setup.md)
- [빌드 및 배포](docs/deploy.md)
- [테스트](docs/testing.md)
- [ADR 목록](.planning/decisions/)
