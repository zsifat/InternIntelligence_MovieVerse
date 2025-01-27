// Entry point for the MovieVerse application
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/themes/app_theme.dart';
import 'package:movie_app/views/spash_screen.dart';

// The main function is the starting point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Launch the app and provide Riverpod's ProviderScope for state management
  runApp(const ProviderScope(child: MyApp()));
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieVerse',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
