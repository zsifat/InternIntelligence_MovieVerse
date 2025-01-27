import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'states/auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(AuthState());


  User? getCurrentUser() {
    return _authService.currentUser;
  }

  /// Signup method
  Future<void> signup(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signupWithEmail(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Login method
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.loginWithEmail(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Logout method
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.logout();
      state = state.copyWith(user: null, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

/// AuthService provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// AuthViewModel provider (StateNotifier)
final authViewModelProvider =
StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthViewModel(authService);
});