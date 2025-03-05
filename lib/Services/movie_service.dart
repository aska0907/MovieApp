import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'),
    );
    return _parseMovies(response);
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey'),
    );
    return _parseMovies(response);
  }

  List<Movie> _parseMovies(http.Response response) {
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
    }
    throw Exception('Failed to load movies: ${response.statusCode}');
  }
}