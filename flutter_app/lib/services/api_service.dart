import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/doctor.dart';
import '../models/article.dart';
import '../models/user.dart';
import '../models/appointment.dart';

class ApiService {
  // Base URL - Update this to match your backend API
  static const String baseUrl = 'http://localhost:8000/api';

  // Token management
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Helper method to get headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth APIs
  static Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // User APIs
  static Future<User?> getUserProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Doctor APIs
  static Future<List<Doctor>> getDoctors({String? category}) async {
    try {
      final headers = await _getHeaders();
      String url = '$baseUrl/doctors';
      if (category != null && category.isNotEmpty) {
        url += '?category=$category';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Doctor.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching doctors: $e');
      // Return mock data for development
      return _getMockDoctors();
    }
  }

  static Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/$doctorId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Doctor.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  // Article APIs
  static Future<List<Article>> getArticles() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/articles'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching articles: $e');
      // Return mock data for development
      return _getMockArticles();
    }
  }

  // Appointment APIs
  static Future<Map<String, dynamic>> bookAppointment(Appointment appointment) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: headers,
        body: jsonEncode(appointment.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Booking failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<List<Appointment>> getUserAppointments() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/appointments'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Appointment.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Mock data for development
  static List<Doctor> _getMockDoctors() {
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
      Doctor(
        id: '3',
        name: 'Dr. Emily Williams',
        specialization: 'Dermatologist',
        hospital: 'Skin Care Clinic',
        rating: 4.7,
        reviewCount: 156,
        yearsExperience: 10,
        patientCount: 1200,
        about: 'Expert in treating various skin conditions and cosmetic procedures.',
        workingHours: 'Mon - Fri (10:00 AM - 4:00 PM)',
        category: 'Dermatology',
        consultationFee: 130.0,
      ),
      Doctor(
        id: '4',
        name: 'Dr. James Brown',
        specialization: 'Orthopedic Surgeon',
        hospital: 'Orthopedic Center',
        rating: 4.8,
        reviewCount: 189,
        yearsExperience: 18,
        patientCount: 1800,
        about: 'Specialized in joint replacement and sports injury treatment.',
        workingHours: 'Mon - Sat (09:00 AM - 5:00 PM)',
        category: 'Orthopedics',
        consultationFee: 180.0,
      ),
    ];
  }

  static List<Article> _getMockArticles() {
    return [
      Article(
        id: '1',
        title: 'Understanding Heart Health: Prevention Tips',
        author: 'Dr. Sarah Johnson',
        content: 'Heart health is crucial for overall wellbeing. Regular exercise, a balanced diet, and stress management are key factors in maintaining a healthy heart...',
        category: 'Cardiology',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        readTime: 5,
        likes: 234,
      ),
      Article(
        id: '2',
        title: 'Children\'s Nutrition: A Complete Guide',
        author: 'Dr. Michael Chen',
        content: 'Proper nutrition is essential for children\'s growth and development. This guide covers everything you need to know about feeding your child...',
        category: 'Pediatrics',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        readTime: 8,
        likes: 189,
      ),
      Article(
        id: '3',
        title: 'Skin Care Basics for Every Season',
        author: 'Dr. Emily Williams',
        content: 'Your skin needs different care throughout the year. Learn how to adapt your skincare routine to changing weather conditions...',
        category: 'Dermatology',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        readTime: 6,
        likes: 312,
      ),
      Article(
        id: '4',
        title: 'Preventing Sports Injuries',
        author: 'Dr. James Brown',
        content: 'Sports injuries can be prevented with proper training and precautions. Here are essential tips for athletes of all levels...',
        category: 'Orthopedics',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        readTime: 7,
        likes: 156,
      ),
    ];
  }
}
