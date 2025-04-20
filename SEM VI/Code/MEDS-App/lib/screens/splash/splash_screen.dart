import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/widgets/instruction_slider.dart';
import 'package:meds/screens/home_screen.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for 1.5 seconds.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Scale animation: from 80% to 100%.
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    // Fade animation: from invisible to fully visible.
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Show splash for 2 seconds.
    await Future.delayed(const Duration(seconds: 2));

    // Get current user.
    User? user = FirebaseAuth.instance.currentUser;

    // Access SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenInstructions = prefs.getBool('hasSeenInstructions') ?? false;
    bool isLoggedOut = prefs.getBool('isLoggedOut') ?? false;

    // Navigate based on login state and instructions flag.
    if (user != null && !isLoggedOut) {
      if (hasSeenInstructions) {
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const InstructionSlider()),
        );
      }
    } else {
      prefs.remove('isLoggedOut'); // Clear logout status.
      Navigator.pushReplacement(
        context,
        FadePageRoute(page: const InstructionSlider()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/meds_start.png',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "MEDS",
                    style: AppFonts.heading.copyWith(
                      fontSize: 36,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Medicine Exchange and Distribution System",
                    style: AppFonts.body.copyWith(
                      fontSize: 16,
                      color: AppColors.whiteColor.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
