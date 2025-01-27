class Review {
  final String userName; // Unique ID for the movie
  final double? rating; // User's rating (0-10)
  final String? review; // Review text
  final DateTime timestamp;

  Review({
    required this.userName,
    required this.rating,
    required this.review,
    required this.timestamp
  });
  // Convert a JSON object to MovieReview
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['userName'],
      rating: json['rating'],
      review: json['review'],
      timestamp: DateTime.parse(json['timestamp'])
    );
  }

  // Convert MovieReview to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'rating': rating,
      'review': review,
      'timestamp':timestamp.toIso8601String()
    };
  }
}