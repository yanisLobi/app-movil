import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'posts_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String baseUrl;
  const LoginScreen({super.key, required this.baseUrl});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    final mail = _mailController.text.trim();
    final pass = _passController.text;

    if (mail.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${widget.baseUrl}/Login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mail": mail, "pass_": pass}),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // Redirigir al usuario al listado de posts si el login es exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PostsScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Correo o contraseña incorrectos")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error de conexión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_movil.png',
                    width: 220,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _mailController,
                    decoration: const InputDecoration(
                      labelText: "Correo Electrónico",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passController,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          onPressed: loginUser,
                          child: const Text("Entrar",
                              style: TextStyle(fontSize: 16)),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegisterScreen(baseUrl: widget.baseUrl)),
                      );
                    },
                    child: const Text("¿No tienes cuenta? Regístrate aquí"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
