import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meds/screens/needy/free_needy/needy_confirmation_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class ConfirmOrderPage_Needy extends StatefulWidget {
  @override
  _ConfirmOrderPage_NeedyState createState() => _ConfirmOrderPage_NeedyState();
}

class _ConfirmOrderPage_NeedyState extends State<ConfirmOrderPage_Needy> {
  String? prescriptionImage; // Store the image path
  String selectedPaymentMethod = 'Debit Card'; // Default payment method

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        prescriptionImage = image.path; // Save the selected image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Order',
          style: AppFonts.headline,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Please review your order details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload Image of Prescription:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: prescriptionImage == null
                  ? const Center(child: Text('No image selected'))
                  : Image.file(
                      File(prescriptionImage!),
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Image'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please provide a reason for requesting the medicine for free:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your reason here',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order Confirmed!')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderConfirmationPage()),
                );
              },
              child: const Text('Confirm Order'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
