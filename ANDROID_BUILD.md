# Angel Memories Android APK

The Android app is generated from the official Angel Memories website using Capacitor 8.

## Official download

The latest APK is published at:

https://angel-memories-official.vercel.app/download/Angel-Memories.apk

## Automated build

1. Open the repository's **Actions** tab.
2. Select **Build Angel Memories Android APK**.
3. Choose **Run workflow** on the `main` branch.
4. Wait for the workflow to finish successfully.
5. Download the APK artifact or use the official website download above.

Every relevant website or Android build change on `main` triggers a fresh APK build.

## Local build requirements

- Node.js 22
- Java 21
- Android SDK Platform 36 and Build Tools 36.0.0

Run:

```sh
npm install
npm run build:web
npx cap add android
npx cap sync android
cd android
./gradlew assembleDebug
```

The debug APK is generated at `android/app/build/outputs/apk/debug/app-debug.apk`.

## App identity and upgrade compatibility

- Display name: Angel Memories
- Existing Android application ID: `bd.littleangel.gallery`
- OAuth callback URI scheme: `com.angelmemories.app`

The existing application ID is intentionally retained so that previously installed Android builds keep the same package identity. Do not change it unless a separate new Android app is intended.

This workflow can use a debug signing key when release-signing secrets are not configured. A properly signed upgrade requires the original release keystore; never commit signing keys or passwords to the repository.
