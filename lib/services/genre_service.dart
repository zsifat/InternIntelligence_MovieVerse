import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/genre_model.dart';

class GenreService {
  final String _baseUrl = AppSettings.apiBaseUrl;
  final String _apiKey = AppSettings.apiKey;

  Future<List<Genre>> fetchMovieGenres() async {
    final response = await http.get(Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> genres = data['genres'];
      return genres.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }
}
