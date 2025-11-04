import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/doctor.dart';
import '../../models/article.dart';
import '../../services/api_service.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/article_card.dart';
import '../doctors/doctor_list_screen.dart';
import '../doctors/doctor_detail_screen.dart';
import '../articles/article_detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Doctor> _recommendedDoctors = [];
  List<Article> _recentArticles = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final doctors = await ApiService.getDoctors();
    final articles = await ApiService.getArticles();
    
    setState(() {
      _recommendedDoctors = doctors.take(4).toList();
      _recentArticles = articles.take(4).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Header Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(54),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: AppColors.white),
                            onPressed: () {
                              // Open drawer
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              backgroundColor: AppColors.white,
                              child: Icon(Icons.person),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Greeting
                      Text(
                        "Let's get started",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Main Headline
                      Text(
                        'Manage your health,\nand take control with us!',
                        style: AppTextStyles.heading2,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search hospital here...',
                            hintStyle: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textGray,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Categories Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: AppTextStyles.heading3.copyWith(fontSize: 18),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Category Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryCard(
                          'Public',
                          Icons.local_hospital,
                          'Public',
                        ),
                        _buildCategoryCard(
                          'Private',
                          Icons.medical_services,
                          'Private',
                        ),
                        _buildCategoryCard(
                          'Community',
                          Icons.people,
                          'Community',
                        ),
                        _buildCategoryCard(
                          'Speciality',
                          Icons.medication,
                          'Specialty',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Recommended Doctors Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended Doctors',
                      style: AppTextStyles.heading3.copyWith(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DoctorListScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Doctors List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 220,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        itemCount: _recommendedDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _recommendedDoctors[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: DoctorCard(
                              doctor: doctor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorDetailScreen(
                                      doctor: doctor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
              
              const SizedBox(height: 32),
              
              // Recent Articles Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Recent Articles',
                  style: AppTextStyles.heading3.copyWith(fontSize: 18),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Articles List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _recentArticles.length,
                      itemBuilder: (context, index) {
                        final article = _recentArticles[index];
                        return ArticleCard(
                          article: article,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(
                                  article: article,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorListScreen(category: category),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 62,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Icon(icon, size: 24, color: AppColors.primaryBlue),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}