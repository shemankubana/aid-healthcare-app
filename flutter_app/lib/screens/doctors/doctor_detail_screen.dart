import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/doctor.dart';
import '../appointments/book_appointment_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Doctor Profile', style: TextStyle(color: AppColors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Card
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryBlue,
                    child: doctor.profileImage != null
                        ? ClipOval(
                            child: Image.network(
                              doctor.profileImage!,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 50, color: AppColors.white);
                              },
                            ),
                          )
                        : const Icon(Icons.person, size: 50, color: AppColors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.name, style: AppTextStyles.heading3),
                        Text(doctor.specialization, style: AppTextStyles.bodySmall),
                        Text(doctor.hospital, style: AppTextStyles.caption),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(' ${doctor.rating} Reviews', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('${doctor.yearsExperience}+', 'years experience'),
                  _buildStatCard('${doctor.patientCount}+', 'patients'),
                  _buildStatCard('${doctor.reviewCount}+', 'good reviews'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Text('About Doctor', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              Text(
                doctor.about ?? 'Experienced medical professional dedicated to patient care.',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
              ),
              
              const SizedBox(height: 24),
              
              Text('Working Time', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              Text(doctor.workingHours ?? 'Mon - Sat (08:30 AM - 5:00 PM)', style: AppTextStyles.bodySmall),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookAppointmentScreen(doctor: doctor),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Book Appointment', style: TextStyle(fontSize: 18, color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.heading3.copyWith(fontSize: 24)),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}