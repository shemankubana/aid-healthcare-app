import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if not already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized, continue
    if (e.toString().contains('duplicate-app')) {
      print('Firebase already initialized');
    } else {
      print('Error initializing Firebase: $e');
    }
  }

  runApp(const AidHealthcareApp());
}

class AidHealthcareApp extends StatelessWidget {
  const AidHealthcareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aid Healthcare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFEDF1E9),
      ),
      home: const WelcomeScreen(),
    );
  }
}