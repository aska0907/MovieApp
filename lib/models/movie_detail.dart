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

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'voteAverage': voteAverage,
      'runtime': runtime,
      'genres': genres.join(','), // Store as comma-separated string
      'cast': cast.map((actor) => actor.id).join(','), // Store actor IDs
    };
  }

  // Create from Map (database record)
  factory MovieDetail.fromMap(Map<String, dynamic> map) {
    return MovieDetail(
      id: map['id'],
      title: map['title'] ?? 'No Title',
      overview: map['overview'] ?? '',
      posterPath: map['posterPath'] ?? '',
      backdropPath: map['backdropPath'] ?? '',
      voteAverage: map['voteAverage'] ?? 0.0,
      runtime: map['runtime'] ?? 0,
      genres: (map['genres'] as String).split(','),
      cast: [], // We'll populate this separately from actors table
    );
  }

  // Existing JSON parser
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