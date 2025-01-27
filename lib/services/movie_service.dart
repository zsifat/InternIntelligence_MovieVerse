import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/movie_details_model.dart';
import 'package:movie_app/models/movie_model.dart';

class MovieService {
  final String apiKey = AppSettings.apiKey;
  final String baseUrl = AppSettings.apiBaseUrl;

  // Fetch popular movies
  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final url = Uri.parse("$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=$page");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List moviesJson = data['results'];

        return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to load popular movies");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch movies by genre
  Future<List<Movie>> fetchMoviesByGenre(int genreId,{int pageNo=1}) async {
    final url = Uri.parse("$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&page=$pageNo");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List moviesJson = data['results'];

        return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to load movies by genre");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch top-rated movies
  Future<List<Movie>> fetchTopRatedMovies() async {
    final url = Uri.parse("$baseUrl/movie/top_rated?api_key=$apiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List moviesJson = data['results'];

        return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to load top-rated movies");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MovieDetails.fromJson(data);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<List<String>> fetchTrailers(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .where((video) => video['type'] == 'Trailer' && video['site'] == 'YouTube')
          .map<String>((video) => 'https://www.youtube.com/watch?v=${video['key']}')
          .toList();
    } else {
      throw Exception('Failed to load trailers');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCast(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['cast'] as List)
          .map((cast) => {
                'name': cast['name'],
                'imageUrl': 'https://image.tmdb.org/t/p/w500${cast['profile_path']}',
              })
          .toList();
    } else {
      throw Exception('Failed to load cast');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSimilarMovies(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => {
                'id': movie['id'],
                'title': movie['title'],
                'imageUrl': 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              })
          .toList();
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  Future<Movie> fetchOneMovie(String movieId) async {
    const String baseUrl = "https://api.themoviedb.org/3/movie";
    final String url = "$baseUrl/$movieId?api_key=${AppSettings.apiKey}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Movie.fromOneJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load movie details: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching movie details: $e");
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final url = Uri.parse("$baseUrl/search/movie?api_key=$apiKey&query=$query&language=en-US&page=$page");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List moviesJson = data['results'];

        return moviesJson.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to search for movies");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
