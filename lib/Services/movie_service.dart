import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/actor.dart';
import 'database_helper.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Connectivity _connectivity = Connectivity();

  Future<List<Movie>> getPopularMovies() async {
    if (await _isOnline()) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'),
        );
        
        if (response.statusCode == 200) {
          final movies = _parseMovies(response);
          await _dbHelper.cacheMovies(movies, 'popular');
          return movies;
        }
      } catch (e) {
        print('Error fetching popular movies: $e');
      }
    }
    return await _dbHelper.getCachedMovies('popular');
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    if (await _isOnline()) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey'),
        );
        
        if (response.statusCode == 200) {
          final movies = _parseMovies(response);
          await _dbHelper.cacheMovies(movies, 'now_playing');
          return movies;
        }
      } catch (e) {
        print('Error fetching now playing movies: $e');
      }
    }
    return await _dbHelper.getCachedMovies('now_playing');
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    if (await _isOnline()) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&append_to_response=credits'),
        );
        
        if (response.statusCode == 200) {
          final movieDetail = _parseMovieDetail(response);
          await _dbHelper.cacheMovieDetail(movieDetail);
          return movieDetail;
        }
      } catch (e) {
        print('Error fetching movie details: $e');
      }
    }
    final cachedMovieDetail = await _dbHelper.getCachedMovieDetail(movieId);
    if (cachedMovieDetail != null) {
      return cachedMovieDetail;
    } else {
      throw Exception('Movie details not available offline');
    }
  }

  Future<Actor> getActorDetails(int actorId) async {
    if (await _isOnline()) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/person/$actorId?api_key=$_apiKey'),
        );
        
        if (response.statusCode == 200) {
          final actor = _parseActor(response);
          await _dbHelper.cacheActor(actor);
          return actor;
        }
      } catch (e) {
        print('Error fetching actor details: $e');
      }
    }
    final cachedActor = await _dbHelper.getCachedActor(actorId);
    if (cachedActor != null) {
      return cachedActor;
    } else {
      throw Exception('Actor details not available offline');
    }
  }

  List<Movie> _parseMovies(http.Response response) {
    final json = jsonDecode(response.body);
    return (json['results'] as List).map((m) => Movie.fromJson(m)).toList();
  }

  MovieDetail _parseMovieDetail(http.Response response) {
    final json = jsonDecode(response.body);
    return MovieDetail.fromJson(json);
  }

  Actor _parseActor(http.Response response) {
    final json = jsonDecode(response.body);
    return Actor.fromJson(json);
  }

  Future<bool> _isOnline() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}