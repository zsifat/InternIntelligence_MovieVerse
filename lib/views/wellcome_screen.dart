import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/views/login_screen.dart';
import 'package:movie_app/views/signup_screen.dart';
import 'package:movie_app/views/widgets/button_container.dart';
import 'package:movie_app/views/widgets/garadient_button_container.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/movie_poster_app.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3,),
            // App Title
            Text(
              'MovieVerse',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    blurRadius: 8,
                    color: Colors.black87,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Subheading Text
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                children: const [
                  TextSpan(
                    text: 'Discover movies you love, ',
                  ),
                  TextSpan(
                    text: 'rate them, and share reviews ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'with the world.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Login Button
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
              child: const ButtonContainer(buttonText: 'Log in'),
            ),
            const SizedBox(height: 15),
            // Sign-Up Button
            InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                ),
                child: const GradientButtonContainer(buttonText: 'Sign Up')),
            const Spacer(),
            // Footer Text
            Text(
              'Your movie journey begins here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
