# ADR-0001: 모바일 프레임워크 선택

- 상태: Accepted (2026-05-18 Flutter → React Native로 변경)
- 날짜: 2026-05-18
- 결정자: 원동현

## 배경

AI 운동 코칭 앱을 모바일로 개발해야 한다. iOS와 Android를 모두 지원하거나 하나만 할지, 어떤 프레임워크를 쓸지 결정이 필요하다. 초기에 Flutter를 선택했으나 SDK 별도 설치가 필요해 Node.js 기반의 React Native (Expo)로 변경한다.

## 고려한 대안

### 대안 A: Flutter (Dart)
- 장점: iOS + Android 단일 코드베이스, 핫 리로드, 위젯 생태계 풍부
- 단점: **Flutter SDK 별도 설치 필요** → 개발 환경 구축 실패로 제외

### 대안 B: React Native — Expo (TypeScript)
- 장점: Node.js만 있으면 즉시 시작, `npx create-expo-app`으로 환경 구축 불필요, Expo Go 앱으로 실물 기기 즉시 테스트, npm 생태계 활용
- 단점: 성능이 Flutter보다 다소 낮을 수 있음, 네이티브 모듈 깊이 사용 시 복잡

### 대안 C: Android 네이티브 (Kotlin)
- 장점: 성능 최적, 네이티브 API 직접 접근
- 단점: iOS 미지원, 개발 속도 느림

## 결정

**React Native (Expo)**를 선택한다.

## 이유

- Node.js가 이미 설치된 환경에서 별도 SDK 없이 `npx create-expo-app`으로 즉시 시작 가능
- Expo Go 앱으로 실물 기기에서 QR코드 스캔만으로 바로 테스트 → 발표 데모에 유리
- TypeScript 기반으로 AI 생성 코드의 타입 안전성 확보
- `expo-sqlite`로 SQLite 로컬 저장, `fetch`로 Claude API 호출 모두 기본 지원

## 결과

긍정:
- 에뮬레이터 없이 실물 기기(Expo Go)로 바로 데모 가능
- npm 생태계로 필요한 패키지 즉시 설치 가능

부정 / 제약:
- Flutter 대비 성능이 다소 낮을 수 있으나 운동 기록 앱 수준에서는 무관

## 후속 작업

- [x] `npx create-expo-app workout_ai` 실행
- [ ] 실물 기기에 Expo Go 앱 설치
- [ ] `npx expo start` → QR 코드 스캔으로 Hello World 확인
