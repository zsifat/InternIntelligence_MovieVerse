import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';

class posterWidget extends StatelessWidget {
  final Movie movie;

  const posterWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg',
              ))),
    );
  }
}
