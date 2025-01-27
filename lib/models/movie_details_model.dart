import 'package:movie_app/config/app_settings.dart';

class MovieDetails {
  final String title;
  final String overview;
  final String backdropPath;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final int runtime;
  final List<String> genres;
  final String tagline;
  final String homepage;
  final List<String> spokenLanguages;
  final List<String> productionCompanies;
  final int budget;
  final int revenue;

  MovieDetails({
    required this.title,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.runtime,
    required this.genres,
    required this.tagline,
    required this.homepage,
    required this.spokenLanguages,
    required this.productionCompanies,
    required this.budget,
    required this.revenue,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List<dynamic>)
          .map((genre) => genre['name'] as String)
          .toList(),
      tagline: json['tagline'] ?? '',
      homepage: json['homepage'] ?? '',
      spokenLanguages: (json['spoken_languages'] as List<dynamic>)
          .map((language) => language['english_name'] as String)
          .toList(),
      productionCompanies: (json['production_companies'] as List<dynamic>)
          .map((company) => company['name'] as String)
          .toList(),
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }

  String getPosterUrl() {
    return '${AppSettings.imageBaseUrl}$posterPath';
  }

  // Method to get the full URL for the backdrop image
  String getBackdropUrl() {
    return '${AppSettings.imageBaseUrl}$backdropPath';
  }

  
}
