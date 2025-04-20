import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';
import 'package:meds/screens/ngo/pharmacist/view_donated_medicine.dart';

class PharmacistDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Redirect to the ViewDonatedMedicinesPage as soon as this page loads.
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewDonatedMedicinesPage()),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pharmacist Dashboard',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      ),
    );
  }
}
