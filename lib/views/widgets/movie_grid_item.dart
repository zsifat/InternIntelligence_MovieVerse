import 'package:flutter/material.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/views/movie_details_screen.dart';

class AnimatedMovieGridItem extends StatelessWidget {
  final Movie movie;

  const AnimatedMovieGridItem({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        child: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: MovieGridItem(movie: movie),
        ),
      ),
    );
  }
}


class MovieGridItem extends StatelessWidget {
  final Movie movie;

  const MovieGridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MovieDetailsScreen(
            movie: movie,
          ),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.getPosterUrl()!,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey,
                child: const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(movie.title,
              maxLines: 1,
              style: AppSettings.regularBold.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              )),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage!.toStringAsFixed(1),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
