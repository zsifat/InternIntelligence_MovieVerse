import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/models/movie_review_model.dart';
import 'package:movie_app/viewmodels/auth_state_viewmodel.dart';
import 'package:movie_app/viewmodels/genre_viewmodel.dart';
import 'package:movie_app/viewmodels/movie_details_viewmodel.dart';
import 'package:movie_app/viewmodels/movie_reviews_viewmodel.dart';
import 'package:movie_app/views/widgets/garadient_button_container.dart';
import 'package:movie_app/views/widgets/rating_widget.dart';
import 'package:movie_app/views/widgets/review_text_field.dart';
import 'package:movie_app/views/widgets/similar_movies_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'widgets/review_tile.dart';
import '../viewmodels/user_profile_viewmodel.dart';
import 'widgets/cast_widget.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  ConsumerState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  late YoutubePlayerController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final movieDetailsState = ref.watch(movieDetailsProvider(movie.id));
    final genres = ref.watch(genreProvider);
    final videoId = YoutubePlayer.convertUrlToId(
      movieDetailsState.isLoading || movieDetailsState.trailers.isEmpty
          ? ''
          : movieDetailsState.trailers.first,
    );

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
    bool isAlreadySaved =
        ref.watch(userProfileProvider).userProfile!.savedMovies.contains(movie.id);
    bool isAlreadyWatched =
        ref.watch(userProfileProvider).userProfile!.watchedMovies.contains(movie.id);

    return Scaffold(
      body: movieDetailsState.isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : movieDetailsState.errorMessage != null
              ? Center(child: Text(movieDetailsState.errorMessage!))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (videoId != null)
                        YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: _controller,
                            progressColors: const ProgressBarColors(
                              playedColor: CupertinoColors.activeBlue,
                            ),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                            onReady: () {
                              debugPrint('YouTube Player is ready.');
                            },
                          ),
                          builder: (context, player) => player,
                        )
                      else
                        Container(
                          height: 200,
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              'Trailer not available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                movie.title,
                                textAlign: TextAlign.center,
                                style: AppSettings.regularBold.copyWith(fontSize: 24,color: AppSettings.whiteCustom),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                movie.releaseDate != ''
                                    ? movie.releaseDate?.substring(0, 4) ?? 'N/A'
                                    : 'N/A',
                                style:
                                    AppSettings.regular.copyWith(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 45,
                                  child: InkWell(
                                    onTap: () {
                                      if (!isAlreadyWatched) {
                                        ref
                                            .read(userProfileProvider.notifier)
                                            .updateWatchedMoviesInProfile(movie.id);
                                        _showCupertinoSnackBar(context, 'Marked as Watched');
                                      } else {
                                        _showCupertinoSnackBar(context, 'Already Watched');
                                      }
                                    },
                                    child: GradientButtonContainer(
                                      buttonText: isAlreadyWatched ? 'Watched' : 'Mark Watched',
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    if (!isAlreadySaved) {
                                      ref
                                          .read(userProfileProvider.notifier)
                                          .updateSavedMoviesInProfile(movie.id);
                                      _showCupertinoSnackBar(context, 'Saved for Later');
                                    } else {
                                      _showCupertinoSnackBar(context, 'Already Saved');
                                    }
                                  },
                                  icon: isAlreadySaved
                                      ? const Icon(CupertinoIcons.bookmark_fill,
                                          size: 18, color: CupertinoColors.activeBlue)
                                      : const Icon(CupertinoIcons.bookmark,
                                          size: 18, color: Colors.white),
                                  color: AppSettings.greyCustom,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showCupertinoSnackBar(context, 'Download Feature will be added in Future.');
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.white,
                                  ),
                                  color: AppSettings.greyCustom,
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Handle share
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.share,
                                    color: Colors.white,
                                  ),
                                  color: AppSettings.greyCustom,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (movie.genreIds != null && movie.genreIds!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Genres',
                                    style: AppSettings.regularSemibold,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: movie.genreIds!
                                        .map((genreId) {
                                          final genre =
                                              genres.firstWhere((element) => element.id == genreId);
                                          return genre != null
                                              ? Chip(
                                                  label: Text(
                                                    genre.name,
                                                    style:
                                                        AppSettings.regular.copyWith(fontSize: 12),
                                                  ),
                                                  backgroundColor: CupertinoColors.secondaryLabel,
                                                )
                                              : Container();
                                        })
                                        .whereType<Widget>()
                                        .toList(),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            if (movie.overview != null && movie.overview!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: AppSettings.regularSemibold,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    movie.overview!,
                                    textAlign: TextAlign.justify,
                                    style: AppSettings.regular
                                        .copyWith(color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            CastWidget(cast: movieDetailsState.cast),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Rate this movie', style: AppSettings.regular),
                                const SizedBox(width: 10),
                                FutureBuilder(
                                  future: ref
                                      .read(movieReviewProvider.notifier)
                                      .fetchReviewSpecificMovie(
                                          ref.watch(userProfileProvider).userProfile!.userId,
                                          movie.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data!.rating != null) {
                                      return StarRating(
                                        initialRating: snapshot.data!.rating!,
                                        onRatingChanged: (rating) {
                                          ref.read(movieReviewProvider.notifier).updateMovieRating(
                                              ref.watch(userProfileProvider).userProfile!.userId,
                                              ref.watch(userProfileProvider).userProfile!.userName,
                                              rating,
                                              movie.id);

                                        },
                                      );
                                    } else {
                                      return StarRating(
                                        initialRating: 0,
                                        onRatingChanged: (rating) {
                                          ref.read(movieReviewProvider.notifier).updateMovieRating(
                                              ref.watch(userProfileProvider).userProfile!.userId,
                                              ref.watch(userProfileProvider).userProfile!.userName,
                                              rating,
                                              movie.id);

                                        },
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            ReviewTextField(
                              controller: TextEditingController(),
                              onReviewSubmitted: (review) {
                                ref.read(movieReviewProvider.notifier).updateMovieReview(
                                    ref.watch(userProfileProvider).userProfile!.userId,
                                    ref.watch(userProfileProvider).userProfile!.userName,
                                    review,
                                    movie.id);

                              },
                            ),
                            const SizedBox(height: 16),
                            StreamBuilder(
                              stream: ref.read(movieReviewProvider.notifier).fetchReviewsByMovieId(widget.movie.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data != null &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  final List<Review> reviews=snapshot.data!.docs.map((e) => Review.fromJson(e.data()),).toList();
                                  return ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      print(reviews[index].rating);
                                      return ReviewWidget(review: reviews[index]);
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: Text(
                                    'No reviews yet',
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ));
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SimilarMoviesWidget(similarMovies: movieDetailsState.similarMovies),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  void _showCupertinoSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.secondaryLabel,
              borderRadius: BorderRadius.circular(16),
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
              style: GoogleFonts.poppins(
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
