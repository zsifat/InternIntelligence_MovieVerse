import 'package:equatable/equatable.dart';
import 'package:movie_app/models/movie_model.dart';

class MoviesState extends Equatable {
  final List<Movie> movies;
  final bool isLoading;
  final String? errorMessage;

  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MoviesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [movies, isLoading, errorMessage];
}
