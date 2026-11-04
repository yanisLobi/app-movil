import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final String baseUrl;

  const SplashScreen({super.key, required this.baseUrl});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Temporizador de 3 segundos para cambiar automáticamente al Login
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(baseUrl: widget.baseUrl),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA), // Tu fondo crema editorial
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono decorativo acorde a Libralia / Blog
            const Icon(
              Icons.menu_book_rounded,
              size: 70,
              color: Color(0xFF8A9A86), 
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenidos a libria',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3531),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}