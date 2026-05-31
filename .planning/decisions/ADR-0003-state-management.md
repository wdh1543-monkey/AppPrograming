# ADR-0003: 상태관리 선택

- 상태: Updated (Zustand → Provider, 2026-06-01)
- 날짜: 2026-05-18 / 변경: 2026-06-01
- 결정자: 원동현

## 배경

Flutter 앱에서 화면과 데이터(Claude API 응답, SQLite 기록) 사이 상태를 관리.
Flutter 전환에 따라 React 생태계 Zustand → Flutter 공식 Provider로 변경.

## 고려한 대안

### 대안 A: Provider ← **현재 선택**
- 장점: Flutter 공식 권장, 가볍고 단순, ChangeNotifier 패턴으로 AI 응답 반영 쉬움
- 단점: Riverpod 대비 기능 제한

### 대안 B: Riverpod
- 장점: Provider 개선판, 컴파일 타임 안전성
- 단점: 학습 곡선, 7주 프로젝트에 과한 구조

### 대안 C: Bloc / Cubit
- 장점: 대형 앱에 강함, 예측 가능한 상태 흐름
- 단점: 보일러플레이트 많음, 1인 단기 프로젝트에 과함

## 결정

**Provider** 를 선택한다.

## 이유

- Flutter 공식 문서에서 권장하는 표준 방식
- `ChangeNotifier` 패턴으로 Claude API 비동기 응답 상태 관리 직관적
- 1인 7주 프로젝트에 적합한 경량 구조
- `flutter pub add provider` 한 줄 설치

## 변경 이력

- 2026-05-18: Zustand 선택 (React Native 기준)
- 2026-06-01: Provider로 변경 (Flutter 전환)
