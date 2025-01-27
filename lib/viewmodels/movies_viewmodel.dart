import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/services/movie_service.dart';
import '../models/movie_model.dart';
import 'states/movies_state.dart';

class MoviesViewModel extends StateNotifier<MoviesState> {
  final MovieService _movieService;

  int _currentPage = 1;
  bool _isLoadingMore = false;

  MoviesViewModel(this._movieService) : super(const MoviesState());

  Future<void> fetchInitialMovies() async {
    state = state.copyWith(isLoading: true);

    try {
      final movies = await _movieService.fetchPopularMovies();
      state = state.copyWith(isLoading: false, movies: movies);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchMoreMovies() async {
    if (_isLoadingMore) return; // Avoid multiple simultaneous fetches
    _isLoadingMore = true;

    try {
      _currentPage++;
      final moreMovies =
          await _movieService.fetchPopularMovies(page: _currentPage);
      state = state.copyWith(
        movies: [...state.movies, ...moreMovies], // Append new movies
      );
    } catch (e) {
      print('Error fetching more movies: $e');
    } finally {
      _isLoadingMore = false;
    }
  }

   Future<void> fetchInitialMoviesByGenre(int genreId) async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchMoviesByGenre(genreId);
      state = state.copyWith(isLoading: false, movies: movies);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<List<Movie>> fetchRecommendedMoviesByGenres(List<int> genreIds,List<Movie> watchedMovie) async {
    final List<Movie> recommendedMovies=[];
    try {
      for(int genreId in genreIds){
        final movies = await _movieService.fetchMoviesByGenre(genreId);
        for (var movie in movies) {
          if(!watchedMovie.any((watchedMovie) => watchedMovie.id==movie.id,)){
            bool isAlreadyAdded=recommendedMovies.any((element) => element.id==movie.id);
            if(!isAlreadyAdded){
              recommendedMovies.add(movie);
            }
          }
          }

        }
      recommendedMovies.sort((a, b) {
        final aMatchesTopGenres = a.genreIds?.any((id) => genreIds.contains(id)) ?? false;
        final bMatchesTopGenres = b.genreIds?.any((id) => genreIds.contains(id)) ?? false;

        if (aMatchesTopGenres && !bMatchesTopGenres) {
          return -1; // `a` should come before `b`
        } else if (!aMatchesTopGenres && bMatchesTopGenres) {
          return 1; // `b` should come before `a`
        } else {
          return 0; // Keep original order if both or neither match
        }
      });
      return recommendedMovies;
      } catch (e) {
      throw Exception(e);
    }}


  Future<void> fetchTopRatedMovies() async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchTopRatedMovies();
      state = state.copyWith(movies: movies, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<Movie> fetchOneMovie(String movieId) async{
    try{
      final oneMovie =await _movieService.fetchOneMovie(movieId);
      return oneMovie;
    } catch(e){
      throw Exception(e);
    }

  }

}

final movieServiceProvider = Provider<MovieService>((ref) => MovieService());

final moviesStateProvider =
    StateNotifierProvider<MoviesViewModel, MoviesState>(
  (ref) => MoviesViewModel(ref.read(movieServiceProvider)),
);
