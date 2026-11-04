import 'package:blog_flutter_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post_detail_screen.dart';


class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});


  @override
  State<PostsScreen> createState() => _PostsScreenState();
}


class _PostsScreenState extends State<PostsScreen> {
  // Ajusta esta URL según tu entorno (10.0.2.2 para emulador Android, 127.0.0.1 para Web)
  final String baseUrl = "https://9wc8k4l0-8000.usw3.devtunnels.ms";
  
  List<dynamic> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';


  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }


  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });


    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));


      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar posts (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Revisa CORS/URL base: $e';
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts del Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPosts,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Toma tu verde editorial
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF8A9A86)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Libria App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Usuario Activo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Opción de Posts (Te mantiene o recarga la vista actual)
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Posts'),
              onTap: () {
                Navigator.pop(context); // Cierra el menú lateral
              },
            ),
            
            const Divider(),
            
            // Opción para Cerrar Sesión
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Cerrar Sesión', 
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                // Te regresa al login y borra el historial para que no pueda volver con "atrás"
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(baseUrl: baseUrl),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _fetchPosts, child: const Text('Reintentar'))
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${post['id_blog']}'),
                        ),
                        title: Text(
                          post['titulo'] ?? 'Sin título',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post['desc'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(
                                blogId: post['id_blog'],
                                baseUrl: baseUrl,
                              ),
                            ),
                          ).then((_) => _fetchPosts()); // Recargar al volver
                        },
                      ),
                    );
                  },
                ),
    );
  }
}