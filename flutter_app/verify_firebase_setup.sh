#!/bin/bash

# Firebase Setup Verification Script
# This script checks if Firebase is properly configured

echo "🔍 Verifying Firebase Setup for Aid Healthcare App"
echo "=================================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check counter
CHECKS_PASSED=0
TOTAL_CHECKS=0

# Function to check status
check_status() {
    ((TOTAL_CHECKS++))
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((CHECKS_PASSED++))
    else
        echo -e "${RED}✗${NC} $2"
        echo -e "  ${YELLOW}Fix:${NC} $3"
    fi
}

# 1. Check if Firebase CLI is installed
echo "Checking prerequisites..."
firebase --version > /dev/null 2>&1
check_status $? "Firebase CLI installed" "Run: npm install -g firebase-tools"

# 2. Check if FlutterFire CLI is installed
flutterfire --version > /dev/null 2>&1
check_status $? "FlutterFire CLI installed" "Run: dart pub global activate flutterfire_cli"

# 3. Check if firebase_options.dart exists
if [ -f "lib/firebase_options.dart" ]; then
    # Check if it has placeholder values
    if grep -q "YOUR_PROJECT_ID" lib/firebase_options.dart; then
        check_status 1 "firebase_options.dart configured" "Run: flutterfire configure"
    else
        check_status 0 "firebase_options.dart configured" ""
    fi
else
    check_status 1 "firebase_options.dart exists" "Run: flutterfire configure"
fi

# 4. Check if Firebase dependencies are in pubspec.yaml
echo ""
echo "Checking dependencies..."
grep -q "firebase_core:" pubspec.yaml
check_status $? "firebase_core dependency found" "Add firebase_core to pubspec.yaml"

grep -q "firebase_auth:" pubspec.yaml
check_status $? "firebase_auth dependency found" "Add firebase_auth to pubspec.yaml"

grep -q "cloud_firestore:" pubspec.yaml
check_status $? "cloud_firestore dependency found" "Add cloud_firestore to pubspec.yaml"

# 5. Check if Firebase services are imported in main.dart
echo ""
echo "Checking Firebase initialization..."
grep -q "firebase_core" lib/main.dart
check_status $? "Firebase imported in main.dart" "Import firebase_core in main.dart"

grep -q "Firebase.initializeApp" lib/main.dart
check_status $? "Firebase initialized in main.dart" "Add Firebase.initializeApp() to main.dart"

# 6. Check if Firebase services exist
echo ""
echo "Checking Firebase service files..."
[ -f "lib/services/firebase_auth_service.dart" ]
check_status $? "FirebaseAuthService exists" "File is missing - check repository"

[ -f "lib/services/firestore_service.dart" ]
check_status $? "FirestoreService exists" "File is missing - check repository"

[ -f "lib/services/api_service.dart" ]
check_status $? "ApiService exists" "File is missing - check repository"

# Summary
echo ""
echo "=================================================="
echo "Summary: $CHECKS_PASSED/$TOTAL_CHECKS checks passed"
echo ""

if [ $CHECKS_PASSED -eq $TOTAL_CHECKS ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Go to https://console.firebase.google.com/"
    echo "2. Select your project"
    echo "3. Enable Authentication (Email/Password)"
    echo "4. Enable Firestore Database"
    echo "5. Run: flutter pub get"
    echo "6. Run: flutter run -d chrome"
else
    echo -e "${RED}✗ Some checks failed${NC}"
    echo ""
    echo "Please fix the issues above and run this script again."
    echo ""
    echo "For detailed setup instructions, see:"
    echo "  - README.md"
    echo "  - FIREBASE_SETUP.md"
    echo "  - ../QUICK_START.md"
fi

echo ""
