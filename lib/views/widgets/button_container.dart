import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonContainer extends StatelessWidget {
  final bool isWhite;
  final String buttonText;
  const ButtonContainer(
      {super.key, required this.buttonText, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
          border: isWhite ? const Border() : Border.all(color: const Color(0xFF0084F3)),
          borderRadius: BorderRadius.circular(18),
          color: isWhite ? Colors.white : const Color(0xFF303D4F)),
      child: Center(
          child: Text(
        buttonText,
        style: GoogleFonts.poppins(
            color: isWhite ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      )),
    );
  }
}
