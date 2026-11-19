# Angel Memories Android APK

The Android project is generated from the official static website using Capacitor 8.

## Automated build

1. Open the repository's **Actions** tab.
2. Select **Build Angel Memories Android APK**.
3. Choose **Run workflow** on the `main` branch.
4. Wait for the workflow to finish successfully.
5. Open the completed run and download the `angel-memories-android-debug` artifact.
6. Extract the ZIP to get `app-debug.apk`.

Every relevant change to the website or Android build configuration on `main` also triggers an APK build.

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

## App identity

- Display name: Angel Memories
- Android application ID: `com.angelmemories.app`

This workflow creates a debug APK for installation/testing. A signed release APK or Google Play App Bundle requires a separately managed signing key; never commit that key or its passwords to the repository.
