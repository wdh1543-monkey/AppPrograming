# Setup — workout_ai

> 새 사람이 이 문서만 보고 5분 안에 실행할 수 있도록 작성.
> 작성: AI Agent 자동 생성 / 본인 검토 완료 (2026-05-18)

## 1. 사전 요구

| 도구 | 버전 | 확인 명령 |
|---|---|---|
| Node.js | 18.x 이상 | `node -v` |
| npm | 9.x 이상 | `npm -v` |
| Git | 2.40+ | `git --version` |
| Expo Go (앱) | 최신 | 실물 기기에 설치 |

### Node.js 설치

#### 윈도우
```powershell
winget install OpenJS.NodeJS
```

#### macOS
```bash
brew install node
```

#### 리눅스 (Ubuntu)
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

설치 확인:
```bash
npx expo doctor
```

---

## 2. 클론

```bash
git clone https://github.com/[본인계정]/workout_ai.git
cd workout_ai
```

---

## 3. 의존성 설치

```bash
npm install
```

---

## 4. 환경 변수 설정 (API 키)

`.env.example`을 복사해서 `.env` 파일 생성:

#### 윈도우
```powershell
copy .env.example .env
```

#### macOS / 리눅스
```bash
cp .env.example .env
```

`.env` 파일을 열어 API 키 입력:
```
EXPO_PUBLIC_CLAUDE_API_KEY=your_api_key_here
```

**API 키 발급**: [console.anthropic.com](https://console.anthropic.com) → API Keys → Create Key

> `EXPO_PUBLIC_` 접두사를 붙여야 Expo가 클라이언트에서 읽을 수 있습니다.
> `.env`는 `.gitignore`에 등록되어 있어 절대 커밋되지 않습니다.

---

## 5. 실행

```bash
npx expo start
```

터미널에 QR 코드가 표시됩니다.

**실물 기기 실행**:
1. 실물 기기에 **Expo Go** 앱 설치 (App Store / Google Play)
2. 같은 Wi-Fi 네트워크 연결
3. Expo Go 앱으로 QR 코드 스캔

**에뮬레이터 실행** (설치된 경우):
- Android: 터미널에서 `a` 키 입력
- iOS: 터미널에서 `i` 키 입력 (macOS만)

성공 시: workout_ai 앱 홈 화면이 실물 기기에 표시됩니다.

---

## 6. 자주 묻는 문제

### Q1. `npx expo start` 후 QR 코드가 스캔되지 않아요
기기와 PC가 **같은 Wi-Fi**에 연결되어 있는지 확인. 다른 네트워크면 터미널에서 `t` 키를 눌러 터널 모드로 전환

### Q2. `npm install` 중 오류가 나요
```bash
npm install --legacy-peer-deps
```
로 재시도

### Q3. API 키가 `undefined`로 나와요
`.env` 파일이 프로젝트 루트(package.json과 같은 위치)에 있는지 확인.
변수명이 `EXPO_PUBLIC_` 으로 시작하는지 확인 후 `npx expo start` 재시작

### Q4. Expo Go에서 "Something went wrong" 오류
터미널 로그를 확인하고 오류 메시지를 검색. 대부분 패키지 버전 충돌 — `npm install` 재실행

### Q5. 핫 리로드가 안 돼요
Expo Go 앱에서 화면을 세 손가락으로 흔들어 개발자 메뉴 → Reload
