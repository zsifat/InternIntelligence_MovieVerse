import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/services/movie_service.dart';
import 'package:movie_app/viewmodels/movie_details_state.dart';

class MovieDetailsViewModel extends StateNotifier<MovieDetailsState> {
  final MovieService _movieService;

  MovieDetailsViewModel(this._movieService) : super(MovieDetailsState());

  Future<void> fetchMovieDetails(int movieId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final trailers = await _movieService.fetchTrailers(movieId);
      final cast = await _movieService.fetchCast(movieId);
      final similarMovies = await _movieService.fetchSimilarMovies(movieId);

      state = state.copyWith(
        trailers: trailers,
        cast: cast,
        similarMovies: similarMovies,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final movieDetailsProvider =
    StateNotifierProvider.family<MovieDetailsViewModel, MovieDetailsState, int>((ref, movieId) {
  final movieService = MovieService();
  return MovieDetailsViewModel(movieService)..fetchMovieDetails(movieId);
});
