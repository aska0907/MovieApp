// services/movie_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/actor.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;

  // Movie lists
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'));
    return _parseMovies(response);
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey'));
    return _parseMovies(response);
  }

  // Movie details with cast
  Future<MovieDetail> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&append_to_response=credits'),
    );
    return _parseMovieDetail(response);
  }

  // Actor details
  Future<Actor> getActorDetails(int actorId) async {
    final response = await http.get(Uri.parse('$_baseUrl/person/$actorId?api_key=$_apiKey'));
    return _parseActor(response);
  }

  // Parsing methods
  List<Movie> _parseMovies(http.Response response) {
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['results'] as List).map((m) => Movie.fromJson(m)).toList();
    }
    throw Exception('Failed to load movies: ${response.statusCode}');
  }

  MovieDetail _parseMovieDetail(http.Response response) {
    if (response.statusCode == 200) {
      return MovieDetail.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load movie details: ${response.statusCode}');
  }

  Actor _parseActor(http.Response response) {
    if (response.statusCode == 200) {
      return Actor.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load actor details: ${response.statusCode}');
  }
}