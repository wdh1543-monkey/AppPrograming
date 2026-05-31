# ADR-0001: 모바일 프레임워크 선택

- 상태: Superseded → **Flutter로 변경 (2026-06-01)**
- 날짜: 2026-05-18 / 변경: 2026-06-01
- 결정자: 원동현

## 배경

AI 운동 코칭 앱을 Android로 개발. 초기 React Native (Expo) 선택 후
npm 의존성 충돌로 환경 구축 자체가 실패 → Flutter로 전환 결정.

## 고려한 대안

### 대안 A: Flutter (Dart) ← **현재 선택**
- 장점: 단일 코드베이스(iOS+Android), 의존성 충돌 없음, `flutter create` 즉시 빌드, 위젯 UI 풍부
- 단점: Dart 새로 배워야 함, SDK 별도 설치 필요

### 대안 B: React Native (Expo) ← 초기 선택, 제외
- 장점: JS/TS 생태계, Expo Go QR 즉시 실행
- 단점: **npm peer deps 충돌로 의존성 설치 자체 실패** → 제외

### 대안 C: Android 네이티브 (Kotlin)
- 장점: 성능 최적, 안정적
- 단점: iOS 미지원, 개발 속도 느림, 학습 비용

## 결정

**Flutter (Dart)** 를 선택한다.

## 이유

- `flutter pub get` 한 줄로 의존성 설치 완료 — 충돌 없음
- Dart 문법이 TypeScript와 유사해 진입장벽 낮음
- Android 에뮬레이터 / 실기기 연동 안정적
- sqflite(SQLite), http 패키지 모두 Flutter 생태계에서 안정적으로 제공

## 결과

- 언어: Dart / 프레임워크: Flutter 3.44.0
- 상태관리: Provider (공식 권장, 경량)
- 로컬 저장소: sqflite → ADR-0002 업데이트
- HTTP: http 패키지

## 변경 이력

- 2026-05-18: React Native (Expo) 선택
- 2026-06-01: Flutter로 변경 (npm 의존성 충돌)
