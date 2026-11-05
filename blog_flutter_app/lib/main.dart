import 'package:blog_flutter_app/views/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xFF344238);
    const Color sage = Color(0xFFB9CEB1);
    const Color paleSage = Color(0xFFECF3E9);
    const Color honey = Color(0xFFEAD8B4);
    const Color paleHoney = Color(0xFFF7EFDF);
    const Color mauve = Color(0xFFE2D2E0);
    const Color paleMauve = Color(0xFFF3EBF2);
    const Color warmBg = Color(0xFFFFFCF6);
    const String baseUrl = "https://9wc8k4l0-8000.usw3.devtunnels.ms";

    return MaterialApp(
      title: 'Blog App Integrador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: sage,
          onPrimary: ink,
          primaryContainer: paleSage,
          onPrimaryContainer: ink,
          secondary: honey,
          onSecondary: ink,
          secondaryContainer: paleHoney,
          onSecondaryContainer: ink,
          tertiary: mauve,
          onTertiary: ink,
          tertiaryContainer: paleMauve,
          onTertiaryContainer: ink,
          surface: warmBg,
          onSurface: ink,
        ),
        scaffoldBackgroundColor: warmBg,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: paleSage,
          foregroundColor: ink,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ink,
          ),
        ),
        iconTheme: const IconThemeData(color: ink),
        listTileTheme: const ListTileThemeData(
          selectedColor: ink,
          selectedTileColor: paleMauve,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: paleHoney,
            foregroundColor: ink,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          prefixIconColor: ink,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: honey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: sage, width: 2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: ink),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: ink),
          bodyMedium: TextStyle(color: ink),
        ),
      ),
      home: const LoginScreen(baseUrl: baseUrl),
    );
  }
}
