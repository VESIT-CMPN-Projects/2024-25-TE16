import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meds/screens/ngo/admin/approval_confirmation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class ViewDonatedMedicinesPage extends StatefulWidget {
  @override
  State<ViewDonatedMedicinesPage> createState() => _ViewDonatedMedicinesPageState();
}

class _ViewDonatedMedicinesPageState extends State<ViewDonatedMedicinesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allMedicines = [];
  List<Map<String, dynamic>> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  /// Fetches all donated medicines from each user’s “Donated Medicine” subcollection.
  Future<void> fetchMedicines() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> tempList = [];
      for (var userDoc in usersSnapshot.docs) {
        CollectionReference donatedMedicinesRef = userDoc.reference.collection('Donated Medicine');
        QuerySnapshot medicinesSnapshot = await donatedMedicinesRef.get();
        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data() as Map<String, dynamic>;
          // Save donor info so we can later delete the doc and map it in "Pharmacists".
          medicineData['userId'] = userDoc.id;
          medicineData['medicineDocId'] = medicineDoc.id;
          tempList.add(medicineData);
        }
      }
      setState(() {
        _allMedicines = tempList;
        _filteredMedicines = tempList;
      });
    } catch (e) {
      print('Error fetching medicines: $e');
    }
  }

  /// Filters the medicines based on the search query.
  void _searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredMedicines = _allMedicines.where((medicine) {
        final name = (medicine['MedicineName'] ?? '').toLowerCase();
        return name.contains(lowerQuery);
      }).toList();
    });
  }

  /// Handles the approval process.
  Future<void> _approveMedicine(Map<String, dynamic> medicine) async {
    final String donorId = medicine['userId'];
    final String medicineDocId = medicine['medicineDocId'];
    final String pharmacistId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await _firestore.collection('Pharmacists').doc(pharmacistId).set({
        'role': 'pharmacist',
      }, SetOptions(merge: true));

      await _firestore
          .collection('Pharmacists')
          .doc(pharmacistId)
          .collection('Approved Medicine')
          .doc(medicineDocId)
          .set(medicine);

      await _firestore
          .collection('users')
          .doc(donorId)
          .collection('Donated Medicine')
          .doc(medicineDocId)
          .delete();

      fetchMedicines();
    } catch (e) {
      print('Error approving medicine: $e');
    }
  }

  /// Handles the rejection process.
  Future<void> _rejectMedicine(Map<String, dynamic> medicine) async {
    final String donorId = medicine['userId'];
    final String medicineDocId = medicine['medicineDocId'];
    final String pharmacistId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await _firestore.collection('Pharmacists').doc(pharmacistId).set({
        'role': 'pharmacist',
      }, SetOptions(merge: true));

      await _firestore
          .collection('Pharmacists')
          .doc(pharmacistId)
          .collection('Rejected Medicine')
          .doc(medicineDocId)
          .set(medicine);

      await _firestore
          .collection('users')
          .doc(donorId)
          .collection('Donated Medicine')
          .doc(medicineDocId)
          .delete();

      fetchMedicines();
    } catch (e) {
      print('Error rejecting medicine: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donated Medicines',
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          // Search bar.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search Medicines',
                hintStyle: TextStyle(
                  fontFamily: AppFonts.primaryFont,
                  fontSize: 16,
                  color: AppColors.textColorSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.iconColor),
              ),
              onChanged: (value) {
                _searchMedicines(value);
              },
            ),
          ),
          // List of fetched and filtered medicines.
          Expanded(
            child: _filteredMedicines.isEmpty
                ? Center(child: Text('Loading medicines...'))
                : ListView.builder(
                    itemCount: _filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = _filteredMedicines[index];
                      final name = medicine['MedicineName'] ?? 'Unknown Medicine';
                      final manufacturer = medicine['Manufacturer'] ?? 'Unknown Manufacturer';
                      final expiryDate = medicine['ExpirationDate'] ?? 'No Expiry Date';
                      final price = medicine['Price'] ?? 'N/A';
                      final imagePath = medicine['ImagePath'] ?? 'default_image.jpg';

                      return Card(
                        margin: const EdgeInsets.all(10),
                        color: AppColors.backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/$imagePath',
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.medical_services, size: 50);
                                },
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontFamily: AppFonts.secondaryFont,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    Text(
                                      'Manufacturer: $manufacturer',
                                      style: TextStyle(
                                        fontFamily: AppFonts.primaryFont,
                                        fontSize: 14,
                                        color: AppColors.textColorSecondary,
                                      ),
                                    ),
                                    Text(
                                      'Expiry Date: $expiryDate',
                                      style: TextStyle(
                                        fontFamily: AppFonts.primaryFont,
                                        fontSize: 14,
                                        color: AppColors.textColorSecondary,
                                      ),
                                    ),
                                    Text(
                                      'Price: $price',
                                      style: TextStyle(
                                        fontFamily: AppFonts.primaryFont,
                                        fontSize: 14,
                                        color: AppColors.textColorSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Approve and Reject buttons.
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await _approveMedicine(medicine);
                                            setState(() {
                                              _allMedicines.removeAt(index);
                                              _filteredMedicines.removeAt(index);
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NGOActionConfirmationPage(isApproved: true),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.buttonPrimaryColor,
                                          ),
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                              fontFamily: AppFonts.secondaryFont,
                                              fontSize: 16,
                                              color: AppColors.buttonTextColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await _rejectMedicine(medicine);
                                            setState(() {
                                              _allMedicines.removeAt(index);
                                              _filteredMedicines.removeAt(index);
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NGOActionConfirmationPage(isApproved: false),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.buttonSecondaryColor,
                                          ),
                                          child: Text(
                                            'Reject',
                                            style: TextStyle(
                                              fontFamily: AppFonts.secondaryFont,
                                              fontSize: 16,
                                              color: AppColors.buttonTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
