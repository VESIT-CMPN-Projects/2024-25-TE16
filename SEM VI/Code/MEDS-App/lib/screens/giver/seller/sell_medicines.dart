import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meds/screens/giver/donor/donor_options_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SellMedicinePage(),
    theme: AppTheme.lightTheme,
  ));
}

class SellMedicinePage extends StatefulWidget {
  @override
  State<SellMedicinePage> createState() => _SellMedicinePageState();
}

class _SellMedicinePageState extends State<SellMedicinePage> {
  String? medicineImage;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _compositionMgController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _remainingQuantityController = TextEditingController();
  final TextEditingController _predictedPriceController = TextEditingController();

  final List<String> medicines = [
    "Ibuprofen", "Metformin", "Simvastatin", "Captopril", "Enalapril", "Omeprazole",
    "Lisinopril", "Atorvastatin", "Losartan", "Doxazosin", "Furosemide", "Veramil",
    "Nifedipine", "Cetirizine", "Amlodipine", "Loratin", "Pantoprazole", "Paracetamol",
    "Aspirin", "Ecosprin-AV", "Ecosprin", "Ativan", "Lorazam", "Valium", "Chlorpheniramine",
    "Doxylamine", "Famotidine", "Labetalol", "Prazosin", "Minipress XL", "Telmisartan",
    "Valsartan", "Olmesartan", "Candesar", "Loratadine", "Ivermectin", "Cilostazol",
    "Bisoprolol", "Hydrochlorothiazide", "Ramipril", "Doxycycline", "Levothyroxine",
    "Prednisolone", "Methotrexate", "Sulfasalazine", "Cyclosporin", "Esomeprazole",
    "Warfarin", "Cyclophosamide", "Methylprednisolone", "Tacrolimus", "Rosuvastatin",
    "Lansoprazole", "Lanzole", "Pravastatin", "Celecoxib", "Ezedoc", "Fenofibrate",
    "Lovastatin", "Hydrocortisone", "Amoxicillin", "Moxpic", "Gabapentin", "Citalopram",
    "Fluoxetine", "Allopurinol", "Alprazolam", "Atenolol", "Cefuroxime", "Clonazepam",
    "Digoxin", "Doxepin", "Enalapril maleate", "Hydroxyzine", "Ibuprofen lysine",
    "Mirtazapine", "Omeprazole sodi", "Quetiapine", "Sotatol", "Tamsulosin", "Terazosin",
    "Tetracycline", "Trazodone", "Go-Urea", "Venlafaxine", "Xanax", "Zolpidem",
    "Zopiclone", "Amitriptyline", "Aripiprazole", "Benzepril", "Cyclobenzaprine",
    "Diazepam", "Risperidone", "Naproxen", "Sildenafil", "Viagra Slidenafil",
    "Sumatripan", "Tadalafil", "Cialis", "Cephalexin", "Ciprofloxacin", "Augmentin",
    "Ceftriaxone", "Propranolol", "Clopidogrel", "Glipizide", "Glibenclamide",
    "Candesartan", "Indapamide", "Bromhexine", "Flutamide", "Piroxicam", "Torsemide",
    "Levetiracetam", "Pilocarpine", "Norethindrone", "Mifepristone", "Hyponosed",
    "Bromazepam", "Clobazam", "Lamictal", "Olanzapine", "Lithium", "Inthalith",
    "Topiramate", "Valproate", "Flunarizine", "Tramadol", "Methocarbamol", "Carbamazepine",
    "Pregabalin", "Voriconazole", "Escitalopram", "Haloperidol", "Oxcarbazepine",
    "Asenapine", "Bupropion", "Zolmitriptan", "Triazolam", "Ticagrelor", "Syncapone",
    "Paroxetine", "Nortriptyline", "Duloxetine", "Ceritinib", "Vardenafil",
    "Fexofenadine", "Montelukast", "Gliclazide", "Amlodipine besyl", "Glyboral",
    "Glimepride", "Niacin", "Alphadopa", "Toradol", "Cilnidipine", "Perindopril",
    "Satalol", "Katadol", "Teniva"
  ];

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_fetchPredictedPrice);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _predictedPriceController.dispose();
    _dateController.dispose();
    _medicineNameController.dispose();
    _compositionMgController.dispose();
    _quantityController.dispose();
    _remainingQuantityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        medicineImage = image.path;
      });
    }
  }

  void _fetchPredictedPrice() async {
    try {
      final response = await http.post(
        Uri.parse("https://ml-model-brnb.onrender.com/predict"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'medicine_name': _medicineNameController.text,
          'composition_mg': double.tryParse(_compositionMgController.text) ?? 0.0,
          'quantity': int.tryParse(_quantityController.text) ?? 0,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'remaining_quantity': int.tryParse(_remainingQuantityController.text) ?? 0,
          'expiry_date': _dateController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _predictedPriceController.text = responseData['predicted_price'].toString();
        });
      } else {
        throw Exception('Failed to fetch prediction');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  
  void _pickExpirationDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // format: yyyy-mm-dd
      });
    }
  }

  Future<void> _sellMedicine() async {
    try {
      final medicineData = {
        'medicine_name': _medicineNameController.text,
        'composition_mg': double.tryParse(_compositionMgController.text) ?? 0.0,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'remaining_quantity': int.tryParse(_remainingQuantityController.text) ?? 0,
        'expiry_date': _dateController.text,
        'selled_price': double.tryParse(_predictedPriceController.text) ?? 0.0,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in. Please log in to proceed.");
      }

      final sellDocRef = firestore.collection('users').doc(user.uid);
      final SellSnapshot = await sellDocRef.get();
      if (!SellSnapshot.exists) {
        throw Exception("User data not found in Firestore. Please log in again.");
      }

      int selling_count = 0;
      if (SellSnapshot.data()!.containsKey('SellingCount')) {
        selling_count = SellSnapshot.data()!['SellingCount'] as int;
      }
      selling_count++;

      await sellDocRef.collection('Selled Medicine').add(medicineData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SellConfirmationPage()),
      );
    } catch (e) {
      print('Error while saving medicine data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save medicine details.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Medicine', style: AppFonts.headline),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SellConfirmationPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: medicineImage == null
                    ? Container(
                        width: double.infinity,
                        height: 150,
                        color: AppColors.lightGrey,
                        child: Icon(Icons.add_a_photo, size: 50, color: AppColors.primaryColor),
                      )
                    : Image.file(
                        File(medicineImage!),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Medicine Name'),
                items: medicines
                    .map((medicine) => DropdownMenuItem<String>(
                          value: medicine,
                          child: Text(medicine, style: AppFonts.body),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _medicineNameController.text = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _compositionMgController,
                decoration: InputDecoration(labelText: 'Composition (mg)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _remainingQuantityController,
                decoration: InputDecoration(labelText: 'Remaining Quantity'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiry Date (yyyy-mm-dd)',
                  labelStyle: AppFonts.body,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: AppColors.iconColor),
                    onPressed: _pickExpirationDate,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _predictedPriceController,
                decoration: InputDecoration(labelText: 'Predicted Price'),
                enabled: false,
              ),
              SizedBox(height: 16),
             Column(
  mainAxisAlignment: MainAxisAlignment.center, // Center vertically (if within a larger container)
  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
  children: [
    ElevatedButton(
      onPressed: _fetchPredictedPrice,
      child: Text('Get Prediction',
       style: AppFonts.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimaryColor,
      ),
    ),
    SizedBox(height: 16),
    ElevatedButton(
      onPressed: _sellMedicine,
      child: Text('Sell Medicine', style: AppFonts.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimaryColor,
      ),
    ),
  ],
)
            ],
          ),
        ),
      ),
    );
  }
}

class SellConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation Page", style: AppFonts.headline),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: AppColors.secondaryColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thanks for reselling to us!",
                  style: AppFonts.headline.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DonorOptionsPage()),
                    );
                  },
                  child: Text("Go to Home", style: AppFonts.button),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimaryColor,
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