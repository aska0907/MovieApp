// providers/movie_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/Services/movie_service.dart' show movieServiceProvider;
import 'package:musicapp/models/movie.dart';
import '../models/actor.dart';
import '../models/movie_detail.dart';


final popularMoviesProvider = FutureProvider<List<Movie>>((ref) {
  return ref.read(movieServiceProvider).getPopularMovies();
});

final nowPlayingProvider = FutureProvider<List<Movie>>((ref) {
  return ref.read(movieServiceProvider).getNowPlayingMovies();
});

final movieDetailProvider = FutureProvider.family<MovieDetail, int>((ref, movieId) {
  return ref.read(movieServiceProvider).getMovieDetails(movieId);
});

final actorProvider = FutureProvider.family<Actor, int>((ref, actorId) {
  return ref.read(movieServiceProvider).getActorDetails(actorId);
});