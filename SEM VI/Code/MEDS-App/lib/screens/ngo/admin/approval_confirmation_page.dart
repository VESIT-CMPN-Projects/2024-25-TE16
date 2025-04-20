import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class NGOActionConfirmationPage extends StatelessWidget {
  final bool isApproved;

  NGOActionConfirmationPage({required this.isApproved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isApproved ? 'Medicine Approved' : 'Medicine Rejected',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: isApproved ? AppColors.successColor : AppColors.errorColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isApproved ? Icons.check_circle_outline : Icons.cancel_outlined,
              size: 100,
              color: isApproved ? AppColors.successColor : AppColors.errorColor,
            ),
            const SizedBox(height: 20),
            Text(
              isApproved
                  ? 'You have successfully approved the donation.'
                  : 'You have rejected the donation request.',
              style: AppFonts.body.copyWith(color: AppColors.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Go back to Dashboard',
                style: AppFonts.button.copyWith(color: AppColors.whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
