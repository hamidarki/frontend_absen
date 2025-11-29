import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Presence',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5A7), // Teal
          primary: const Color(0xFF0EA5A7),
          secondary: const Color(0xFF14B8A6), // Teal Light
          tertiary: const Color(0xFF06B6D4), // Cyan
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0EA5A7),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0EA5A7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0EA5A7),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF14B8A6)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF14B8A6)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0EA5A7), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelStyle: TextStyle(color: Color(0xFF0EA5A7)),
          prefixIconColor: Color(0xFF0EA5A7),
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          margin: EdgeInsets.all(8),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF0EA5A7),
          contentTextStyle: TextStyle(color: Colors.white),
          actionTextColor: Colors.white70,
        ),
      ),
      home: LoginScreen(),
      routes: {'/login': (context) => LoginScreen()},
    );
  }
}
