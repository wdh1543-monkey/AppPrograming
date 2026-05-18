# ADR-0003: 상태관리 라이브러리 선택

- 상태: Accepted (2026-05-18 Riverpod → Zustand으로 변경, 프레임워크 변경에 따름)
- 날짜: 2026-05-18
- 결정자: 원동현

## 배경

React Native 앱에서 화면(UI)과 데이터(Claude API 응답, SQLite 기록) 사이의 상태를 어떻게 관리할지 결정이 필요하다. 특히 AI 채팅 응답처럼 비동기로 오는 데이터를 UI에 반영해야 하는 경우가 많다.

## 고려한 대안

### 대안 A: Context API (React 내장)
- 장점: 별도 설치 없음, React 기본
- 단점: 상태 변경 시 불필요한 리렌더링 발생, 복잡해질수록 관리 어려움

### 대안 B: Zustand
- 장점: 경량(3KB), React hooks 기반, 보일러플레이트 최소, 비동기 처리 간단, 1인 프로젝트에 최적
- 단점: Redux 대비 DevTools 기능 제한

### 대안 C: Redux Toolkit
- 장점: 대형 앱에 강함, DevTools 풍부
- 단점: 보일러플레이트 많음, 7주 프로젝트에 과한 구조

## 결정

**Zustand**를 선택한다.

## 이유

- React Native + hooks 환경에서 가장 간결하게 상태를 정의하고 소비 가능
- Claude API 비동기 호출 상태(loading / data / error)를 단순한 `set()` 패턴으로 처리
- 1인 7주 프로젝트에 Redux는 과하고, Context API보다 성능·유지보수 우위
- `npm install zustand` 한 줄로 설치 완료

## 결과

긍정:
- 채팅 스토어(`chatStore`)와 운동 스토어(`workoutStore`)를 파일 단위로 명확히 분리 가능
- AI 응답 로딩 상태를 `isLoading` 플래그로 단순 관리

부정 / 제약:
- 앱 규모가 커지면 스토어 간 의존 관계 수동 관리 필요 (현 규모에서는 무관)

## 후속 작업

- [ ] `npm install zustand` 실행
- [ ] `store/chatStore.ts`, `store/workoutStore.ts` 작성
