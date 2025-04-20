import 'package:flutter/material.dart';

class AppColors {
  // Primary and Secondary Colors
  static const Color primaryColor = Color(0xFFFF4D4D); // Red for primary buttons, highlights, or notifications
  static const Color secondaryColor = Color(0xFFFFB3B3); // Soft Pink for secondary buttons or accents
  
  // Text Colors
  static const Color textColor = Color(0xFF333333); // Dark grey for primary text and icons
  static const Color textColorSecondary = Color(0xFF757575); // Light grey for secondary text
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF0F0F0); // Light Gray for secondary backgrounds or borders
  static const Color whiteColor = Colors.white;
  static const Color lightGrey = backgroundColor; // Same as background color
  
  // Button Colors
  static const Color buttonPrimaryColor = primaryColor;
  static const Color buttonSecondaryColor = Color.fromARGB(255, 255, 138, 138); // Soft pink for secondary button
  static const Color buttonTextColor = whiteColor;
  static const Color buttonDisabledColor = Color(0xFFC8C8C8);
  
  // Status Colors
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.greenAccent;
  static const Color warningColor = Colors.yellowAccent;

  static var iconColor;
}

class AppFonts {
  static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Poppins';

  static final TextStyle heading = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: AppColors.whiteColor,
  );

  static final TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: AppColors.textColor,
  );

  static final TextStyle button = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.buttonTextColor,
  );

  static final TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textColorSecondary,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
  );
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontFamily: AppFonts.secondaryFont,
        color: AppColors.textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: const TextStyle(
        fontFamily: AppFonts.primaryFont,
        color: AppColors.textColor,
        fontSize: 16,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white, 
        fontSize: 20, 
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.buttonPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimaryColor,
        foregroundColor: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: const BorderSide(color: AppColors.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.whiteColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.secondaryColor),
      ),
      hintStyle: const TextStyle(color: AppColors.textColorSecondary),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textColor,
    ),
    cardTheme: CardTheme(
      color: AppColors.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
