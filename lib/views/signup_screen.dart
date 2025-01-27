import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/user_profile_model.dart';
import 'package:movie_app/viewmodels/auth_state_viewmodel.dart';
import 'package:movie_app/viewmodels/genre_viewmodel.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';
import 'package:movie_app/viewmodels/user_profile_viewmodel.dart';
import 'package:movie_app/views/bottom_navbar_screen.dart';
import 'package:movie_app/views/login_screen.dart';
import 'package:movie_app/views/widgets/garadient_button_container.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    
    final authState = ref.watch(authViewModelProvider);
    final userProfile = ref.watch(userProfileProvider);
    
    // Create a global key for the form state
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: userProfile.isLoading ? const Center(child: CupertinoActivityIndicator(
        color: AppSettings.blueCustom,
      )) : Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(flex: 3),
            Text(
              'Sign Up',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Form(
              key: formKey, // Add the form key here
              child: Column(
                children: [
                  // Name TextField with Icon and hint
                  TextFormField(
                    controller: nameController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: GoogleFonts.poppins(color: const Color(0xFF999898)),
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF0084F3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF303D4F)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(color: Color(0xFF303D4F)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email TextField with Icon and hint
                  TextFormField(
                    controller: emailController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: GoogleFonts.poppins(color: const Color(0xFF999898)),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF0084F3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF303D4F)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(color: Color(0xFF303D4F)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password TextField with Icon and hint
                  TextFormField(
                    controller: passwordController,
                    obscureText: true, // To hide password text
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: GoogleFonts.poppins(color: const Color(0xFF999898)),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF0084F3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF303D4F)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(color: Color(0xFF303D4F)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Confirm Password TextField with Icon and hint
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true, // To hide confirm password text
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: GoogleFonts.poppins(color: const Color(0xFF999898)),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF0084F3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(width: 2, color: Color(0xFF303D4F)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: const BorderSide(color: Color(0xFF303D4F)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        // Attempt to sign up the user
                        await ref.read(authViewModelProvider.notifier)
                            .signup(emailController.text.trim(), passwordController.text.trim());

                        // Check if the user is successfully authenticated
                        if (ref.watch(authViewModelProvider).user != null) {
                          // Get the current authenticated user's UID from FirebaseAuth
                          String userId = ref.watch(authViewModelProvider).user!.uid;

                          // Create a UserProfile object and pass the correct userId
                          UserProfile userProfile = UserProfile(
                              userId: userId,
                              userName: nameController.text.trim(),
                              email: ref.watch(authViewModelProvider).user!.email!,
                              watchedMovies: [],
                              preferredGenres: [],
                              creationDate: DateTime.now(),
                              savedMovies: []
                          );

                          // Save the UserProfile in Firestore
                          await ref.read(userProfileProvider.notifier).saveUserProfile(userProfile);

                          ref.read(genreProvider.notifier).loadGenres();
                          ref.read(moviesStateProvider.notifier).fetchInitialMovies();

                          // Navigate to the BottomNavBarScreen after successful profile upload
                          if(context.mounted) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavBarScreen()));
                          }
                        }
                      }
                    },
                    child: const GradientButtonContainer(
                      buttonText: 'Sign Up'
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen(),));
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
