import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/models/movie_review_model.dart';
import 'package:movie_app/services/movie_review_db_service.dart';


class MovieReviewsNotifier extends StateNotifier<String> {
  final MovieDBService _movieDBService = MovieDBService();

  MovieReviewsNotifier() : super('');

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchReviewsByMovieId(int movieId) {
    try {
      final movieReviews = _movieDBService.getAllReviews(movieId);
      return movieReviews;
    } catch (e, stack) {
     throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllReviewsByUserId(String userId) async {
    try {
      final List<Map<String, dynamic>> userReviews = await _movieDBService.getAllUserReviews(userId);
      return userReviews;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Review?> fetchReviewSpecificMovie(String userId, int movieId) async {
    try {
      final review = await _movieDBService.getReviewByUser(movieId, userId);
      return review;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateMovieRating(String userId,String userName,double rating, int movieId) async {
    try {
      await _movieDBService.updateRating(movieId, userId,userName, rating);
    } catch (e, stack) {
      throw Exception(e);
    }
  }

  Future<void> updateMovieReview(String userId,String userName,String review, int movieId) async {
    try {
      await _movieDBService.updateReview(movieId, userId, userName, review);
    } catch (e, stack) {
      throw Exception(e);
    }
  }
}


final movieReviewProvider = StateNotifierProvider<MovieReviewsNotifier,String>((ref) {
  return MovieReviewsNotifier();
});
