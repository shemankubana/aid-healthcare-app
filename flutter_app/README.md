# Aid Healthcare App

A Flutter healthcare management application with Firebase backend for authentication and database.

## Features

- 🔐 **User Authentication** - Secure email/password authentication with Firebase
- 👨‍⚕️ **Doctor Directory** - Browse and search healthcare providers
- 📅 **Appointment Booking** - Schedule appointments with doctors
- 📰 **Health Articles** - Read health tips and medical information
- 👤 **User Profiles** - Manage your personal health information
- ⚡ **Real-time Updates** - Live data synchronization with Firestore
- 📴 **Offline Support** - Works without internet, syncs when online

## Tech Stack

- **Frontend**: Flutter (Web, iOS, Android)
- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **State Management**: Provider
- **UI Components**: Custom Material Design widgets

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Node.js and npm (for Firebase CLI)
- A Google account for Firebase

## Quick Setup

### 1. Install Dependencies

```bash
# Install Flutter dependencies
flutter pub get

# Install Firebase tools
npm install -g firebase-tools
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase

```bash
# Run FlutterFire configuration
flutterfire configure
```

This will:
- Create or select a Firebase project
- Generate `lib/firebase_options.dart` with your configuration
- Set up Firebase for all platforms

### 3. Enable Firebase Services

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project

**Enable Authentication:**
- Navigate to Authentication → Get Started
- Go to Sign-in method tab
- Enable "Email/Password"
- Click Save

**Enable Firestore:**
- Navigate to Firestore Database → Create database
- Select "Start in test mode"
- Choose your region (e.g., us-central1)
- Click Enable

### 4. Add Sample Data (Optional)

See `FIREBASE_SETUP.md` for sample data structures to add to Firestore.

### 5. Run the App

```bash
# Run on Chrome (Web)
flutter run -d chrome

# Run on Android Emulator
flutter run -d android

# Run on iOS Simulator (macOS only)
flutter run -d ios
```

## Project Structure

```
lib/
├── constants/          # App-wide constants (colors, text styles)
├── models/            # Data models (Doctor, Article, User, Appointment)
├── screens/           # UI screens
│   ├── auth/         # Login & Registration
│   ├── home/         # Home screen
│   ├── doctors/      # Doctor list & details
│   ├── articles/     # Health articles
│   ├── appointments/ # Appointment booking
│   └── profile/      # User profile
├── services/         # Business logic & Firebase integration
│   ├── firebase_auth_service.dart   # Authentication
│   ├── firestore_service.dart       # Database operations
│   └── api_service.dart             # Unified API wrapper
├── widgets/          # Reusable UI components
├── firebase_options.dart  # Firebase configuration (auto-generated)
└── main.dart         # App entry point
```

## Firebase Services Used

### Firebase Authentication
- Email/Password authentication
- User profile management
- Password reset functionality

### Cloud Firestore Collections
- **users** - User profiles and settings
- **doctors** - Healthcare provider information
- **articles** - Health articles and tips
- **appointments** - Appointment bookings

## Development

### Running in Development Mode

```bash
# Hot reload enabled
flutter run -d chrome
```

### Building for Production

```bash
# Web
flutter build web

# Android APK
flutter build apk

# iOS (macOS only)
flutter build ios
```

## Security

### Firestore Security Rules

Before going to production, update your Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Public read access for doctors and articles
    match /doctors/{doctor} {
      allow read: if true;
      allow write: if request.auth != null &&
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    match /articles/{article} {
      allow read: if true;
      allow write: if request.auth != null &&
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Users can only manage their own appointments
    match /appointments/{appointment} {
      allow read, write: if request.auth != null &&
                            resource.data.userId == request.auth.uid;
    }
  }
}
```

## Troubleshooting

### Firebase not initialized
**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution**: Run `flutterfire configure` to generate `firebase_options.dart`

### Permission denied errors
**Error**: `FirebaseError: Missing or insufficient permissions`

**Solution**: Check your Firestore security rules in Firebase Console

### Authentication errors
**Error**: `User not found` or `Wrong password`

**Solution**: Verify Firebase Authentication is enabled and user exists

### Web CORS issues
**Solution**: Firebase automatically handles CORS for authenticated requests

## Documentation

- 📖 [Firebase Setup Guide](FIREBASE_SETUP.md) - Detailed Firebase configuration
- 🚀 [Quick Start Guide](../QUICK_START.md) - Get started in 5 minutes
- 📚 [Flutter Documentation](https://docs.flutter.dev/)
- 🔥 [Firebase Documentation](https://firebase.google.com/docs)

## Environment Configuration

No `.env` files needed! Firebase configuration is in `firebase_options.dart` (auto-generated).

## Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues or questions:
- Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for setup help
- Review [Flutter documentation](https://docs.flutter.dev/)
- Check [Firebase documentation](https://firebase.google.com/docs)

---

**Note**: This app uses Firebase as the backend. No separate backend server is required.
