import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meds/screens/Status/Donated_med.dart';
import 'package:meds/screens/Status/Selled_med.dart';
import 'package:meds/screens/Status/purchased_med.dart';
import '../../utils/ui_helper/app_theme.dart';
import '../../utils/ui_helper/animations.dart';

class board_selector extends StatefulWidget {
  const board_selector({super.key});

  @override
  State<board_selector> createState() => _board_selectorState();
}

class _board_selectorState extends State<board_selector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'See Your Activities',
          style: AppFonts.headline.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BoxButton(
              label: "Donated Medicines",
              icon: FontAwesomeIcons.handHoldingHeart,
              onTap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: DonatedMed()),
                );
              },
            ),
            const SizedBox(height: 16),
            BoxButton(
              label: "Purchased Medicines",
              icon: Icons.shopping_cart,
              onTap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: PurchMed()),
                );
              },
            ),
            const SizedBox(height: 16),
            BoxButton(
              label: "Sold Medicines",
              icon: FontAwesomeIcons.moneyBillWave,
              onTap: () {
                Navigator.of(context).push(
                  FadePageRoute(page: SelledMed()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BoxButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const BoxButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BoxButton> createState() => _BoxButtonState();
}

class _BoxButtonState extends State<BoxButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          widget.onTap();
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(widget.icon, color: AppColors.whiteColor),
              const SizedBox(width: 16.0),
              Text(
                widget.label,
                style: AppFonts.body.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
