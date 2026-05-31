# Setup — workout_ai

> 새 사람이 이 문서만 보고 5분 안에 실행할 수 있도록 작성.
> 프레임워크: Flutter (Dart) — 2026-06-01 기준

## 1. 사전 요구

| 도구 | 버전 | 확인 명령 |
|---|---|---|
| Flutter SDK | 3.x 이상 | `flutter --version` |
| Android Studio | 최신 | Android SDK 포함 |
| Git | 2.40+ | `git --version` |
| Android 기기 or 에뮬레이터 | — | `flutter devices` |

### Flutter 설치 (Windows)

```powershell
# 1. Flutter SDK 다운로드 후 C:\flutter 에 압축 해제
# 2. 환경변수 PATH 추가
[System.Environment]::SetEnvironmentVariable(
  "Path", $env:Path + ";C:\flutter\bin", "User"
)
# 3. 터미널 재시작 후 확인
flutter doctor
```

---

## 2. 클론

```bash
git clone https://github.com/wdh1543-monkey/AppPrograming.git
cd AppPrograming/workout_ai
```

---

## 3. 의존성 설치

```bash
flutter pub get
```

---

## 4. 환경변수 설정 (API 키)

`.env.example` 복사:

#### Windows
```powershell
copy .env.example .env
```

#### macOS / Linux
```bash
cp .env.example .env
```

`.env` 파일 열어 API 키 입력:
```
CLAUDE_API_KEY=your_api_key_here
```

**API 키 발급**: [console.anthropic.com](https://console.anthropic.com) → API Keys → Create Key

---

## 5. 실행

```bash
# 연결된 기기 확인
flutter devices

# 앱 실행 (기기 자동 선택)
flutter run

# 특정 기기 지정
flutter run -d <device-id>
```

**Android 에뮬레이터 실행**:
1. Android Studio → Device Manager → 에뮬레이터 시작
2. `flutter run` 실행

**실물 기기 실행**:
1. 기기에서 개발자 모드 활성화 → USB 디버깅 ON
2. USB 연결 후 `flutter devices` 로 기기 확인
3. `flutter run`

---

## 6. 자주 묻는 문제

### Q1. `flutter doctor` 에서 Android 라이선스 경고
```bash
flutter doctor --android-licenses
# 모두 y 입력
```

### Q2. `flutter run` 시 기기가 안 잡혀요
USB 디버깅이 켜져 있는지 확인. USB 케이블이 데이터 전송 지원 케이블인지 확인.

### Q3. `flutter pub get` 오류
```bash
flutter clean
flutter pub get
```

### Q4. API 키가 null로 나와요
`.env` 파일이 `pubspec.yaml`과 같은 위치에 있는지 확인.
`flutter run` 재시작.

### Q5. 빌드가 갑자기 느려요
```bash
flutter clean
flutter pub get
flutter run
```
