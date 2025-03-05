// models/movie_detail.dart
import 'package:musicapp/models/actor.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int runtime;
  final List<String> genres;
  final List<Actor> cast;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.runtime,
    required this.genres,
    required this.cast,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List).map((g) => g['name'].toString()).toList(),
      cast: (json['credits']['cast'] as List)
          .map((actor) => Actor.fromJson(actor))
          .toList(),
    );
  }
}
