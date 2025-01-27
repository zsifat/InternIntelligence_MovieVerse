import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';
import 'package:movie_app/viewmodels/user_profile_viewmodel.dart';
import 'package:movie_app/views/movie_details_screen.dart';

class SavedOrWatchedScreen extends ConsumerWidget {
  final bool isHistory;
  const SavedOrWatchedScreen({super.key,this.isHistory=false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).userProfile;

    if (userProfile == null || (userProfile.savedMovies.isEmpty && !isHistory)) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            isHistory ? 'Watched Movies':'Saved Movies',
            style: const TextStyle(color: CupertinoColors.white),
          ),
          backgroundColor: CupertinoColors.black,
        ),
        child: Center(
          child: Text(
            isHistory ? 'No movies watched yet.' : 'No saved movies yet.',
            style: AppSettings.regular,
          ),
        ),
      );
    }

    if (userProfile.watchedMovies.isEmpty && isHistory) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            'Watched Movies',
            style: TextStyle(color: CupertinoColors.white),
          ),
          backgroundColor: CupertinoColors.black,
        ),
        child: Center(
          child: Text(
            'No movies watched yet.',
            style: AppSettings.regular.copyWith(),
          ),
        ),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          isHistory ? 'Watched Movies':'Saved Movies',
          style: const TextStyle(color: CupertinoColors.white),
        ),
        backgroundColor: CupertinoColors.black,
      ),
      child: Container(
        color: Colors.black,
        child: FutureBuilder<List<Movie>>(
          future: _fetchMovies(ref,isHistory ? userProfile.watchedMovies : userProfile.savedMovies),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Failed to load movies. Please try again later.',
                  style: AppSettings.regular.copyWith(color: CupertinoColors.white),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final movies = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return _buildSavedMovieTile(movies[index], context,ref);
                },
              );
            } else {
              return Center(
                child: Text(
                  isHistory ? 'No movies Watched Yet' : 'No saved movies found.',
                  style: AppSettings.regular.copyWith(color: CupertinoColors.systemGrey2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Movie>> _fetchMovies(WidgetRef ref, List<int> movieIds) async {
    final movieFetchTasks = movieIds.map(
          (id) => ref.read(moviesStateProvider.notifier).fetchOneMovie(id.toString()),
    );

    return Future.wait(movieFetchTasks);
  }

  Widget _buildSavedMovieTile(Movie movie, BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Movie Poster
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                movie.getPosterUrl() ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 120,
                  color: CupertinoColors.systemGrey,
                  child: const Icon(
                    CupertinoIcons.photo,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),

            // Movie Info and Remove Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppSettings.regularSemibold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      movie.releaseDate?.substring(0, 4) ?? 'Unknown',
                      style: AppSettings.regular.copyWith(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey2,
                      ),
                    ),

                    // Remove Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,

                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            color: CupertinoColors.systemRed,
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () {
                          _removeMovie(ref, movie.id);
                          _showSnackBar(context, '${movie.title} has been removed.');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeMovie(WidgetRef ref, int movieId) async{
    if(isHistory){
      await ref.read(userProfileProvider.notifier).removeFromWatchedMovies(movieId);
    } else{
      await ref.read(userProfileProvider.notifier).removeFromSavedMovies(movieId);
    }

  }

  void _showSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the snack bar after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

}
