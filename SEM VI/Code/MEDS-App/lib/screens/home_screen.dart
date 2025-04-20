import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/screens/giver/donor/donor_options_page.dart';
import 'package:meds/screens/needy/recipients_home_page.dart';
import 'package:meds/screens/ngo/ngo_dashboard_page.dart';
import 'package:meds/widgets/app_drawer.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';
import 'dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The new design:
    // 1. AppBar title is "Welcome to MEDS".
    // 2. The original green banner ("Welcome to MEDS") is removed.
    // 3. The MedicineDashboard is now placed at the top.
    // 4. Below the dashboard, we show a horizontal slider for Giver/Donor, Needy, and NGO cards.
    // 5. The floating chatbot button is commented out.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to MEDS',
          style: AppFonts.heading.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.whiteColor),
            onPressed: () async {
              bool? exit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Log Out'),
                  content: const Text('Are you sure you want to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (exit == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dashboard widget moved to the top.
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: MedicineDashboard(
                  medicinesSold: 120,
                  medicinesDonated: 45,
                  // topRequestedMedicines: ["Paracetamol", "Ibuprofen", "Amoxicillin"],
                  totalRevenue: 2500.75,
                ),
              ),
              const SizedBox(height: 20),
              // Horizontal sliding cards for Giver/Donor, Needy, NGO.
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSlidingCard(
                      context,
                      title: 'Giver/Donor',
                      icon: Icons.volunteer_activism,
                      color: Colors.blue[100]!,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DonorOptionsPage()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildSlidingCard(
                      context,
                      title: 'Needy',
                      icon: Icons.currency_rupee_outlined,
                      color: Colors.green[100]!,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipientsHomePage()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildSlidingCard(
                      context,
                      title: 'NGO',
                      icon: Icons.group,
                      color: Colors.pink[100]!,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NGODashboardPage()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Floating Chatbot Button is commented out as per requirement.
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ChatbotScreen()),
      //   ),
      //   backgroundColor: AppColors.primaryColor,
      //   child: ClipOval(
      //     child: Image.asset('assets/images/ai_chat.gif', fit: BoxFit.cover),
      //   ),
      // ),
    );
  }

  Widget _buildSlidingCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppFonts.body.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
