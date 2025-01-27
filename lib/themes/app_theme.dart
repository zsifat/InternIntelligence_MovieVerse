import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/config/app_settings.dart';

class AppTheme {
  // Define primary and background colors for light and dark themes
  static const Color _lightPrimaryColor = Colors.blue;
  static const Color _darkPrimaryColor = Color(0xFF1E88E5);
  static const Color _lightBackgroundColor = Colors.white;
  static const Color _darkBackgroundColor = Colors.black;

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimaryColor,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: _lightBackgroundColor,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
      titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _lightPrimaryColor,
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: _darkBackgroundColor,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: AppSettings.whiteCustom),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: AppSettings.whiteCustom),
      titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppSettings.whiteCustom),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: _darkPrimaryColor,
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
