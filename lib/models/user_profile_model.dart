import 'movie_history_model.dart';
import 'movie_review_model.dart';

class UserProfile {
  String userId; // Unique ID for the user
  final String userName; // User's name
  final String email; // User's email
  final List<int> watchedMovies; // History of movies watched
  final List<String> preferredGenres; // Genres the user prefers
  final DateTime creationDate; // Date when the profile was created
  final List<int> savedMovies; // Movies saved by the user (movies the user wants to watch later)

  UserProfile({
    required this.userId,
    required this.userName,
    required this.email,
    required this.watchedMovies,
    required this.preferredGenres,
    required this.creationDate,
    required this.savedMovies,
  });

  // Convert a JSON object to UserProfile
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      watchedMovies: List<int>.from(json['watchedMovies']),
      preferredGenres: List<String>.from(json['preferredGenres']),
      creationDate: DateTime.parse(json['creationDate']),
      savedMovies: List<int>.from(json['savedMovies']),
    );
  }

  // Convert UserProfile to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'watchedMovies': watchedMovies,
      'preferredGenres': preferredGenres,
      'creationDate': creationDate.toIso8601String(),
      'savedMovies': savedMovies,
    };
  }


}