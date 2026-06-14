# 빌드 및 배포 — workout_ai

> 프레임워크: Flutter 3.x (Dart) · 타겟: Android APK

---

## 빌드

### 디버그 빌드

개발 중 기기/에뮬레이터 확인용. 서명 불필요.

```bash
cd workout_ai
flutter build apk --debug
# 결과물: build/app/outputs/flutter-apk/app-debug.apk
```

### 릴리즈 빌드

배포용. 코드 최적화 + 트리 쉐이킹 적용.

```bash
flutter build apk --release
# 결과물: build/app/outputs/flutter-apk/app-release.apk
```

### 빌드 전 확인 사항

```bash
# 의존성 최신화
flutter pub get

# 환경 이상 없는지 점검
flutter doctor

# 캐시 정리 (빌드 오류 발생 시)
flutter clean && flutter pub get
```

---

## 배포

### 방법 1: USB 사이드로딩 (발표 데모 기준)

실기기에 직접 설치. 발표 시연 환경에 적합.

```bash
# 1. 기기 연결 확인
flutter devices

# 2. 릴리즈 빌드 설치
flutter install --release

# 또는 APK 직접 전송 후 설치
adb install build/app/outputs/flutter-apk/app-release.apk
```

기기 설정: **설정 → 보안 → 출처를 알 수 없는 앱 허용**

### 방법 2: 직접 실행 (개발/시연)

```bash
flutter run --release
```

---

## 릴리즈 서명 (APK 정식 배포 시)

> 현재 프로젝트는 사이드로딩 배포 기준. Play Store 제출 시 아래 단계 필요.

```bash
# 1. Keystore 생성 (최초 1회)
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 2. android/key.properties 파일 생성 (gitignore 필수)
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<keystore 절대경로>

# 3. 서명 빌드
flutter build apk --release
```

---

## 롤백

이전 버전 APK를 보관해 두고 재설치한다.

```bash
# 현재 버전 제거 후 이전 APK 설치
adb uninstall com.example.workout_ai
adb install <이전버전>.apk
```

APK 버전 관리: `pubspec.yaml`의 `version` 필드를 `1.0.0+1` 형식으로 관리하고,
빌드 전 버전을 올려 파일명에 포함시켜 보관한다.

```yaml
# pubspec.yaml
version: 1.0.1+2   # 형식: semver+빌드번호
```

---

## 빌드 단계 요약

```
소스 코드
  → flutter pub get (의존성)
  → flutter build apk --release (컴파일 + 트리쉐이킹)
  → app-release.apk 생성
  → adb install / flutter install (기기 배포)
  → 앱 실행 확인
```
