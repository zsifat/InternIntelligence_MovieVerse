import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile_model.dart'; // Import Firebase Auth

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add or update a UserProfile in Firestore
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {

      final userRef = _db.collection('user_profiles').doc(userProfile.userId);

      // Convert the UserProfile to a Map
      Map<String, dynamic> userProfileMap = userProfile.toJson();

      // Save or update the UserProfile
      await userRef.set(userProfileMap, SetOptions(merge: true)); // Merges if user already exists
    } catch (e) {
      print("Error saving user profile: $e");
    }
  }

  Future<void> updateWatchedMoviesInProfile(UserProfile userProfile,int movieId) async{
    try{
      final userRef = _db.collection('user_profiles').doc(userProfile.userId);
      await userRef.update({'watchedMovies':[...userProfile.watchedMovies,movieId]});

    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> removeFromWatchedMovies(UserProfile userProfile,int movieId) async{
    final updatedWatchedMovies= userProfile.savedMovies.where((element) => element!=movieId,).toList();
    try{
      final userRef = _db.collection('user_profiles').doc(userProfile.userId);
      await userRef.update({'watchedMovies':[...updatedWatchedMovies]});
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> updateSavedMoviesInProfile(UserProfile userProfile,int movieId) async{
    try{
      final userRef = _db.collection('user_profiles').doc(userProfile.userId);
      await userRef.update({'savedMovies':[...userProfile.savedMovies,movieId]});

    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> removeFromSavedMovies(UserProfile userProfile,int movieId) async{
    final updatedSavedMovies= userProfile.savedMovies.where((element) => element!=movieId,).toList();
    try{
      final userRef = _db.collection('user_profiles').doc(userProfile.userId);
      await userRef.update({'savedMovies':[...updatedSavedMovies]});
    }catch(e){
      throw Exception(e);
    }
  }

  // Fetch a UserProfile from Firestore by userId (using Firebase Auth UID)
  Future<UserProfile?> fetchUserProfile(String uid) async {
    try {

      final userDoc = await _db.collection('user_profiles').doc(uid).get();

      if (userDoc.exists) {
        return UserProfile.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  // Fetch all user profiles (optional, for admin or general user data)
  Future<List<UserProfile>> fetchAllUserProfiles() async {
    try {
      final snapshot = await _db.collection('user_profiles').get();
      return snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching all user profiles: $e");
      return [];
    }
  }
}
