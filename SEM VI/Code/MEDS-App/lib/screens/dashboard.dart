import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class MedicineDashboard extends StatelessWidget {
  const MedicineDashboard({Key? key, required int medicinesSold, required int medicinesDonated, required double totalRevenue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('dashboard').doc('stats').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildDefaultDashboard();
        }
        final data = snapshot.data!;
        int medicinesSold = data['medicinesSold'] ?? 0;
        int medicinesDonated = data['medicinesDonated'] ?? 0;
        double totalRevenue = (data['totalRevenue'] ?? 0).toDouble();

        return _buildDashboard(medicinesSold, medicinesDonated, totalRevenue);
      },
    );
  }

  Widget _buildDefaultDashboard() {
    return _buildDashboard(45, 120, 2500.5);
  }

  Widget _buildDashboard(int medicinesSold, int medicinesDonated, double totalRevenue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Dashboard Overview',
          style: AppFonts.heading.copyWith(color: AppColors.textColor),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricCard(
                    title: 'Medicines Sold',
                    value: medicinesSold.toString(),
                    icon: LucideIcons.pill,
                    iconColor: Colors.blue,
                  ),
                  _buildMetricCard(
                    title: 'Medicines Donated',
                    value: medicinesDonated.toString(),
                    icon: LucideIcons.heart,
                    iconColor: Colors.green,
                  ),
                  _buildMetricCard(
                    title: 'Total Revenue',
                    value: '₹${totalRevenue.toStringAsFixed(2)}',
                    icon: LucideIcons.wallet,
                    iconColor: Colors.orange,
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildMetricCard(
                    title: 'Medicines Sold',
                    value: medicinesSold.toString(),
                    icon: LucideIcons.pill,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildMetricCard(
                    title: 'Medicines Donated',
                    value: medicinesDonated.toString(),
                    icon: LucideIcons.heart,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildMetricCard(
                    title: 'Total Revenue',
                    value: '₹${totalRevenue.toStringAsFixed(2)}',
                    icon: LucideIcons.wallet,
                    iconColor: Colors.orange,
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppFonts.heading.copyWith(color: iconColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
