class MovieHistory {
  final String movieId; // Unique ID for the movie
  final String movieTitle; // Title of the movie
  final DateTime watchedDate; // Date when the movie was watched
  final double? rating; // User's rating for the movie (0-10), nullable if no rating is given
  final String? review; // User's review for the movie, nullable if no review is given

  MovieHistory({
    required this.movieId,
    required this.movieTitle,
    required this.watchedDate,
    this.rating, // Rating is optional
    this.review, // Review is optional
  });
  // Convert a JSON object to MovieHistory
  factory MovieHistory.fromJson(Map<String, dynamic> json) {
    return MovieHistory(
      movieId: json['movieId'],
      movieTitle: json['movieTitle'],
      watchedDate: DateTime.parse(json['watchedDate']),
      rating: json['rating']?.toDouble(),
      review: json['review'],
    );
  }

  // Convert MovieHistory to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'movieTitle': movieTitle,
      'watchedDate': watchedDate.toIso8601String(),
      'rating': rating,
      'review': review,
    };
  }
}