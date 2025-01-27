import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/views/movie_details_screen.dart';
import '../models/movie_model.dart';
import '../viewmodels/searched_movie_viewmodel.dart';

class SearchScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(searchMoviesProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        middle: Text(
          "Search Movies",
          style: AppSettings.regularSemibold.copyWith(color: AppSettings.whiteCustom),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: "Search for movies...",
                style: AppSettings.regular,
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    ref.read(searchMoviesProvider.notifier).searchMovies(query);
                  }
                },
                onSuffixTap: () {
                  _searchController.clear();
                  ref.read(searchMoviesProvider.notifier).searchMovies(' ');
                },
              ),
            ),
            movieState.movies.isEmpty ? const Spacer(flex: 2,) :const SizedBox.shrink(),
            movieState.movies.isEmpty && !movieState.isLoading ? SvgPicture.asset('assets/images/search_icon.svg',height: 64,width: 64,) :const SizedBox.shrink(),
            movieState.movies.isEmpty ? const Center(child: Text('Search and Explore Movies')) :const SizedBox.shrink(),
            movieState.movies.isEmpty ? const Spacer() :const SizedBox.shrink(),
            if (movieState.isLoading)
              const Expanded(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            else if (movieState.errorMessage != null)
              Expanded(
                child: Center(
                  child: Text(
                    movieState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: movieState.movies.length,
                  itemBuilder: (context, index) {
                    final movie = movieState.movies[index];
                    return CupertinoListTile(
                      movie: movie,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CupertinoListTile extends StatelessWidget {
  final Movie movie;

  const CupertinoListTile({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(movie.posterPath!=null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie),
            ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: CupertinoColors.separator),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.posterPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    movie.getPosterUrl()!,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 100,
                  ),
                )
              else
                const Icon(
                  CupertinoIcons.photo,
                  size: 60,
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: AppSettings.regularSemibold
                            .copyWith(color: CupertinoColors.systemGrey4)),
                    const SizedBox(height: 4),
                    Text(
                      "Release Date: ${movie.releaseDate}",
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
