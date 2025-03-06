import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/actor.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'movies.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE movies(
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            overview TEXT,
            voteAverage REAL,
            releaseDate TEXT,
            category TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE movie_details(
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            voteAverage REAL,
            runtime INTEGER,
            genres TEXT,
            cast TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE actors(
            id INTEGER PRIMARY KEY,
            name TEXT,
            profilePath TEXT,
            character TEXT,
            biography TEXT,
            birthday TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE movies ADD COLUMN category TEXT');
        }
      },
    );
  }

  Future<void> cacheMovies(List<Movie> movies, String category) async {
    final db = await database;
    final batch = db.batch();
    
    for (final movie in movies) {
      batch.insert(
        'movies',
        {
          ...movie.toMap(),
          'category': category,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<List<Movie>> getCachedMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Movie.fromMap(maps[i]));
  }

  Future<void> cacheMovieDetail(MovieDetail detail) async {
    final db = await database;
    await db.insert(
      'movie_details',
      {
        ...detail.toMap(),
        'cast': jsonEncode(detail.cast.map((a) => a.toMap()).toList()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MovieDetail?> getCachedMovieDetail(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movie_details',
      where: 'id = ?',
      whereArgs: [movieId],
    );
    return maps.isNotEmpty ? MovieDetail.fromMap({
      ...maps.first,
      'cast': jsonDecode(maps.first['cast']),
    }) : null;
  }

  Future<void> cacheActor(Actor actor) async {
    final db = await database;
    await db.insert(
      'actors',
      actor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Actor?> getCachedActor(int actorId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'actors',
      where: 'id = ?',
      whereArgs: [actorId],
    );
    return maps.isNotEmpty ? Actor.fromMap(maps.first) : null;
  }
}