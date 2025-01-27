import 'package:movie_app/config/app_settings.dart';

class Movie {
  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final String? releaseDate;
  final String? originalLanguage;
  final List<int>? genreIds;
  final double? popularity;

  Movie({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
    this.originalLanguage,
    this.genreIds,
    this.popularity,
  });

  // Factory constructor to create a Movie object from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      originalTitle: json['original_title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      releaseDate: json['release_date'],
      originalLanguage: json['original_language'],
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((genre) => genre as int)
          .toList(),
      popularity: (json['popularity'] as num?)?.toDouble(),
    );
  }

  factory Movie.fromOneJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      originalTitle: json['original_title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      releaseDate: json['release_date'],
      originalLanguage: json['original_language'],
      genreIds: (json['genres'] as List<dynamic>?)
          ?.map((genre) => genre['id'] as int)
          .toList(),
      popularity: (json['popularity'] as num?)?.toDouble(),
    );
  }


  // Method to get the full URL for the poster image
  String? getPosterUrl() {
    if (posterPath != null) {
      return '${AppSettings.imageBaseUrl}$posterPath';
    }
    return null;
  }

  // Method to get the full URL for the backdrop image
  String? getBackdropUrl() {
    if (backdropPath != null) {
      return '${AppSettings.imageBaseUrl}$backdropPath';
    }
    return null;
  }
}
