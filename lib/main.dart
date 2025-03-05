import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musicapp/Screens/authScreen.dart';
import 'package:musicapp/Screens/homeScreen.dart';
import 'services/movie_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debugging Firebase initialization
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Debugging Hive initialization
  print('Initializing Hive...');
  try {
    await Hive.initFlutter();
    print('Hive initialized successfully');
  } catch (e) {
    print('Error initializing Hive: $e');
  }

  // Debugging dotenv initialization
  print('Loading environment variables...');
  try {
    await dotenv.load(fileName: ".env");
    print('Environment variables loaded successfully');
  } catch (e) {
    print('Error loading .env: $e');
  }

  // Run the app after all initialization is done
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
        data: (user) {
          print('Auth state: ${user != null ? 'Logged in' : 'Logged out'}');
          return user != null ? const HomeScreen() : const AuthScreen();
        },
        loading: () {
          print('Loading auth state...');
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
        error: (error, _) {
          print('Auth error: $error');
          return Center(child: Text('Auth Error: $error'));
        },
      ),
    );
  }
}
