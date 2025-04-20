import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> fetchMedicines() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> tempList = [];
      for (var userDoc in usersSnapshot.docs) {
        CollectionReference donatedMedicinesRef = userDoc.reference.collection('Donated Medicine');
        QuerySnapshot medicinesSnapshot = await donatedMedicinesRef.get();
        for (var medicineDoc in medicinesSnapshot.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data() as Map<String, dynamic>;
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

  void _searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredMedicines = _allMedicines.where((medicine) {
        final name = (medicine['MedicineName'] ?? '').toLowerCase();
        return name.contains(lowerQuery);
      }).toList();
    });
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
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
          // List of fetched (and filtered) medicines
          Expanded(
            child: _filteredMedicines.isEmpty
                ? Center(child: Text('Loading donated Medicines...'))
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
                        margin: EdgeInsets.all(10),
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
                              SizedBox(width: 10),
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
                                    SizedBox(height: 10),
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
