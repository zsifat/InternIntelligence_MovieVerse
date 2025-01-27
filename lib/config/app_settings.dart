import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettings {
  static const String appName = 'MovieVerse';
  static const String appVersion = '1.0.0';

  // API Settings
  static const String apiBaseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '9a9a1f211e8524476b77be9ac35b84e4';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static const blackCustom = Color(0xFF090E17);
  static const greyCustom = Color(0xFF303D4F);
  static const blueCustom = Color(0xFF0084F3);

  static const whiteCustom = CupertinoColors.white;

  static TextStyle regular =
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: whiteCustom);

  static TextStyle regularSemibold =
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: whiteCustom);

  static TextStyle regularBold =
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: whiteCustom);
}
