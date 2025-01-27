import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/config/app_settings.dart';

class GradientButtonContainer extends StatelessWidget {
  final String buttonText;
  const GradientButtonContainer({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4AB9FF),  // Start color
            Color(0xFF0084F3),  // End color
          ],
          begin: Alignment.topLeft,  // Starting position of the gradient
          end: Alignment.bottomRight,  // Ending position of the gradient
        ),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: GoogleFonts.poppins(color: AppSettings.whiteCustom, fontSize: 14),
        ),
      ),
    );
  }
}
