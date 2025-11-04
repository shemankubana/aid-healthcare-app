import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // App Logo or Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.medical_services,
                  size: 60,
                  color: AppColors.white,
                ),
              ),

              const SizedBox(height: 32),

              // App Title
              Text(
                'Aid Healthcare',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 36,
                ),
              ),

              const SizedBox(height: 16),

              // App Description
              Text(
                'Your health companion',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGray,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Manage your health and take control with us!',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGray,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.primaryBlue,
                textColor: AppColors.white,
              ),

              const SizedBox(height: 16),

              // Register Button
              CustomButton(
                text: 'Create Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.white,
                textColor: AppColors.primaryBlue,
                border: Border.all(color: AppColors.primaryBlue, width: 2),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
