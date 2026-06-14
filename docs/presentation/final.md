---
marp: true
theme: default
paginate: true
style: |
  section { font-family: 'Noto Sans KR', sans-serif; }
  section.title { background: #1a1a2e; color: #fff; }
  section.title h1 { font-size: 2.2em; }
  section.title p { color: #a0a8c0; }
  h2 { color: #2563eb; border-bottom: 2px solid #2563eb; padding-bottom: 6px; }
  .highlight { background: #eff6ff; border-left: 4px solid #2563eb; padding: 8px 12px; margin: 8px 0; }
  table { font-size: 0.85em; }
  code { background: #f1f5f9; }
---

<!-- _class: title -->

# AI 퍼스널 트레이너를 주머니에
### workout_ai — Claude API 기반 운동 코칭 앱

**원동현** · 앱프로그래밍응용 최종 발표

<!-- 대본: 안녕하세요. "AI 퍼스널 트레이너를 주머니에"라는 비전으로 만든 workout_ai를 발표하겠습니다. -->

---

## 비전

> **"대화 한 마디로 오늘 운동이 결정되고, 끝나면 기록이 분석된다."**

<div class="highlight">
혼자 운동하는 중급자를 위한 AI 코칭 앱<br>
Claude API와 대화하며 운동 계획을 받고, 기록하고, 피드백을 얻는다.
</div>

- PT 없이도 → **AI가 오늘 루틴을 제안**
- 기록만 남기는 게 아니라 → **AI가 분석하고 다음 목표를 제시**
- 일정이 바뀌면 → **AI에게 말하면 루틴이 자동으로 재배치**

<!-- 대본: 이 앱의 비전은 "대화 한 마디로 오늘 운동이 결정되고, 끝나면 기록이 분석된다"입니다. 헬스장 가기 전에 앱을 열고 "오늘 어깨랑 삼두 할게"라고 말하면 AI가 지난 기록을 보고 오늘 루틴을 제안해 줍니다. -->

---

## 문제 정의

**혼자 운동하는 중급자**는 방법을 아는 것과 꾸준히 실천하는 것 사이 간극이 크다.

| 고통 | 현실 |
|---|---|
| 계획이 흐트러진다 | 월요일에 세운 루틴, 수요일이면 사라짐 |
| 기록해도 분석 못 한다 | 노트에 적었지만 성장했는지 모름 |
| 루틴 조정이 어렵다 | 야근으로 하루 빠지면 그 주 루틴 붕괴 |

→ **PT비 없이 이 세 문제를 동시에 해결하는 도구가 없다**

<!-- 대본: 문제를 정의하겠습니다. 혼자 운동하는 중급자는 세 가지 고통이 있습니다. 계획이 흐트러지고, 기록해도 분석이 안 되고, 일정 하나가 틀어지면 루틴 전체가 무너집니다. PT를 끊으면 해결이 되지만, 비용이 문제입니다. 이 세 가지를 AI 대화 하나로 해결하고자 했습니다. -->

---

## 프로젝트 계획 — WBS & 기술 스택

**6주 일정 (10주차 ~ 15주차)**

| 주차 | 핵심 목표 | 완료 여부 |
|---|---|---|
| 10주 | 기획·ADR 수립 | ✅ |
| 11주 | 아키텍처 설계 · 환경 구축 | ✅ |
| 12주 | AI 채팅 + 기록 입력 (중간 발표) | ✅ |
| 13주 | 히스토리 · 테스트 | ✅ |
| 14주 | 배포 · 문서 완비 | ✅ |
| 15주 | **최종 발표** | ← 지금 |

**기술 스택:** Flutter 3.x · Claude Haiku · sqflite · Provider

<!-- 대본: 10주차부터 15주차까지 6주간 진행했습니다. 기획과 ADR 수립으로 시작해서 아키텍처 설계, 핵심 기능 구현, 테스트, 문서화 순으로 진행했고 오늘 최종 발표까지 완료했습니다. 기술 스택은 Flutter, Claude Haiku API, sqflite, Provider입니다. -->

---

## 구현 시행착오 — React Native → Flutter 전환

**가장 큰 위기: 11주차 환경 구축 단계**

```
npm install
→ peer deps 충돌 15개 발생
→ 3시간 디버깅
→ 해결 불가 판단
```

**의사결정 (ADR-0001):**

| 대안 | 결과 |
|---|---|
| React Native (Expo) | ❌ npm 의존성 충돌로 설치 자체 실패 |
| Android 네이티브 (Kotlin) | ❌ iOS 미지원, 학습비용 과다 |
| **Flutter (Dart)** | ✅ `flutter pub get` 한 줄, 즉시 빌드 성공 |

→ **프레임워크를 바꾸고 일정을 지켰다**

<!-- 대본: 가장 큰 시행착오를 말씀드리겠습니다. 11주차에 React Native 환경을 구축하다가 npm 의존성 충돌로 3시간을 디버깅해도 해결이 안 됐습니다. 개발자라면 이 상황에서 두 가지 선택을 합니다. 계속 싸우거나, 도구를 바꾸거나. 저는 Flutter로 전환했고 flutter pub get 한 줄로 의존성 설치가 완료됐습니다. 이 결정을 ADR-0001에 기록했습니다. -->

---

## 아키텍처 — 4레이어 클린 아키텍처

```
사용자 입력
    ↓
Presentation  (Screen / Widget)
    ↓
Application   (ChatProvider / WorkoutProvider)
    ↓
Domain        (AiCoachService / WorkoutService / Entity)
    ↓
Data          (ClaudeApiClient / AppDatabase)
    ↓
Claude API  /  SQLite
```

**레이어 규칙:** 위→아래 단방향 의존 / Domain은 외부 패키지 미사용

<!-- 대본: 아키텍처는 4레이어 클린 아키텍처를 적용했습니다. Presentation이 Provider를 통해 Domain의 서비스를 호출하고, Data 레이어가 Claude API와 SQLite에 접근합니다. 핵심 규칙은 단방향 의존성입니다. Domain은 Flutter나 http 패키지에 의존하지 않아서 테스트가 쉽습니다. -->

---

## 핵심 구현 — Claude API 컨텍스트 주입

**운동 이력을 시스템 프롬프트에 주입해 개인화된 코칭을 구현**

```dart
// AiCoachService._buildSystemPrompt()
buf.writeln('당신은 전문 AI 퍼스널 트레이너입니다.');
// 최근 5회 운동 기록을 자동으로 주입
for (final session in history.take(5)) {
  buf.writeln('${session.date}: ${session.sets} → 총볼륨 ${session.totalVolume}kg');
}
```

→ 사용자가 말하지 않아도 **AI가 이전 기록을 알고 대화**한다

**SQLite 스키마 (ADR-0002):** `workout_sessions` ↔ `exercise_sets` (FK 관계)

<!-- 대본: 핵심 구현을 설명하겠습니다. 단순히 Claude API를 호출하는 게 아니라, 사용자의 최근 5회 운동 기록을 시스템 프롬프트에 자동으로 주입합니다. 덕분에 사용자가 "오늘 가슴 할게"라고만 해도 AI가 지난주 벤치프레스 기록을 보고 이번 주 목표 무게를 제안합니다. -->

---

## 개발환경 · 빌드 · 배포 · 테스트

**개발환경 설정 (3단계)**
```bash
git clone https://github.com/wdh1543-monkey/AppPrograming.git
cd AppPrograming/workout_ai && flutter pub get
echo "CLAUDE_API_KEY=<key>" > .env && flutter run
```

**빌드 & 배포**
```bash
flutter build apk --release          # 릴리즈 APK 생성
adb install app-release.apk          # 기기 사이드로딩
```

**테스트 결과**

| 구분 | 항목 | 결과 |
|---|---|---|
| 단위 | WorkoutService CRUD, AiCoachService 프롬프트 | ✅ |
| 통합 | 7개 시나리오 (오프라인 포함) | ✅ |

<!-- 대본: 개발환경은 git clone, flutter pub get, .env에 API키 입력으로 3단계입니다. 빌드는 flutter build apk --release 한 줄, 배포는 adb install입니다. 테스트는 WorkoutService와 AiCoachService 단위테스트, 그리고 오프라인 동작 포함 7개 통합 시나리오를 통과했습니다. -->

---

## 활용 방안 · GitHub 가이드

**활용 시나리오**
1. 헬스장 가기 전 → "오늘 어깨+삼두 할게, 지난주보다 조금 세게" → AI가 루틴 제안
2. 운동 후 기록 입력 → AI가 볼륨 성장률 분석 + 다음 목표 제시
3. 야근으로 못 가면 → "수요일 빠져" → AI가 루틴 재배치

**기대 효과:** PT 비용 없이 개인화 코칭 · 오프라인 완전 동작

**GitHub 설치 가이드**
```
https://github.com/wdh1543-monkey/AppPrograming
→ README.md → docs/setup.md
```

→ `flutter doctor` 통과 후 3단계로 실행 가능

<!-- 대본: 활용 방안입니다. 헬스장 가기 전 한 마디, 끝나고 기록 입력, 일정이 바뀌면 말 한마디. 이 세 가지 시나리오가 이 앱의 전부입니다. 오프라인에서도 기록은 SQLite에 저장되고, AI 대화는 네트워크가 있을 때만 필요합니다. GitHub README에서 3단계로 설치할 수 있습니다. -->

---

<!-- _class: title -->

## 시연 데모

**사용자 시나리오: 오늘 운동부터 기록까지**

```
① 앱 실행 → 홈 화면 (오늘의 운동 카드)
② 채팅 화면 → "오늘 가슴 운동 할게, 지난 기록 참고해서 추천해줘"
③ AI 응답 → 벤치프레스 / 덤벨 플라이 세트 제안
④ 기록 화면 → 벤치프레스 70kg × 8회 × 3세트 입력
⑤ 히스토리 확인 → 저장된 기록 조회
```

**[데모 시작]**

<!-- 대본: 30초 시연입니다. 앱을 실행하고, AI에게 오늘 운동을 요청하고, 기록을 입력하고, 히스토리를 확인하는 흐름을 보여드리겠습니다. -->

---

<!-- _class: title -->

## 마무리

> **"운동 방법을 아는 것과 꾸준히 실천하는 것 사이의 간극"**
> — workout_ai는 그 간극을 AI 대화로 메웁니다.

**향후 발전 방향**
- 볼륨 성장률 대시보드 (Should → 다음 버전)
- 주간 루틴 자동 재배치 (Should → 다음 버전)

**감사합니다.**

<!-- 대본: 마무리입니다. 혼자 운동하는 중급자가 겪는 계획 흐트러짐, 기록 분석 어려움, 루틴 조정 문제. workout_ai는 AI 대화 하나로 이 세 가지를 해결합니다. 감사합니다. -->

---

# 질의응답 준비

> 이 페이지는 발표 슬라이드가 아닌 Q&A 대비용입니다.

---

## Q1. ADR — 왜 Flutter를 선택했나요?

**ADR-0001 기준 답변:**

React Native(Expo)로 시작했으나 11주차 환경 구축 시 npm peer deps 충돌 15개 발생, 3시간 디버깅 후 해결 불가로 판단했습니다.

Flutter는 `flutter pub get` 한 줄로 의존성 설치가 완료됐고, Dart 문법이 TypeScript와 유사해 진입장벽이 낮았습니다. Android 에뮬레이터 연동도 안정적이었습니다.

→ **환경 구축 실패 = 가장 빠른 전환 시점**

---

## Q2. ADR — 왜 sqflite를 썼나요?

**ADR-0002 기준 답변:**

운동 기록은 세션-세트-종목의 관계형 구조입니다. Hive(NoSQL)는 관계형 쿼리가 불가해 제외했고, Firebase Firestore는 클라우드 동기화가 필요 없는 이 프로젝트(Won't에 명시)에 과했습니다.

sqflite는 Flutter 표준 SQLite 래퍼로 오프라인에서 완전 동작하며, 발표 데모 시 Wi-Fi 없이도 동작합니다.

---

## Q3. ADR — 왜 Provider를 선택했나요?

**ADR-0003 기준 답변:**

Riverpod은 Provider의 개선판이지만 컴파일 타임 안전성을 위한 학습 곡선이 있습니다. Bloc/Cubit은 1인 7주 프로젝트에 보일러플레이트가 과했습니다.

Provider는 Flutter 공식 권장 방식으로 `ChangeNotifier` 패턴이 Claude API 비동기 응답 상태 관리에 직관적이었습니다.

---

## Q4. 앱 구조는 어떻게 되어 있나요?

**4레이어 클린 아키텍처:**

```
lib/
├── presentation/  ← Screen / Widget (UI만)
├── application/   ← ChatProvider, WorkoutProvider (상태)
├── domain/        ← Service, Entity (비즈니스 로직)
└── data/          ← ClaudeApiClient, AppDatabase (외부접근)
```

레이어 의존 방향: Presentation → Application → Domain → Data (단방향)

Domain은 Flutter·http 패키지에 의존하지 않아 단위 테스트가 가능합니다.

---

## Q5. 개발환경 설정은 어떻게 하나요?

```bash
# 1. 클론
git clone https://github.com/wdh1543-monkey/AppPrograming.git
cd AppPrograming/workout_ai

# 2. 의존성
flutter pub get

# 3. API 키
copy .env.example .env   # .env에 CLAUDE_API_KEY 입력

# 4. 실행
flutter run
```

사전 요구: Flutter SDK 3.x, Android Studio (에뮬레이터 또는 실기기)

---

## Q6. 빌드와 배포 단계는?

**빌드 단계:**
```
소스 → flutter pub get → flutter build apk --release → app-release.apk
```

**배포 단계:**
```
app-release.apk → adb install → 기기에서 앱 실행
```

- 디버그 빌드: `flutter build apk --debug` (서명 불필요)
- 릴리즈 빌드: `flutter build apk --release` (코드 최적화 + 트리쉐이킹)
- 롤백: 이전 APK 재설치 (`pubspec.yaml`의 version으로 버전 관리)
