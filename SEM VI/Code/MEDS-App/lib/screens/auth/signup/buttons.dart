import 'package:flutter/material.dart';
import 'package:meds/utils/ui_helper/animations.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';

class MyButtons extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const MyButtons({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  _MyButtonsState createState() => _MyButtonsState();
}

class _MyButtonsState extends State<MyButtons> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: AnimatedScale(
            scale: _isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                color: _isHovered ? Colors.grey[800] : Colors.black,
                shadows: [
                  if (_isHovered)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Text(
                widget.text,
                style: AppFonts.button.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
