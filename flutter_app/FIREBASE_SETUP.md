# Firebase Setup Guide for Aid Healthcare App

This guide will walk you through setting up Firebase for the Aid Healthcare application.

## Prerequisites

- Flutter SDK installed
- A Google account
- Firebase CLI installed (optional but recommended)

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name: `aid-healthcare` (or your preferred name)
4. Disable Google Analytics (optional, can enable later)
5. Click "Create project"

## Step 2: Register Your App with Firebase

### For Web (Chrome)

1. In Firebase Console, click the **Web icon** (`</>`) to add a web app
2. Enter app nickname: `Aid Healthcare Web`
3. Check "Also set up Firebase Hosting" (optional)
4. Click "Register app"
5. Copy the Firebase configuration object (you'll need this later)

### For iOS (if deploying to iOS)

1. In Firebase Console, click the **iOS icon** to add an iOS app
2. Enter iOS bundle ID: `com.aid.healthcare` (or your bundle ID)
3. Download `GoogleService-Info.plist`
4. Follow the setup instructions

### For Android (if deploying to Android)

1. In Firebase Console, click the **Android icon** to add an Android app
2. Enter Android package name: `com.aid.healthcare` (or your package name)
3. Download `google-services.json`
4. Follow the setup instructions

## Step 3: Install Firebase CLI

```bash
npm install -g firebase-tools
```

Login to Firebase:
```bash
firebase login
```

## Step 4: Configure Firebase for Flutter

From your Flutter project directory:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter app
flutterfire configure
```

This command will:
- Create `firebase_options.dart` file with your Firebase configuration
- Link your Firebase project to your Flutter app
- Configure all platforms automatically

**Select your Firebase project** when prompted, or create a new one.

## Step 5: Enable Firebase Services

### Enable Firebase Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Go to "Sign-in method" tab
4. Enable **Email/Password** authentication
5. Click "Save"

### Enable Cloud Firestore

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.time < timestamp.date(2025, 12, 31);
       }
     }
   }
   ```
4. Choose a location close to your users (e.g., `us-central1`)
5. Click "Enable"

**  Important**: Update Firestore security rules for production:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read all doctors and articles
    match /doctors/{doctor} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    match /articles/{article} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }

    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Users can manage their own appointments
    match /appointments/{appointment} {
      allow read, write: if request.auth != null &&
                           resource.data.userId == request.auth.uid;
    }
  }
}
```

## Step 6: Seed Initial Data (Optional)

You can manually add sample data to Firestore, or create a seeding script.

### Sample Doctor Data

In Firestore Console, create a collection called `doctors` and add documents:

```json
{
  "name": "Dr. Sarah Johnson",
  "specialization": "Cardiologist",
  "hospital": "City General Hospital",
  "rating": 4.8,
  "reviewCount": 127,
  "yearsExperience": 12,
  "patientCount": 1500,
  "about": "Experienced cardiologist specializing in heart disease prevention and treatment.",
  "workingHours": "Mon - Fri (09:00 AM - 5:00 PM)",
  "category": "Specialty",
  "consultationFee": 150.0
}
```

### Sample Article Data

Create a collection called `articles`:

```json
{
  "title": "Understanding Heart Health: Prevention Tips",
  "author": "Dr. Sarah Johnson",
  "content": "Heart health is crucial for overall wellbeing. Regular exercise, a balanced diet, and stress management are key factors...",
  "category": "Cardiology",
  "createdAt": "2024-11-01T10:00:00Z",
  "readTime": 5,
  "likes": 234,
  "isLiked": false
}
```

## Step 7: Install Dependencies

```bash
cd flutter_app
flutter pub get
```

## Step 8: Run the App

```bash
flutter run -d chrome
```

## Testing Firebase Integration

### Test Authentication

1. Run the app
2. Click "Create Account"
3. Fill in the registration form
4. Submit - you should be registered and logged in
5. Check Firebase Console > Authentication > Users to see the new user

### Test Firestore

1. After logging in, navigate to the doctors list
2. If you added doctors to Firestore, they should appear
3. Check Firestore Console to see data being read/written

## Troubleshooting

### Error: `firebase_options.dart` not found

Run: `flutterfire configure` to generate the configuration file.

### Error: Firebase not initialized

Make sure `main.dart` has:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AidHealthcareApp());
}
```

### Permission Denied Errors

Check your Firestore security rules and ensure they allow the operations you're trying to perform.

### Web-specific Issues

For Flutter Web, ensure you have proper CORS configuration and that you've enabled the web platform in Firebase.

## Production Checklist

Before deploying to production:

- [ ] Update Firestore security rules (remove test mode)
- [ ] Enable App Check for additional security
- [ ] Set up proper authentication flows
- [ ] Configure Firebase Storage security rules (if using)
- [ ] Set up Firebase Hosting (for web deployment)
- [ ] Enable Firebase Analytics (optional)
- [ ] Set up Cloud Functions for backend logic (if needed)
- [ ] Configure proper error logging

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

## Support

For issues or questions:
1. Check Firebase Console for error logs
2. Review Firestore security rules
3. Check Flutter console for error messages
4. Consult FlutterFire documentation

---

**Note**: This app is now using Firebase instead of the Node.js backend. The backend folder is no longer needed for the Flutter app to function.
