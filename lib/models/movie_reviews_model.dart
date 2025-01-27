import 'package:movie_app/models/movie_review_model.dart';

class MovieReviews {
  final String movieId;
  final List<Review> reviews;

  MovieReviews({
    required this.movieId,
    required this.reviews,
  });

  factory MovieReviews.fromJson(Map<String, dynamic> json) {
    final List reviewsJson = json['reviews'] ?? [];
    return MovieReviews(
      movieId: json['movieId'],
      reviews: reviewsJson.map((e) => Review.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }
}
