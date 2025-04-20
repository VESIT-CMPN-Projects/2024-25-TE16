import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meds/utils/ui_helper/app_theme.dart'; // Import FirebaseAuth

class PurchMed extends StatefulWidget {
  @override
  _DonatedMed_pageState createState() => _DonatedMed_pageState();
}

class _DonatedMed_pageState extends State<PurchMed> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // FirebaseAuth instance to get current user
  List<Map<String, dynamic>> medicinesList = [];

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  // Fetch Medicines from Firestore (only for the current user)
  Future<void> fetchMedicines() async {
    try {
      User? currentUser = _auth.currentUser; // Get current user

      if (currentUser != null) {
        // Fetch medicines only for the current user
        var medicinesCollection = await _firestore
            .collection('users')
            .doc(currentUser.uid) // Use current user's UID to fetch their data
            .collection('Selled Medicine')
            .get();

        List<Map<String, dynamic>> tempList = [];

        // Loop through medicines for the current user
        for (var medicineDoc in medicinesCollection.docs) {
          Map<String, dynamic> medicineData = medicineDoc.data();
          medicineData['donorEmail'] =
              currentUser.email; // Add current user's email as donor email
          tempList.add(medicineData);
        }

        setState(() {
          medicinesList = tempList;
        });
      } else {
        print('No user is logged in');
      }
    } catch (e) {
      print("Error fetching medicines: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased Medicines',
        style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
    ),
    backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Medicines',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Add search logic here (Optional)
              },
            ),
          ),

          // Medicines List
          Expanded(
            child: medicinesList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: medicinesList.length,
              itemBuilder: (context, index) {
                final medicine = medicinesList[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Medicine Image Placeholder
                        Image.asset(
                          'assets/images/medicine1.png' ??
                          medicine['ImagePath'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),

                        // Medicine Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medicine['medicine_name'] ?? "Unknown Medicine"}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Composition: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Bold for static text
                                        color: Colors
                                            .black, // Add color if needed
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                      '${medicine['composition_mg'] ?? "Unknown"}',
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .normal, // Regular weight for dynamic data
                                        color: Colors
                                            .black, // Add color if needed
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Expiry Date: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text:
                                      '${medicine['expiry_date'] ?? "N/A"}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Purchased Price: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text:
                                      '${medicine['selled_price'] ?? "Unknown"}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Quantity: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text:
                                      '${medicine['quantity'] ?? "N/A"}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Selled Quantity: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text:
                                      '${medicine['remaining_quantity'] ?? "N/A"}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Claim Button
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
