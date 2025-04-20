import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/giver/donor/donor_dashboard.dart';
import 'package:meds/screens/giver/seller/seller_dashboard.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class DonorOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Give Medicines',
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
      body: SingleChildScrollView( // Added scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                imagePath: 'assets/images/donation.png',
                title: 'Donate your unused medicines to help those in need.',
                buttonText: 'Donate Medicines',
                onPressed: () {
                  Navigator.push(context, FadePageRoute(page: DonorDashboard()));
                },
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                imagePath: 'assets/images/sell.png',
                title: 'Sell surplus medicines at affordable prices.',
                buttonText: 'Sell Medicines',
                onPressed: () {
                  Navigator.push(context, FadePageRoute(page: SellerDashboard()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String imagePath,
        required String title,
        required String buttonText,
        required VoidCallback onPressed,
      }) {
    return Card(
      color: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding for smaller card
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure card size is compact
          children: [
            Image.asset(imagePath, height: 140, fit: BoxFit.contain), // Smaller image
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Smaller button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
