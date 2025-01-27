import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/viewmodels/movie_details_viewmodel.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';
import 'package:movie_app/views/movie_details_screen.dart';

class SimilarMoviesWidget extends ConsumerWidget {
  final List<Map<String, dynamic>>
      similarMovies;

  const SimilarMoviesWidget({super.key, required this.similarMovies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Movies',
            style: AppSettings.regularSemibold,
          ),
          SizedBox(height: 10,),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6),
            itemCount: similarMovies.length,
            itemBuilder: (context, index) {
              final movie = similarMovies[index];

              return InkWell(
                onTap: () async{
                  Movie movieObject = await ref.read(moviesStateProvider.notifier).fetchOneMovie(movie['id'].toString());
                  if(context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movieObject),));
                  }

                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(

                        movie['imageUrl'] ?? '',
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text('No Poster'));
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    SizedBox(
                      width:100,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        movie['title'] ?? 'Unknown',
                        style:
                            const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
