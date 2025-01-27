class MovieDetailsState {
  final List<String> trailers;
  final List<Map<String, dynamic>> cast;
  final List<Map<String, dynamic>> similarMovies;
  final bool isLoading;
  final String? errorMessage;

  MovieDetailsState({
    this.trailers = const [],
    this.cast = const [],
    this.similarMovies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MovieDetailsState copyWith({
    List<String>? trailers,
    List<Map<String, dynamic>>? cast,
    List<Map<String, dynamic>>? similarMovies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MovieDetailsState(
      trailers: trailers ?? this.trailers,
      cast: cast ?? this.cast,
      similarMovies: similarMovies ?? this.similarMovies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
