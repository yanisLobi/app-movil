import 'package:blog_flutter_app/views/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color forest = Color(0xFF344A35);
    const Color sage = Color(0xFF71896D);
    const Color moss = Color(0xFF8FA58A);
    const Color paleSage = Color(0xFFD4DFD0);
    const Color softSage = Color(0xFFE4EBE1);
    const Color warmBg = Color(0xFFEAF0E7);
    const String baseUrl = "https://9wc8k4l0-8000.usw3.devtunnels.ms";

    return MaterialApp(
      title: 'Blog App Integrador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: forest,
          onPrimary: Colors.white,
          primaryContainer: paleSage,
          onPrimaryContainer: forest,
          secondary: sage,
          onSecondary: Colors.white,
          secondaryContainer: softSage,
          onSecondaryContainer: forest,
          tertiary: moss,
          onTertiary: forest,
          tertiaryContainer: paleSage,
          onTertiaryContainer: forest,
          surface: Color(0xFFF1F5EF),
          onSurface: forest,
        ),
        scaffoldBackgroundColor: warmBg,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: sage,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: forest),
        listTileTheme: const ListTileThemeData(
          selectedColor: forest,
          selectedTileColor: paleSage,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: const Color(0xFFF1F5EF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: forest,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5EF),
          prefixIconColor: forest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: moss),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: forest, width: 2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: forest),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: forest),
          bodyMedium: TextStyle(color: forest),
        ),
      ),
      home: const LoginScreen(baseUrl: baseUrl),
    );
  }
}
