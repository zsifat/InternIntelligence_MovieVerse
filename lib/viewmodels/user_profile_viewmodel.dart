import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/viewmodels/states/user_profile_state.dart';

import '../models/user_profile_model.dart';
import '../services/user_profile_db_service.dart';

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final FirestoreService _firestoreService = FirestoreService();

  UserProfileNotifier() : super(UserProfileState());

  // Fetch user profile from Firestore
  Future<void> fetchUserProfile(String? userId) async {
    state = state.copyWith(isLoading: true);

    try {
      final userProfile = await _firestoreService.fetchUserProfile(userId??state.userProfile!.userId);
      if (userProfile != null) {
        state = state.copyWith(userProfile: userProfile, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'User profile not found');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error fetching user profile: $e');
    }
  }

  // Save user profile to Firestore
  Future<void> saveUserProfile(UserProfile userProfile) async {
    state = state.copyWith(isLoading: true);

    try {
      await _firestoreService.saveUserProfile(userProfile);
      state = state.copyWith(userProfile: userProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error saving user profile: $e');
    }
  }

  // Fetch all user profiles (optional feature for admin)
  Future<void> fetchAllUserProfiles() async {
    try {
      final userProfiles = await _firestoreService.fetchAllUserProfiles();
      // You could add a state for all user profiles if necessary
    } catch (e) {
      print("Error fetching all user profiles: $e");
    }
  }


  Future<void> updateSavedMoviesInProfile(int movieId) async{
    try {
      await _firestoreService.updateSavedMoviesInProfile(state.userProfile!, movieId);
      fetchUserProfile(state.userProfile!.userId);
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> updateWatchedMoviesInProfile(int movieId) async{
    try {
      await _firestoreService.updateWatchedMoviesInProfile(state.userProfile!, movieId);
      fetchUserProfile(state.userProfile!.userId);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeFromSavedMovies(int movieId) async{
    try {
      await _firestoreService.removeFromSavedMovies(state.userProfile!, movieId);
      fetchUserProfile(state.userProfile!.userId);
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> removeFromWatchedMovies(int movieId) async{
    try {
      await _firestoreService.removeFromWatchedMovies(state.userProfile!, movieId);
      fetchUserProfile(state.userProfile!.userId);
    } catch (e) {
      throw Exception(e);
    }
  }

  void setLoading(){
    state = state.copyWith(isLoading: true);
  }

}

final userProfileProvider =
StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  return UserProfileNotifier();
});

