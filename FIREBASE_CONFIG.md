# Firebase Configuration Setup

## ⚠️ Important Security Notice

The Firebase configuration files are **NOT** included in this repository because they contain sensitive API keys. You must generate them locally.

## Files You Need to Generate Locally

These files are gitignored for security:
- `flutter_app/lib/firebase_options.dart`
- `flutter_app/android/app/google-services.json`
- `flutter_app/ios/Runner/GoogleService-Info.plist`

## How to Generate Firebase Configuration

### Prerequisites
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`

### Steps

1. **Navigate to the Flutter app directory:**
   ```bash
   cd flutter_app
   ```

2. **Run FlutterFire configure:**
   ```bash
   flutterfire configure
   ```

3. **Follow the prompts:**
   - Select your Firebase project (or create a new one)
   - Select the platforms you want to support:
     - ✅ web
     - ✅ android
     - ✅ ios (if building for iOS)

4. **Verify files were created:**
   ```bash
   ls -la lib/firebase_options.dart
   ls -la android/app/google-services.json
   ls -la ios/Runner/GoogleService-Info.plist  # if iOS selected
   ```

## Secure Your API Keys

After generating the configuration files, secure your API keys in the Firebase Console:

### 1. Go to Google Cloud Console
https://console.cloud.google.com/

### 2. Select your project

### 3. Navigate to: APIs & Services → Credentials

### 4. For each API key, add restrictions:

**Web API Key:**
- Application restrictions → HTTP referrers (websites)
- Add: `localhost:*`, `*.your-domain.com/*`

**Android API Key:**
- Application restrictions → Android apps
- Add your package name: `com.example.aid_healthcare`
- Add your SHA-1 certificate fingerprint

**iOS API Key:**
- Application restrictions → iOS apps
- Add your bundle ID

### 5. Add API Restrictions
Restrict each key to only use:
- Firebase Authentication API
- Cloud Firestore API
- (Add others as needed)

## Enable Firebase Services

1. **Authentication:**
   - Go to Firebase Console → Authentication
   - Enable Email/Password sign-in method

2. **Cloud Firestore:**
   - Go to Firebase Console → Firestore Database
   - Create database in test mode (for development)
   - Choose your region

## Running the App

After configuration:

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android
flutter run
```

## Troubleshooting

### "A network error has occurred"
- Ensure you ran `flutterfire configure` and selected the correct platforms
- Check that `google-services.json` exists in `android/app/`
- Verify Firebase services are enabled in Firebase Console
- Restart the app/emulator

### "Duplicate Firebase app"
- This is handled in the code with try-catch
- Just hot reload the app

## Need Help?

See the main README.md for additional setup instructions.
