import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';

import '../models/movie_model.dart';
import '../models/movie_review_model.dart';
import '../viewmodels/movie_reviews_viewmodel.dart';
import '../viewmodels/user_profile_viewmodel.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProfileProvider).userProfile?.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Reviews', style: AppSettings.regularBold.copyWith(fontSize: 22)),
      ),
      body: FutureBuilder(
        future: userId != null
            ? ref.read(movieReviewProvider.notifier).fetchAllReviewsByUserId(userId)
            : Future.value([]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index]['review'] as Review;
                final movieId = reviews[index]['movieId'] as String;

                return MovieReviewCard(movieId: movieId, review: review, ref: ref);
              },
            );
          }

          return Center(
            child: Text("No reviews yet.", style: AppSettings.regular.copyWith(fontSize: 18)),
          );
        },
      ),
    );
  }
}

class MovieReviewCard extends StatelessWidget {
  final String movieId;
  final Review review;
  final WidgetRef ref;

  const MovieReviewCard({
    super.key,
    required this.movieId,
    required this.review,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie?>(
      future: ref.read(moviesStateProvider.notifier).fetchOneMovie(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data != null) {
          final movie = snapshot.data!;
          return MovieReviewWidget(movie: movie, review: review);
        }

        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }
}

class MovieReviewWidget extends StatelessWidget {
  final Movie movie;
  final Review review;

  const MovieReviewWidget({
    super.key,
    required this.movie,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              movie.getPosterUrl() ?? '',
              errorBuilder: (context, error, stackTrace) => const Center(child: Text('No poster')),
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movie.title,
                  style: AppSettings.regularBold.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (review.rating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        DateFormat('dd-MMM yyyy').format(review.timestamp),
                        style: AppSettings.regular.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  review.review ?? '',
                  style: AppSettings.regular.copyWith(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
