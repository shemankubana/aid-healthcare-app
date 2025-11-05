# Quick Start Guide - Fix Your Registration Error

You're getting a connection error because the app was migrated to Firebase but Firebase isn't configured yet.

## 🚀 FASTEST Solution: Set Up Firebase (5 minutes)

### Step 1: Install FlutterFire CLI
```bash
npm install -g firebase-tools
firebase login

dart pub global activate flutterfire_cli
```

### Step 2: Configure Firebase
```bash
cd flutter_app
flutterfire configure
```

This will:
- Ask you to create or select a Firebase project
- Automatically generate the correct `firebase_options.dart` file
- Configure all platforms

### Step 3: Enable Firebase Services

1. Go to https://console.firebase.google.com/
2. Select your project
3. **Enable Authentication**:
   - Click "Authentication" → "Get Started"
   - Click "Sign-in method" tab
   - Enable "Email/Password"
   - Click "Save"

4. **Enable Firestore**:
   - Click "Firestore Database" → "Create database"
   - Select "Start in test mode"
   - Choose your region (e.g., us-central1)
   - Click "Enable"

### Step 4: Run the App
```bash
flutter pub get
flutter run
```

That's it! Your app will now use Firebase (no backend server needed).

---

## 🔧 Alternative: Use the Old Backend (if you prefer MongoDB)

If you want to keep using the Node.js backend instead of Firebase:

### Step 1: Start MongoDB

**Using Docker (easiest):**
```bash
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

**Or install MongoDB:**
```bash
# macOS
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community

# Verify it's running
mongosh
```

### Step 2: Revert to Backend-based API

You'll need to undo the Firebase migration. Let me know if you want to do this.

---

## 📱 For Android Emulator Users

If using Android emulator, the IP `10.0.2.2` is correct (it points to localhost from the emulator).

---

## ❓ Which Should I Choose?

**Use Firebase if:**
- ✅ You want a modern, serverless architecture
- ✅ You don't want to manage a backend server
- ✅ You want automatic scaling
- ✅ You want real-time data synchronization
- ✅ You want offline support

**Use Backend if:**
- ✅ You need complete control over your backend
- ✅ You have existing MongoDB infrastructure
- ✅ You prefer traditional REST APIs
- ✅ You need custom server-side logic

---

## 🆘 Still Having Issues?

Run this diagnostic:
```bash
cd flutter_app

# Check if firebase_options.dart has real values
cat lib/firebase_options.dart | grep "YOUR_"

# If you see "YOUR_PROJECT_ID", Firebase isn't configured yet
# Run: flutterfire configure
```

For help, check:
- `flutter_app/FIREBASE_SETUP.md` - Detailed Firebase setup guide
- Flutter console error messages
- Firebase Console for authentication/database status
