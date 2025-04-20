import 'package:flutter/material.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class BuyerConformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: AppFonts.headline,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your purchase!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Here are the details of your purchase:',
              style: TextStyle(fontSize: 18, color: AppColors.textColorSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Medicine:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                const SizedBox(width: 10),
                Text(
                  'Paracetamol',
                  style: TextStyle(fontSize: 18, color: AppColors.textColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                const SizedBox(width: 10),
                Text(
                  '2 boxes',
                  style: TextStyle(fontSize: 18, color: AppColors.textColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Total Price:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                const SizedBox(width: 10),
                Text(
                  'Rs.30',
                  style: TextStyle(fontSize: 18, color: AppColors.textColor),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => RecipientsHomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Go to Home', style: TextStyle(color: AppColors.textColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
