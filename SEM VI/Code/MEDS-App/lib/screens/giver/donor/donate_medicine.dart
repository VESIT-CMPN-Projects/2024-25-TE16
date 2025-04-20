import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/screens/giver/donor/donation_confirmation_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart'; // Contains AppColors & AppFonts
// import 'package:meds/utils/ui_helper/animations.dart'; // For any potential animations

class DonateMedicinePage extends StatefulWidget {
  @override
  State<DonateMedicinePage> createState() => _DonateMedicinePageState();
}

class _DonateMedicinePageState extends State<DonateMedicinePage> {
  String? medicineImage;
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image Picker
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        medicineImage = image.path; // Save the selected image path
      });
    }
  }

  DateTime? _selectedDate;

  Future<void> _pickExpirationDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent picking past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _expirationDateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format: YYYY-MM-DD
      });
    }
  }

  // Submit donation to Firestore
  Future<void> _submitDonation() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in. Please log in to proceed.");
      }
      final donorDocRef = firestore.collection('users').doc(user.uid);
      final donorSnapshot = await donorDocRef.get();

      if (!donorSnapshot.exists) {
        throw Exception("User data not found in Firestore. Please log in again.");
      }

      final medicineData = {
        'MedicineName': _medicineNameController.text,
        'Strength': _strengthController.text,
        'Quantity': _quantityController.text,
        'ExpirationDate': _expirationDateController.text,
        'Manufacturer': _manufacturerController.text,
        'Notes': _notesController.text,
        'ImagePath': medicineImage ?? '',
        'DonationDate': DateTime.now().toIso8601String(),
      };

      await donorDocRef.collection('Donated Medicine').add(medicineData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DonationConfirmationPage(medicine: medicineData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donate Medicines',
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _medicineNameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: AppColors.textColor,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _strengthController,
                decoration: InputDecoration(
                  labelText: 'Strength (e.g., 500 mg)',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: AppColors.textColor,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity Available',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: AppColors.textColor,
                  ),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _expirationDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiration Date (YYYY-MM-DD)',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: AppColors.textColor,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: AppColors.iconColor),
                    onPressed: _pickExpirationDate,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  labelText: 'Manufacturer',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: AppColors.textColor,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Additional Notes (optional)',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: AppColors.textColor,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: medicineImage == null
                    ? Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      )
                    : Image.file(
                        File(medicineImage!),
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text(
                  'Upload Image',
                style: TextStyle(color: AppColors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonPrimaryColor),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitDonation,
                child: const Text('Submit Donation',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
