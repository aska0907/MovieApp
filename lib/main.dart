import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musicapp/Screens/authScreen.dart';
import 'package:musicapp/Screens/homeScreen.dart';

import 'package:musicapp/services/database_helper.dart';
import 'package:musicapp/services/movie_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Initialize Database
  print('Initializing Database...');
  try {
    final dbHelper = DatabaseHelper();
    await dbHelper.database;
    print('Database initialized successfully');
  } catch (e) {
    print('Error initializing database: $e');
  }

  // Load environment variables
  print('Loading environment variables...');
  try {
    await dotenv.load(fileName: ".env");
    print('Environment variables loaded successfully');
  } catch (e) {
    print('Error loading .env: $e');
  }

  runApp(const ProviderScope(child: MovieApp()));
}

class MovieApp extends ConsumerWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Movie Stream',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black87),
      ),
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const AuthScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Center(child: Text('Auth Error: $error')),
      ),
    );
  }
}