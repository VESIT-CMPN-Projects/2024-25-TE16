import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class ConfirmOrderPageBuyer extends StatefulWidget {
  @override
  _ConfirmOrderPageBuyerState createState() => _ConfirmOrderPageBuyerState();
}

class _ConfirmOrderPageBuyerState extends State<ConfirmOrderPageBuyer> {
  String? prescriptionImage;
  String selectedPaymentMethod = 'Debit Card';
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        prescriptionImage = image.path;
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
            Text(
              'Please review your order details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload Image of Prescription:',
              style: TextStyle(fontSize: 18, color: AppColors.textColor),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textColorSecondary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: prescriptionImage == null
                  ? Center(child: Text('No image selected', style: TextStyle(color: AppColors.textColor)))
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
            ElevatedButton(
              onPressed: () {
                var options = {
                  'key': 'rzp_test_GcZZFDPP0jHtC4',
                  'amount': 1000,
                  'name': 'Medicine order',
                  'description': 'Easy Redistribution',
                  'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
                };
                razorpay.open(options);
              },
              child: const Text('Proceed for Payment >>'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Successful!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BuyerHomePage()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed!");
  }

  @override
  void dispose() {
    try {
      razorpay.clear();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }
}

class BuyerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Home Page', style: AppFonts.headline),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Text(
          'Welcome to Buyer Home Page!',
          style: TextStyle(fontSize: 18, color: AppColors.textColor),
        ),
      ),
    );
  }
}
