import '../models/doctor.dart';
import '../models/article.dart';
import '../models/user.dart';
import '../models/appointment.dart';
import 'firebase_auth_service.dart';
import 'firestore_service.dart';

/// ApiService - Wrapper around Firebase services
/// Maintains backward compatibility with existing code
class ApiService {
  static final FirebaseAuthService _authService = FirebaseAuthService();
  static final FirestoreService _firestoreService = FirestoreService();

  // ==================== AUTHENTICATION ====================

  /// Login with email and password
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.signIn(
      email: email,
      password: password,
    );
    return result;
  }

  /// Register a new user
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final result = await _authService.register(
      email: userData['email'],
      password: userData['password'],
      name: userData['name'],
      phone: userData['phone'],
    );

    // If registration is successful, create user profile in Firestore
    if (result['success'] == true && result['user'] != null) {
      final userId = result['user'].uid;
      final user = User(
        id: userId,
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
      );

      await _firestoreService.createUserProfile(userId, user);
    }

    return result;
  }

  /// Sign out current user
  static Future<void> clearToken() async {
    await _authService.signOut();
  }

  /// Reset password - sends password reset email
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    return await _authService.resetPassword(email);
  }

  /// Check if user is signed in
  static bool isSignedIn() {
    return _authService.isSignedIn();
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    return _authService.getCurrentUserId();
  }

  // ==================== USER PROFILE ====================

  /// Get user profile from Firestore
  static Future<User?> getUserProfile() async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) return null;

    final user = await _firestoreService.getUserProfile(userId);
    return user;
  }

  /// Update user profile
  static Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) return false;

    return await _firestoreService.updateUserProfile(userId, data);
  }

  // ==================== DOCTORS ====================

  /// Get list of doctors, optionally filtered by category
  static Future<List<Doctor>> getDoctors({String? category}) async {
    return await _firestoreService.getDoctors(category: category);
  }

  /// Get doctor by ID
  static Future<Doctor?> getDoctorById(String doctorId) async {
    return await _firestoreService.getDoctorById(doctorId);
  }

  /// Add a new doctor (admin operation)
  static Future<String?> addDoctor(Doctor doctor) async {
    return await _firestoreService.addDoctor(doctor);
  }

  /// Update doctor information
  static Future<bool> updateDoctor(String doctorId, Map<String, dynamic> data) async {
    return await _firestoreService.updateDoctor(doctorId, data);
  }

  // ==================== ARTICLES ====================

  /// Get list of articles
  static Future<List<Article>> getArticles({int? limit}) async {
    return await _firestoreService.getArticles(limit: limit);
  }

  /// Get article by ID
  static Future<Article?> getArticleById(String articleId) async {
    return await _firestoreService.getArticleById(articleId);
  }

  /// Add a new article
  static Future<String?> addArticle(Article article) async {
    return await _firestoreService.addArticle(article);
  }

  // ==================== APPOINTMENTS ====================

  /// Book a new appointment
  static Future<Map<String, dynamic>> bookAppointment(Appointment appointment) async {
    return await _firestoreService.bookAppointment(appointment);
  }

  /// Get appointments for current user
  static Future<List<Appointment>> getUserAppointments() async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) return [];

    return await _firestoreService.getUserAppointments(userId);
  }

  /// Get appointment by ID
  static Future<Appointment?> getAppointmentById(String appointmentId) async {
    return await _firestoreService.getAppointmentById(appointmentId);
  }

  /// Update appointment
  static Future<bool> updateAppointment(String appointmentId, Map<String, dynamic> data) async {
    return await _firestoreService.updateAppointment(appointmentId, data);
  }

  /// Cancel appointment
  static Future<bool> cancelAppointment(String appointmentId) async {
    return await _firestoreService.cancelAppointment(appointmentId);
  }

  // ==================== REAL-TIME STREAMS ====================

  /// Listen to doctors list in real-time
  static Stream<List<Doctor>> listenToDoctors({String? category}) {
    return _firestoreService.listenToDoctors(category: category);
  }

  /// Listen to user appointments in real-time
  static Stream<List<Appointment>> listenToUserAppointments() {
    final userId = _authService.getCurrentUserId();
    if (userId == null) {
      return Stream.value([]);
    }
    return _firestoreService.listenToUserAppointments(userId);
  }

  // ==================== MOCK DATA (For testing without backend) ====================

  /// Get mock doctors for testing
  static List<Doctor> getMockDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialization: 'Cardiologist',
        hospital: 'City General Hospital',
        rating: 4.8,
        reviewCount: 127,
        yearsExperience: 12,
        patientCount: 1500,
        about: 'Experienced cardiologist specializing in heart disease prevention and treatment.',
        workingHours: 'Mon - Fri (09:00 AM - 5:00 PM)',
        category: 'Specialty',
        consultationFee: 150.0,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Michael Chen',
        specialization: 'Pediatrician',
        hospital: 'Children\'s Medical Center',
        rating: 4.9,
        reviewCount: 203,
        yearsExperience: 15,
        patientCount: 2000,
        about: 'Dedicated pediatrician with expertise in child healthcare and development.',
        workingHours: 'Mon - Sat (08:00 AM - 6:00 PM)',
        category: 'Pediatrics',
        consultationFee: 120.0,
      ),
    ];
  }

  /// Get mock articles for testing
  static List<Article> getMockArticles() {
    return [
      Article(
        id: '1',
        title: 'Understanding Heart Health: Prevention Tips',
        author: 'Dr. Sarah Johnson',
        content: 'Heart health is crucial for overall wellbeing...',
        category: 'Cardiology',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        readTime: 5,
        likes: 234,
      ),
      Article(
        id: '2',
        title: 'Children\'s Nutrition: A Complete Guide',
        author: 'Dr. Michael Chen',
        content: 'Proper nutrition is essential for children\'s growth...',
        category: 'Pediatrics',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        readTime: 8,
        likes: 189,
      ),
    ];
  }
}
