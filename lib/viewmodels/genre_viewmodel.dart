import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/models/genre_model.dart';
import 'package:movie_app/services/genre_service.dart';


class GenreNotifier extends StateNotifier<List<Genre>> {
  GenreNotifier() : super([]);

  final GenreService _genreService = GenreService();

  Future<void> loadGenres() async {
    try {
      final genres = await _genreService.fetchMovieGenres();
      state = genres;
    } catch (e) {
      state = [];
    }
  }
}

final genreProvider = StateNotifierProvider<GenreNotifier, List<Genre>>((ref) {
  return GenreNotifier();
});
