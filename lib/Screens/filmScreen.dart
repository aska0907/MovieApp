// screens/film_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:musicapp/Screens/actorScreen.dart';
import '../models/movie_detail.dart';
import '../providers/movie_providers.dart';

class FilmScreen extends ConsumerWidget {
  final int movieId;

  const FilmScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetail = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      body: movieDetail.when(
        data: (data) => _MovieDetailView(movie: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  final MovieDetail movie;

  const _MovieDetailView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w1280${movie.backdropPath}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[800]),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(movie.title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(' ${movie.voteAverage.toStringAsFixed(1)}'),
                  const SizedBox(width: 16),
                  const Icon(Icons.schedule),
                  Text(' ${movie.runtime} mins'),
                ],
              ),
              Wrap(
                spacing: 8,
                children: movie.genres.map((genre) => Chip(label: Text(genre))).toList(),
              ),
              const SizedBox(height: 16),
              Text('Overview', style: Theme.of(context).textTheme.titleLarge),
              Text(movie.overview),
              const SizedBox(height: 24),
              Text('Cast', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movie.cast.length,
                  itemBuilder: (context, index) {
                    final actor = movie.cast[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActorScreen(actorId: actor.id),
                        ),
                      ),
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: CachedNetworkImageProvider(
                                'https://image.tmdb.org/t/p/w200${actor.profilePath}',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(actor.name, 
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(actor.character,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}