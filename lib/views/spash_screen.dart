// Splash screen that determines the navigation flow based on the app's state.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/viewmodels/spash_viewmodel.dart';
import 'package:movie_app/views/bottom_navbar_screen.dart';
import 'package:movie_app/views/wellcome_screen.dart';
import 'package:movie_app/views/widgets/animated_splash_text.dart';
import '../viewmodels/auth_state_viewmodel.dart';
import '../viewmodels/genre_viewmodel.dart';
import '../viewmodels/movies_viewmodel.dart';
import '../viewmodels/states/splash_state.dart';
import '../viewmodels/user_profile_viewmodel.dart';
import 'login_screen.dart';

// SplashScreen Widget to handle navigation based on app state
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref
        .watch(splashProvider); // Watch the splash state to determine which screen to navigate to

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navigate based on state
      switch (splashState) {
        case SplashState.welcome:
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (_) => const WelcomeScreen()),
          );
          break;
        case SplashState.home:
          // Fetch initial data and navigate to the Home Screen (Bottom Navbar)
          handleFetch(ref).then(
            (value) {
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => const BottomNavBarScreen(),
                  ),
                );
              }
            },
          );

          break;
        case SplashState.login:
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (_) => const LoginScreen()),
          );
          break;
        default:
          break;
      }
    });
    // Build the splash screen UI
    return Scaffold(body: CupertinoPageScaffold(child: _buildSplashUI()));
  }

  // Widget for the splash screen UI
  Widget _buildSplashUI() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF4AB9FF), // Start color
                  Color(0xFF0084F3),
                ], // End color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'MovieVerse',
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Modern Circular Progress Indicator
            const CupertinoActivityIndicator(
              radius: 18,
            ),

            // Subtle Animated Tagline
            const AnimatedText(),
          ],
        ),
      ),
    );
  }

  // Handles initial data fetching before navigating to the Home Screen
  Future<void> handleFetch(WidgetRef ref) async {
    try {
      await ref.read(moviesStateProvider.notifier).fetchInitialMovies();
      await ref.read(genreProvider.notifier).loadGenres();
      await ref
          .read(userProfileProvider.notifier)
          .fetchUserProfile(ref.read(authViewModelProvider.notifier).getCurrentUser()!.uid);
    } catch (error) {
      throw Exception(error);
    }
  }
}
