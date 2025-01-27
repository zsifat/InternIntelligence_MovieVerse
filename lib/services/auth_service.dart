import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///Current User
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  /// Signup with email and password
  Future<User?> signupWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Signup Error: $e");
      throw Exception("Failed to signup: $e");
    }
  }

  /// Login with email and password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      throw Exception("Failed to login: $e");
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Logout Error: $e");
      throw Exception("Failed to logout: $e");
    }
  }

  /// Check if user is logged in
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
