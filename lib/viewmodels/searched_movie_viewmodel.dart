import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/viewmodels/states/movies_state.dart';
import '../services/movie_service.dart';

class SearchedMovieStateNotifier extends StateNotifier<MoviesState> {
  final MovieService _movieService;

  SearchedMovieStateNotifier(this._movieService) : super(const MoviesState());

  Future<void> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final results = await _movieService.searchMovies(query, page: page);
      state = state.copyWith(movies: results);
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to load movies. Try again later.");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final searchMoviesProvider = StateNotifierProvider<SearchedMovieStateNotifier, MoviesState>((ref) {
  return SearchedMovieStateNotifier(MovieService());
});
