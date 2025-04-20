import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/needy/buyer/buyer_home_page.dart';
import 'package:meds/screens/needy/free_needy/needy_home_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class RecipientsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Medicine',
          style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                FadePageRoute(page: LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Enabled scrolling to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOptionCard(
                context,
                imagePath: 'assets/images/sell.png',
                title: 'Buy medicines easily at the best prices.',
                buttonText: 'Buy at best price',
                onPressed: () {
                  Navigator.push(context, FadePageRoute(page: Buyer_Home_page()));
                },
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                imagePath: 'assets/images/free_medicine.png',
                title: 'Access free medicines for those in need.',
                buttonText: 'Apply for free medicine',
                onPressed: () {
                  Navigator.push(context, FadePageRoute(page: NeedyHomePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required String title, required String buttonText, required VoidCallback onPressed, required String imagePath}) {
    return Card(
      color: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures the card adjusts dynamically
          children: [
            ClipRRect( // Ensures image follows rounded corners
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, height: 140, width: double.infinity, fit: BoxFit.contain), // Image properly fits
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppFonts.body.copyWith(color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText, style: AppFonts.button),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
