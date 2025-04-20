import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/app_theme.dart'; // Unified theme import
import 'package:meds/screens/giver/donor/donor_options_page.dart';

class DonationConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> medicine;

  DonationConfirmationPage({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final String name = medicine['MedicineName'] ?? 'Unknown Medicine';
    final String strength = medicine['Strength'] ?? 'Unknown Strength';
    final String quantity = medicine['Quantity'] ?? 'Unknown Quantity';
    final String expirationDate = medicine['ExpirationDate'] ?? 'Unknown Expiration Date';
    final String manufacturer = medicine['Manufacturer'] ?? 'Unknown Manufacturer';
    final String notes = medicine['Notes'] ?? 'No Notes Provided';
    final String imagePath = medicine['ImagePath'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Donation Confirmation",
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            color: AppColors.backgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thank you for donating!",
                  style: TextStyle(
                    fontFamily: AppFonts.secondaryFont,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "You are donating the following medicine:",
                  style: TextStyle(
                    fontFamily: AppFonts.secondaryFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Medicine Name: $name",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Strength: $strength",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Quantity: $quantity",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Expiration Date: $expirationDate",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Manufacturer: $manufacturer",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Notes: $notes",
                          style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        imagePath.isNotEmpty
                            ? Image.file(
                                File(imagePath),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonorOptionsPage(),
                      ),
                    );
                  },
                  child: const Text("Back", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
