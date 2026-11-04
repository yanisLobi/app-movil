import 'package:blog_flutter_app/views/login_screen.dart';
import 'package:blog_flutter_app/views/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos la paleta inspirada en tu imagen de referencia
    const Color primarySage = Color(0xFF8A9A86); // Verde salvia elegante
    const Color darkText = Color(0xFF2C3531);    // Verde carbón / texto principal
    const Color warmBg = Color(0xFFF4F1EA);      // Fondo crema / marfil suave
    const String baseUrl = "https://9wc8k4l0-8000.usw3.devtunnels.ms";

    return MaterialApp(
      title: 'Blog App Integrador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: primarySage,
          secondary: primarySage,
          surface: Colors.white,
          onSurface: darkText,
        ),
        scaffoldBackgroundColor: warmBg, // Fondo general crema suave
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primarySage,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            backgroundColor: primarySage,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: darkText),
          bodyMedium: TextStyle(color: darkText),
        ),
      ),
      home: const SplashScreen(baseUrl: baseUrl),
    );
  }
}