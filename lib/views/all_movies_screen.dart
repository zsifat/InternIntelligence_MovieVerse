import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';
import 'package:movie_app/views/widgets/movie_grid_item.dart'; // Your Movie model file

class AllMoviesScreen extends ConsumerStatefulWidget {
  const AllMoviesScreen({super.key});

  @override
  ConsumerState<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends ConsumerState<AllMoviesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(moviesStateProvider.notifier).fetchMoreMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieList = ref.watch(moviesStateProvider).movies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: Colors.black,
      ),
      body: movieList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 movies per row
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                final Movie movie = movieList[index];
                return MovieGridItem(movie: movie);
              },
            ),
    );
  }
}
