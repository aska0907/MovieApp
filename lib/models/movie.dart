// models/movie.dart
class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final DateTime? releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    this.releaseDate,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate?.toIso8601String(),
    };
  }

  // Create from Map (database record)
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'] ?? 'No Title',
      posterPath: map['posterPath'] ?? '',
      overview: map['overview'] ?? '',
      voteAverage: map['voteAverage'] ?? 0.0,
      releaseDate: map['releaseDate'] != null 
          ? DateTime.parse(map['releaseDate'])
          : null,
    );
  }

  // Existing JSON parser
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] != null && json['release_date'].isNotEmpty
          ? DateTime.parse(json['release_date'])
          : null,
    );
  }
}