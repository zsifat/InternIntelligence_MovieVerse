import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/services/shared_prefs_service.dart';
import 'package:movie_app/viewmodels/auth_state_viewmodel.dart';
import 'package:movie_app/viewmodels/states/splash_state.dart';

class SplashNotifier extends StateNotifier<SplashState> {

  final Ref ref;
  final sharedPrefsService = SharedPrefsService();
  SplashNotifier(this.ref) : super(SplashState.loading) {
    _init();
  }

  Future<void> _init() async {
    // Check if first-time user
    bool isFirstTime = await sharedPrefsService.isFirstTime();
    if (isFirstTime) {
      state = SplashState.welcome;
      return;
    }
    // Check if user is logged in
    final currentUser = ref.read(authViewModelProvider.notifier).getCurrentUser();
    if (currentUser != null) {
      state = SplashState.home;
    } else {
      state = SplashState.login;
    }
  }
}

final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>(
      (ref) => SplashNotifier(ref),
);