import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/config/app_settings.dart';
import 'package:movie_app/viewmodels/genre_viewmodel.dart';
import 'package:movie_app/viewmodels/states/movies_state.dart';
import 'package:movie_app/viewmodels/movies_viewmodel.dart';
import 'package:movie_app/viewmodels/ui_viewmodels/category_select_viewmodel.dart';
import 'package:movie_app/viewmodels/user_profile_viewmodel.dart';
import 'package:movie_app/views/all_movies_screen.dart';
import 'package:movie_app/views/movie_details_screen.dart';
import 'package:movie_app/views/widgets/garadient_button_container.dart';
import 'package:movie_app/views/widgets/movie_grid_item.dart';
import '../models/genre_model.dart';
import '../models/movie_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        ref.read(moviesStateProvider.notifier).fetchMoreMovies();
      }
    });
    // Start the animation when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(moviesStateProvider);
    final genres = ref.watch(genreProvider);
    final selectedCategory = ref.watch(categorySelectedProvider);

    return Scaffold(
      body: movieState.isLoading
          ? const LinearProgressIndicator(color: AppSettings.blueCustom)
          : movieState.errorMessage != null
              ? Center(child: Text("Error: ${movieState.errorMessage}"))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section with Fade-In Animation
                      FadeTransition(
                        opacity: _animationController,
                        child: _buildHeroSection(movieState),
                      ),
                      const SizedBox(height: 10),
                      _buildCategorySection(genres, selectedCategory),
                      const SizedBox(height: 30),

                      if (selectedCategory == 0) ...[
                        _buildSectionHeader("For You", "", onTap: () {}),
                        const SizedBox(height: 8),
                        _buildRecommendations(movieState),
                      ],
                      const SizedBox(height: 10),
                      _buildSectionHeader(
                        selectedCategory == 0
                            ? "Popular Movies"
                            : genres[selectedCategory - 1].name,
                        "See all",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AllMoviesScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),

                      // Movie Grid with Hover Animation
                      _buildMovieGrid(movieState),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeroSection(MoviesState movieState) {
    final theme = Theme.of(context);
    final movie = movieState.movies.first;
    bool isAlreadySaved =
        ref.watch(userProfileProvider).userProfile!.savedMovies.contains(movie.id);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Image.network(
          movie.getBackdropUrl()!,
          width: screenWidth,
          height: screenHeight * 0.35, // 35% of the screen height
          fit: BoxFit.cover,
        ),
        Container(
          width: screenWidth,
          height: screenHeight * 0.35,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildVoteBadge(),
                  const SizedBox(width: 5),
                  Text(
                    movie.voteAverage!.toStringAsFixed(1),
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontSize: 12,
                      color: AppSettings.whiteCustom,
                    ),
                  ),
                ],
              ),
              Text(
                movie.title,
                style: AppSettings.regularBold.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.34,
                    height: screenHeight * 0.05,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: const GradientButtonContainer(buttonText: 'Watch Now'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppSettings.greyCustom),
                    onPressed: () {
                      if (!isAlreadySaved) {
                        ref.read(userProfileProvider.notifier).updateSavedMoviesInProfile(movie.id);
                        _showCupertinoSnackBar(context, 'Saved for Later');
                      } else {
                        _showCupertinoSnackBar(context, 'Already Saved');
                      }
                    },
                    icon: isAlreadySaved
                        ? const Icon(CupertinoIcons.bookmark_fill,
                            size: 18, color: CupertinoColors.activeBlue)
                        : const Icon(CupertinoIcons.bookmark, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoteBadge() {
    return Container(
      width: 35,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(
          'Vote',
          style: AppSettings.regularBold.copyWith(
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(List<Genre> genres, int selectedCategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: AppSettings.regularSemibold.copyWith(fontSize: 18)),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genres.length + 1,
            itemBuilder: (context, index) {
              return _buildCategoryChip(index, genres, selectedCategory);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(int index, List<Genre> genres, int selectedCategory) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        ref.read(categorySelectedProvider.notifier).setCategory(index);
        if (index == 0) {
          ref.read(moviesStateProvider.notifier).fetchInitialMovies();
        } else {
          ref.read(moviesStateProvider.notifier).fetchInitialMoviesByGenre(genres[index - 1].id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          gradient: selectedCategory == index
              ? const LinearGradient(colors: [Color(0xFF4AB9FF), Color(0xFF0084F3)])
              : const LinearGradient(colors: [Color(0xFF272727), Color(0xFF272727)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            index == 0 ? 'All' : genres[index - 1].name,
            style: AppSettings.regular.copyWith(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendations(MoviesState movieState) {
    return FutureBuilder<List<Movie>>(
      future: _fetchRecommendedMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final recommendedMovies = snapshot.data!;
          return FadeTransition(
            opacity: _animationController,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: recommendedMovies.length,
                itemBuilder: (context, index) {
                  final movie = recommendedMovies[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie),));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.getPosterUrl()!,
                              width: 140,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              movie.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if(snapshot.hasData && snapshot.data!.isEmpty){
          return FadeTransition(
            opacity: _animationController,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: movieState.movies.length,
                itemBuilder: (context, index) {
                  final shuffledMovies=List.from(movieState.movies);
                  shuffledMovies.shuffle();
                  final movie = shuffledMovies[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(movie: movie),));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.getPosterUrl()!,
                              width: 140,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              movie.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<List<Movie>> _fetchRecommendedMovies() async {
    // Fetch watched movies
    final watchedMovieIds = ref.watch(userProfileProvider).userProfile?.watchedMovies ?? [];
    final watchedMovies = await Future.wait(
      watchedMovieIds
          .map((id) => ref.read(moviesStateProvider.notifier).fetchOneMovie(id.toString())),
    );

    // Extract genres from watched movies
    final genreCounts = <int, int>{};
    for (final movie in watchedMovies) {
      for (final genreId in movie.genreIds ?? []) {
        genreCounts[genreId] = (genreCounts[genreId] ?? 0) + 1;
      }
    }

    // Get top 2 genres
    final topGenres = genreCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topGenreIds = topGenres.take(2).map((entry) => entry.key).toList();

    // Fetch recommendations based on top genres
    return ref.read(moviesStateProvider.notifier).fetchRecommendedMoviesByGenres(
          topGenreIds,
          watchedMovies,
        );
  }

  Widget _buildSectionHeader(String title, String actionText, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppSettings.regularSemibold.copyWith(fontSize: 18)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style:
                AppSettings.regularSemibold.copyWith(fontSize: 16, color: AppSettings.blueCustom),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieGrid(MoviesState movieState) {
    final screenWidth = MediaQuery.of(context).size.width;

    return movieState.movies.isNotEmpty
        ? GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (screenWidth < 600) ? 2 : 3, // 2 for small screens, 3 for larger screens
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: movieState.movies.length,
            itemBuilder: (context, index) {
              final shuffledMovies = List.from(movieState.movies);
              shuffledMovies.shuffle();
              return AnimatedMovieGridItem(movie: shuffledMovies[index]);
            },
          )
        : const SizedBox.shrink();
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
