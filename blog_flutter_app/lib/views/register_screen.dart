import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  final String baseUrl;
  const RegisterScreen({super.key, required this.baseUrl});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _dirController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  bool isLoading = false;

  Future<void> registerUser() async {
    final name = _nameController.text.trim();
    final mail = _mailController.text.trim();
    final pass = _passController.text;
    final dir = _dirController.text.trim();
    final tip = _tipController.text.trim();

    if (name.isEmpty || mail.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor llena los campos obligatorios")),
      );
      return;
    }

    if (pass.runes.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La contraseña debe tener al menos 8 caracteres")),
      );
      return;
    }

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse("${widget.baseUrl}/RegistroUsuario"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nom_usr": name,
          "mail": mail,
          "pass_": pass,
          "dir_usr": dir,
          "tip_usu": tip.isEmpty ? "usuario" : tip,
        }),
      );

      setState(() { isLoading = false; });

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Registro exitoso! Ya puedes iniciar sesión")),
        );
        Navigator.pop(context); // Volver al Login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrarse. El correo podría ya estar en uso.")),
        );
      }
    } catch (e) {
      setState(() { isLoading = false; });
      print("Error de red: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Usuario"), foregroundColor:Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nombre de Usuario", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _mailController, decoration: const InputDecoration(labelText: "Correo Electrónico", border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextField(controller: _passController, decoration: const InputDecoration(labelText: "Contraseña", helperText: "Debe tener al menos 8 caracteres", border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 12),
              TextField(controller: _dirController, decoration: const InputDecoration(labelText: "Dirección", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _tipController, decoration: const InputDecoration(labelText: "Tipo de Usuario", border: OutlineInputBorder())),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      onPressed: registerUser,
                      child: const Text("Registrarse", style: TextStyle(fontSize: 16)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
