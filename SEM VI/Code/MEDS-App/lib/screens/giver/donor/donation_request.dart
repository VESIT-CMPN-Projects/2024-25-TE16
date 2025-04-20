import 'package:flutter/material.dart';
import 'package:meds/screens/ngo/admin/admin_dashboard_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart'; // Contains unified theme data
// import 'package:meds/utils/ui_helper/animations.dart'; // For transitions if needed

class DonationRequestPage extends StatelessWidget {
  final String medicineName;
  final String quantity;
  final String strength;
  final String urgency;

  DonationRequestPage({
    required this.medicineName,
    required this.quantity,
    required this.strength,
    required this.urgency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Request Details',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Request Details:',
              style: AppFonts.heading.copyWith(color: AppColors.textColor),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medicine Name: $medicineName',
                      style: AppFonts.body.copyWith(color: AppColors.textColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Quantity Needed: $quantity',
                      style: AppFonts.body.copyWith(color: AppColors.textColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Strength: $strength',
                      style: AppFonts.body.copyWith(color: AppColors.textColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Urgency: $urgency',
                      style: AppFonts.body.copyWith(color: AppColors.textColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardPage(),
                  ),
                );
              },
              child: Text(
                'Back to Dashboard',
                style: AppFonts.button.copyWith(color: AppColors.whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
