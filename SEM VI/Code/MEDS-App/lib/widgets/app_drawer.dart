import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/widgets/profile.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/utils/ui_helper/animations.dart';
import 'package:meds/screens/Status/board_selector.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? 'User';
    String photoUrl = user?.photoURL ?? 'assets/images/male_avatar.png';

    return Drawer(
      child: Container(
        color: AppColors.backgroundColor,
        child: FadeTransition(
          opacity: AlwaysStoppedAnimation(
              1.0), // Replace with custom animation if desired.
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Profile Header
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: photoUrl.startsWith('assets')
                            ? AssetImage(photoUrl) as ImageProvider
                            : NetworkImage(photoUrl),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        displayName,
                        style: AppFonts.heading.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Navigation Sections
              ListTile(
                leading: Icon(Icons.person, color: AppColors.primaryColor),
                title: Text('Profile', style: AppFonts.body),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              Divider(color: AppColors.primaryColor.withOpacity(0.5)),
              ListTile(
                leading: Icon(Icons.volunteer_activism,
                    color: AppColors.primaryColor),
                title: Text('NGO', style: AppFonts.body),
                onTap: () {
                  Navigator.pushNamed(context, '/ngo');
                },
              ),
              ListTile(
                leading: Icon(Icons.handshake, color: AppColors.primaryColor),
                title: Text('Donor', style: AppFonts.body),
                onTap: () {
                  Navigator.pushNamed(context, '/donor');
                },
              ),
              ListTile(
                leading: Icon(Icons.gif_box, color: AppColors.primaryColor),
                title: Text('Giver', style: AppFonts.body),
                onTap: () {
                  Navigator.pushNamed(context, '/giver');
                },
              ),
              Divider(color: AppColors.primaryColor.withOpacity(0.5)),
              ListTile(
                leading:
                    Icon(Icons.check_circle, color: AppColors.primaryColor),
                title: Text('Status', style: AppFonts.body),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const board_selector()),
                  );
                },
              ),
              Divider(color: AppColors.primaryColor.withOpacity(0.5)),
              // Logout Section
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.primaryColor),
                title: Text('Logout', style: AppFonts.body),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Are you sure you want to logout?',
                        style: AppFonts.heading
                            .copyWith(fontSize: 18, color: AppColors.textColor),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: AppFonts.body
                                .copyWith(color: AppColors.primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              FadePageRoute(page: const LoginPage()),
                            );
                          },
                          child: Text(
                            'Yes',
                            style: AppFonts.body
                                .copyWith(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
