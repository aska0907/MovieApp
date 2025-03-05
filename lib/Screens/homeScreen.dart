import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musicapp/Screens/filmScreen.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';

final popularMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.read(movieServiceProvider).getPopularMovies();
});

final nowPlayingProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.read(movieServiceProvider).getNowPlayingMovies();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popular = ref.watch(popularMoviesProvider);
    final nowPlaying = ref.watch(nowPlayingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Stream'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(popularMoviesProvider.future),
        child: ListView(
          children: [
            _MovieSection(
              title: 'Now Playing',
              movies: nowPlaying,
              isHorizontal: true,
            ),
            _MovieSection(
              title: 'Popular Movies',
              movies: popular,
              isHorizontal: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieSection extends ConsumerWidget {
  final String title;
  final AsyncValue<List<Movie>> movies;
  final bool isHorizontal;

  const _MovieSection({
    required this.title,
    required this.movies,
    required this.isHorizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: isHorizontal ? 220 : null,
            child: movies.when(
              data: (movies) => isHorizontal
                  ? _HorizontalList(movies: movies)
                  : _MovieGrid(movies: movies),
              loading: () => _LoadingShimmer(isHorizontal: isHorizontal),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalList extends StatelessWidget {
  final List<Movie> movies;
  const _HorizontalList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilmScreen(movieId: movie.id),
            ),
          ),
          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[800]),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  const _MovieGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilmScreen(movieId: movie.id),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey[800]),
            ),
          ),
        );
      },
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  final bool isHorizontal;
  const _LoadingShimmer({required this.isHorizontal});

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, __) => Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              color: Colors.grey[800],
            ),
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (_, __) => Container(color: Colors.grey[800]),
          );
  }
}