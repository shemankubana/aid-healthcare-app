import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';
import '../models/article.dart';
import '../models/user.dart' as app_models;
import '../models/appointment.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collections
  static const String _doctorsCollection = 'doctors';
  static const String _articlesCollection = 'articles';
  static const String _usersCollection = 'users';
  static const String _appointmentsCollection = 'appointments';

  // ==================== DOCTOR OPERATIONS ====================

  // Get all doctors or filter by category
  Future<List<Doctor>> getDoctors({String? category}) async {
    try {
      Query query = _db.collection(_doctorsCollection);

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Doctor.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }

  // Get doctor by ID
  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final doc = await _db.collection(_doctorsCollection).doc(doctorId).get();
      if (doc.exists) {
        return Doctor.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  // Add a new doctor (admin operation)
  Future<String?> addDoctor(Doctor doctor) async {
    try {
      final docRef = await _db.collection(_doctorsCollection).add(doctor.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding doctor: $e');
      return null;
    }
  }

  // Update doctor
  Future<bool> updateDoctor(String doctorId, Map<String, dynamic> data) async {
    try {
      await _db.collection(_doctorsCollection).doc(doctorId).update(data);
      return true;
    } catch (e) {
      print('Error updating doctor: $e');
      return false;
    }
  }

  // Delete doctor
  Future<bool> deleteDoctor(String doctorId) async {
    try {
      await _db.collection(_doctorsCollection).doc(doctorId).delete();
      return true;
    } catch (e) {
      print('Error deleting doctor: $e');
      return false;
    }
  }

  // ==================== ARTICLE OPERATIONS ====================

  // Get all articles
  Future<List<Article>> getArticles({int? limit}) async {
    try {
      Query query = _db.collection(_articlesCollection).orderBy('createdAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Article.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  // Get article by ID
  Future<Article?> getArticleById(String articleId) async {
    try {
      final doc = await _db.collection(_articlesCollection).doc(articleId).get();
      if (doc.exists) {
        return Article.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching article: $e');
      return null;
    }
  }

  // Add article
  Future<String?> addArticle(Article article) async {
    try {
      final docRef = await _db.collection(_articlesCollection).add(article.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding article: $e');
      return null;
    }
  }

  // Update article
  Future<bool> updateArticle(String articleId, Map<String, dynamic> data) async {
    try {
      await _db.collection(_articlesCollection).doc(articleId).update(data);
      return true;
    } catch (e) {
      print('Error updating article: $e');
      return false;
    }
  }

  // ==================== USER OPERATIONS ====================

  // Create user profile
  Future<bool> createUserProfile(String userId, app_models.User user) async {
    try {
      await _db.collection(_usersCollection).doc(userId).set(user.toJson());
      return true;
    } catch (e) {
      print('Error creating user profile: $e');
      return false;
    }
  }

  // Get user profile
  Future<app_models.User?> getUserProfile(String userId) async {
    try {
      final doc = await _db.collection(_usersCollection).doc(userId).get();
      if (doc.exists) {
        return app_models.User.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection(_usersCollection).doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // ==================== APPOINTMENT OPERATIONS ====================

  // Book appointment
  Future<Map<String, dynamic>> bookAppointment(Appointment appointment) async {
    try {
      final docRef = await _db.collection(_appointmentsCollection).add(appointment.toJson());
      return {
        'success': true,
        'appointmentId': docRef.id,
        'message': 'Appointment booked successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to book appointment: $e',
      };
    }
  }

  // Get user appointments
  Future<List<Appointment>> getUserAppointments(String userId) async {
    try {
      final querySnapshot = await _db
          .collection(_appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Appointment.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Get appointment by ID
  Future<Appointment?> getAppointmentById(String appointmentId) async {
    try {
      final doc = await _db.collection(_appointmentsCollection).doc(appointmentId).get();
      if (doc.exists) {
        return Appointment.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching appointment: $e');
      return null;
    }
  }

  // Update appointment
  Future<bool> updateAppointment(String appointmentId, Map<String, dynamic> data) async {
    try {
      await _db.collection(_appointmentsCollection).doc(appointmentId).update(data);
      return true;
    } catch (e) {
      print('Error updating appointment: $e');
      return false;
    }
  }

  // Cancel appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      await _db.collection(_appointmentsCollection).doc(appointmentId).update({
        'status': 'cancelled',
      });
      return true;
    } catch (e) {
      print('Error cancelling appointment: $e');
      return false;
    }
  }

  // Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await _db.collection(_appointmentsCollection).doc(appointmentId).delete();
      return true;
    } catch (e) {
      print('Error deleting appointment: $e');
      return false;
    }
  }

  // ==================== REAL-TIME LISTENERS ====================

  // Listen to doctors
  Stream<List<Doctor>> listenToDoctors({String? category}) {
    Query query = _db.collection(_doctorsCollection);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Doctor.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList());
  }

  // Listen to user appointments
  Stream<List<Appointment>> listenToUserAppointments(String userId) {
    return _db
        .collection(_appointmentsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }
}
