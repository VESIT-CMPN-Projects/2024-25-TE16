import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/widgets/snackbar.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final FocusNode _focusNode = FocusNode(); // FocusNode for email field

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            myDialogBox(context);
          },
          child: Text(
            "Forgot Password?",
            style: AppFonts.body.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }

  void myDialogBox(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        "Forgot Your Password",
                        style: AppFonts.heading.copyWith(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Enter the Email",
                      labelStyle: AppFonts.body.copyWith(color: AppColors.textColor),
                      hintText: "eg abc@gmail.com",
                      hintStyle: AppFonts.body.copyWith(color: AppColors.textColorSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () async {
                      await auth.sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        showCustomSnackBar(
                          context,
                          "We have sent you the reset password link to your email id, Please check it",
                        );
                      }).onError((error, stackTrace) {
                        showCustomSnackBar(context, error.toString());
                      });
                      Navigator.pop(context);
                      emailController.clear();
                    },
                    child: Text(
                      "Send",
                      style: AppFonts.button.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return AppAnimations.scaleTransition(
          child: child,
          animation: animation,
        );
      },
    );
    _focusNode.requestFocus();
  }
}
