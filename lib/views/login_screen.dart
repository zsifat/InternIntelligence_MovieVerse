import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/viewmodels/auth_state_viewmodel.dart';
import 'package:movie_app/viewmodels/genre_viewmodel.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';
import 'package:movie_app/viewmodels/user_profile_viewmodel.dart';
import 'package:movie_app/views/bottom_navbar_screen.dart';
import 'package:movie_app/views/signup_screen.dart';
import 'package:movie_app/views/widgets/garadient_button_container.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context, String email, String password) async {
    ref.read(userProfileProvider.notifier).setLoading();
    if (_formKey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier).login(email, password);
      ref.read(moviesStateProvider.notifier).fetchInitialMovies();
      ref.read(genreProvider.notifier).loadGenres();
      if (ref.watch(authViewModelProvider).user != null) {
        await ref
            .read(userProfileProvider.notifier)
            .fetchUserProfile(ref.watch(authViewModelProvider).user!.uid);
        _emailController.clear();
        _passwordController.clear();
        if (ref.watch(userProfileProvider).userProfile != null && context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBarScreen(),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
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
        child: userProfileState.isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(radius: 10,),
                  const SizedBox(height: 20),
                  Text(
                    'Logging in...',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 300,
                    ),
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Log in to explore movies.',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: GoogleFonts.poppins(color: Colors.white54),
                              prefixIcon: const Icon(Icons.email, color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(26),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Color(0xFF0084F3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(26),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: GoogleFonts.poppins(color: Colors.white54),
                              prefixIcon: const Icon(Icons.lock, color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(26),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Color(0xFF0084F3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(26),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          // Login Button
                          InkWell(
                            onTap: () {
                              _handleLogin(context, _emailController.text.trim(),
                                  _passwordController.text.trim());
                            },
                            child: const GradientButtonContainer(buttonText: 'Log In'),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Forgot the password?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ));
                                },
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }
}
