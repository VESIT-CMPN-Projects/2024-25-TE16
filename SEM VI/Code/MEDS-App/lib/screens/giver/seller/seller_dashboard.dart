import 'package:flutter/material.dart';
import 'package:meds/screens/giver/seller/sell_medicines.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class SellerDashboard extends StatefulWidget {
  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'dosageForm': 'Tablet',
      'strength': '500mg',
      'quantityAvailable': 10,
      'expiryDate': '2025-12-01',
      'manufacturer': 'ABC Pharmaceuticals',
      'image': 'Paracetamol.jpeg',
    },
    {
      'name': 'Ibuprofen',
      'dosageForm': 'Tablet',
      'strength': '200mg',
      'quantityAvailable': 15,
      'expiryDate': '2024-06-15',
      'manufacturer': 'XYZ Pharmaceuticals',
      'image': 'Ibuprofen.jpeg',
    },
    // Add more medicines as needed
  ];

  List<Map<String, dynamic>> filteredMedicines = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMedicines = medicines;
    _searchController.addListener(() {
      filterMedicines();
    });
  }

  void filterMedicines() {
    setState(() {
      filteredMedicines = medicines
          .where((medicine) => medicine['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi!, User', style: AppFonts.headline),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search Medicines',
                prefixIcon: const Icon(Icons.search),
                hintStyle: AppFonts.body.copyWith(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: medicines.length + 1, // Extra for FAB section
              itemBuilder: (context, index) {
                if (index == medicines.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                FadePageRoute(page: SellMedicinePage()),
                              );
                            },
                            child: const Icon(Icons.add),
                            backgroundColor: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Need to add new medicines to your list?",
                          style: AppFonts.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Simply tap the '+' button to quickly add and manage your medicine stock. Ensure that you regularly update expired medicines.",
                          style: AppFonts.body.copyWith(
                            fontSize: 14,
                            color: AppColors.textColorSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                final medicine = medicines[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/${medicine["image"]}',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine['name'],
                                style: AppFonts.body.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                              Text(
                                'Manufacturer: ${medicine['manufacturer']}',
                                style: AppFonts.body.copyWith(
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                'Expiry Date: ${medicine['expiryDate']}',
                                style: AppFonts.body.copyWith(
                                  fontSize: 14,
                                  color: AppColors.textColorSecondary,
                                ),
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
